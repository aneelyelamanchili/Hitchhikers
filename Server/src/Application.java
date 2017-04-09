import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Map;

import javax.websocket.Session;

import org.json.JSONException;
import org.json.JSONObject;

//import org.json.simple.JSONObject;

public class Application {
	private Map<Integer, ArrayList<String>> rideList; //what do we need to store in each ride, should it be in sql
	public Application() {
		
	}
	@SuppressWarnings("unchecked")
	public void parseMessage(JSONObject message, Session session, WebSocketEndpoint wsep) {
		Connection conn = null;
	    Statement st = null;
	    ResultSet rs = null;
	   
	    try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/Hitchhikers?user=root&password=root&useSSL=false");
	        st = conn.createStatement();
	        
	        if (message.get("SignUpUsername")!=null) {
				wsep.sendToSession(session, toBinary(signUp(message, session, st, rs)));
			}
			else if (message.get("SignInUsername")!=null) {
				wsep.sendToSession(session, toBinary(signIn(message, session, st, rs)));
			}
	        
		} catch (ClassNotFoundException | SQLException | JSONException e) {
			JSONObject response = new JSONObject();
			try {
				response.put("SQLFail", "SQL connection could not be made.");
			} catch (JSONException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
			wsep.sendToSession(session, toBinary(response));
		} finally {
	    	try {
	    		if (rs != null) {
	    			rs.close();
	    		}
	    		if (st != null) {
	    			st.close();
	    		}
	    		if (conn != null) {
	    			conn.close();
	    		}
	    	} catch (SQLException sqle) {
	    		System.out.println(sqle.getMessage());
	    	}
		}
	}

	@SuppressWarnings("finally")
	public JSONObject signUp(JSONObject message, Session session, Statement st, ResultSet rs) {
		JSONObject response = new JSONObject();
		try {
			String signupusername = (String) message.get("SignUpUsername");
			if (signupusername.length() > 0) {
				rs = st.executeQuery("SELECT * from TotalUsers");
				while (rs.next()) {
					if (rs.getString("Username").equals(signupusername)) {
						response.put("signupfail", "Username already exists.");
						return response;
						//return failed sign up message
					}
				}
				if (message.get("Password")!=null || message.get("Age")!=null || message.get("Email")!=null || message.get("Picture")!=null || message.get("isDriver")!=null) {
					response.put("signupfail", "Please fill in all of the fields.");
					return response;
					//return failed sign up message
				}
				String signuppassword = (String)message.get("Password");
				String signupage = (String)message.get("Age");
				String signupemail = (String)message.get("Email");
				String signuppicture = (String)message.get("Picture");
				String signupdriver = (String)message.get("isDriver");
				if (signuppassword.equals("") || signupage.equals("") || signupemail.equals("") || signuppicture.equals("") || signupdriver.equals("")) {
					response.put("signupfail", "Please fill in all of the fields.");
					return response;
					//return failed sign up message
				}
				int signupageint = -1;
				try {
					signupageint = Integer.parseInt(signupage);
				} catch (NumberFormatException e) {
					response.put("signupfail", "Please enter a valid age.");
					return response;
					//return failed sign up message
				}
				if (signupageint < 1) {
					response.put("signupfail", "Please enter a valid age.");
					return response;
					//return failed sign up message
				}
				boolean signupdriverbool = false;
				if (signupdriver.equals("yes")) {
					signupdriverbool = true;
				}
				
				//Account has successful inputs and is now entered into the database.
				String addUser = "('" + signupusername + "', '" + signuppassword + "', " + signupage + ", '" + signupemail + "', '" + signuppicture + "', " + signupdriverbool + ")";
				st.execute(Constants.SQL_INSERT_USER + addUser + ";");
				response.put("signupsuccess", "Account was made.");
				
				//User details for front-end.
				JSONObject userDetails = addUserToJSON(signupusername, st, rs);
				for (String key : JSONObject.getNames(userDetails)) {
				  response.put(key, userDetails.get(key));
				}
				
				//return all of the details of user and whatever is needed on frontend
				return response;
			}
			else {
				response.put("signupfail", "Please enter a username.");
				return response;
				//return failed sign up message
			}
		} catch (SQLException sqle) {
			try {
				response.put("signupfail", "Sign up failed.");
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return response;
	    } catch (JSONException e1) {
			e1.printStackTrace();
		} finally {
			return null;
		}
	}
	@SuppressWarnings("finally")
	public JSONObject signIn(JSONObject message, Session session, Statement st, ResultSet rs) {
		JSONObject response = new JSONObject();
		try {
			String signinusername = (String) message.get("SignInUsername");
			String signinpassword = (String) message.get("SignInPassword");
			if (signinusername.length() > 0 && signinpassword.length() > 0) {
				rs = st.executeQuery("SELECT * from TotalUsers WHERE username='" + signinusername + "';");
				if (rs.next()) {
					if (rs.getString("Password").equals(signinpassword)) { //YOOOOO GET THE RIGHT COLUMN NUMBER
						response.put("signinsuccess", "Logged in.");
						
						//User details for front-end.
						JSONObject userDetails = addUserToJSON(signinusername, st, rs);
						for (String key : JSONObject.getNames(userDetails)) {
						  response.put(key, userDetails.get(key));
						}
						//return all of the details of user and what is needed on front end
						return response;
					}
					else {
						response.put("signinfail", "Incorrect password.");
						return response;
					}
				}
				else {
					response.put("signinfail", "Username doesn't exist.");
					return response;
				}
			}
			else {
				response.put("signinfail", "Please fill in all of the fields.");
				return response;
			}
		} catch (SQLException sqle) {
			try {
				response.put("signinfailed", "Sign in failed.");
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return response;
	    } catch (JSONException e) {
			e.printStackTrace();
		} finally {
			return null;
		}
	}
	//for profile, return all the deets of user x
	
	public JSONObject addUserToJSON(String username, Statement st, ResultSet rs) {
		JSONObject user = new JSONObject();
		try {
			rs = st.executeQuery("SELECT * from TotalUsers WHERE username='" + username + "';");
			if (rs.next()) {
				user.put("Username", rs.getString("Username"));
				user.put("Password", rs.getString("Password"));
				user.put("Age", rs.getString("Age"));
				user.put("Picture", rs.getString("Picture"));
				user.put("Email", rs.getString("Email"));
				if (rs.getBoolean("isDriver")) {
					user.put("isDriver", "yes");
				}
				else {
					user.put("isDriver", "no");
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return user;
	}
	
	public JSONObject addFeed() {
		return null;
	}
	
	public byte[] toBinary(JSONObject message) {
		String messageToConvert = message.toString();
		byte[] converted = null;
		try {
			converted = messageToConvert.getBytes("US_ASCII");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return converted;
	}
}
