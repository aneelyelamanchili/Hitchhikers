import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.websocket.Session;

import org.json.JSONException;
import org.json.JSONObject;

//import org.json.simple.JSONObject;

public class Application {
	private Map<Integer, ArrayList<String>> rideList; //what do we need to store in each ride, should it be in sql
	private Map<Integer, Integer> rideSize;
	public Application() {
		rideList = new HashMap<Integer, ArrayList<String>>();
		rideSize = new HashMap<Integer, Integer>();
		
		Connection conn = null;
		Statement st = null;
		ResultSet rs = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/Hitchhikers?user=root&password=root&useSSL=false");
			st = conn.createStatement();
			rs = st.executeQuery("SELECT * FROM CurrentTrips");
			while (rs.next()) {
				ArrayList<String> x = new ArrayList<>();
				x.add(rs.getString("Username"));
				rideList.put(rs.getInt("rideID"), x);
				rideSize.put(rs.getInt("rideID"), rs.getInt("TotalSeats"));
			}
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}
		
	}
	public void parseMessage(JSONObject message, Session session, WebSocketEndpoint wsep) {
		Connection conn = null;
		Statement st = null;
		ResultSet rs = null;
	   
	    try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/Hitchhikers?user=root&password=root&useSSL=false");
			st = conn.createStatement();
			
	        if (message.get("message").equals("signup")) {
				wsep.sendToSession(session, toBinary(signUp(message, session, conn)));
			}
			else if (message.get("message").equals("login")) {
				wsep.sendToSession(session, toBinary(signIn(message, session, conn)));
			}
			else if (message.get("message").equals("makeride")) {
				wsep.sendToSession(session, toBinary(makeRide(message, conn)));
			}
			else if (message.get("message").equals("joinride")) {
				wsep.sendToSession(session, toBinary(joinRide(message, conn)));
			}
			else if (message.get("message").equals("deleteride")) {
				
			}
			else if (message.get("message").equals("guestview")) {
				wsep.sendToSession(session, toBinary(guestView(message, conn)));
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

	public JSONObject signUp(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			String signupusername = (String) message.get("username");
			if (signupusername.length() > 0) {
				rs = st.executeQuery("SELECT * from TotalUsers");
				while (rs.next()) {
					if (rs.getString("Username").equals(signupusername)) {
						response.put("message", "signupfail");
						response.put("signupfail", "Username already exists.");
						return response;
						//return failed sign up message
					}
				}
				
				String signuppassword = (String)message.get("password");
				String signupage = (String)message.get("age");
				String signupemail = (String)message.get("email");
				String signuppicture = (String)message.get("picture");
				String signupdriver = (String)message.get("isDriver");
				String signupphonenumber = (String)message.get("phonenumber");
				
				if (signuppassword.equals("") || signupage.equals("") || signupemail.equals("") || signuppicture.equals("") || signupphonenumber.equals("") || signupdriver.equals("")) {
					response.put("message", "signupfail");
					response.put("signupfail", "Please fill in all of the fields.");
					return response;
					//return failed sign up message
				}
				int signupageint = -1;
				try {
					signupageint = Integer.parseInt(signupage);
				} catch (NumberFormatException e) {
					response.put("message", "signupfail");
					response.put("signupfail", "Please enter a valid age.");
					return response;
					//return failed sign up message
				}
				if (signupageint < 1) {
					response.put("message", "signupfail");
					response.put("signupfail", "Please enter a valid age.");
					return response;
					//return failed sign up message
				}
//				int signupphonenumberint = 0;
//				try {
//					signupphonenumberint = Integer.parseInt(signupphonenumber);
//				} catch (NumberFormatException e) {
//					response.put("message", "signupfail");
//					response.put("signupfail", "Please enter a valid phone number.");
//					return response;
//					//return failed sign up message
//				}
				
				int signupdriverint = 0;
				if (signupdriver.equals("yes")) {
					signupdriverint = 1;
				}
				
				//Account has successful inputs and is now entered into the database.
				String addUser = "('" + signupusername + "', '" + signuppassword + "', " + signupemail + ", '" + signupage + "', '" + signupphonenumber + "', '" + signuppicture + "', " + signupdriverint + ")";
				st.execute(Constants.SQL_INSERT_USER + addUser + ";");
				response.put("message", "signupsuccess");
				response.put("signupsuccess", "Account was made.");
				
				//User details for front-end.
				JSONObject userDetails = addUserToJSON(signupusername, conn);
				for (String key : JSONObject.getNames(userDetails)) {
					response.put(key, userDetails.get(key));
				}
				JSONObject feedDetails = addFeedToJSON(conn);
				for (String key : JSONObject.getNames(feedDetails)) {
					response.put(key, feedDetails.get(key));
				}
				
				//return all of the details of user and whatever is needed on frontend
				return response;
			}
			else {
				response.put("message", "signupfail");
				response.put("signupfail", "Please enter a username.");
				return response;
				//return failed sign up message
			}
		} catch (SQLException sqle) {
			try {
				response.put("message", "signupfail");
				response.put("signupfail", "Sign up failed.");
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return response;
	    } catch (JSONException e1) {
			e1.printStackTrace();
			return null;
		}
	}

	public JSONObject signIn(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			String signinusername = (String) message.get("username");
			String signinpassword = (String) message.get("password");
			if (signinusername.length() > 0 && signinpassword.length() > 0) {
				rs = st.executeQuery("SELECT * from TotalUsers WHERE username='" + signinusername + "';");
				if (rs.next()) {
					if (rs.getString("Password").equals(signinpassword)) {
						response.put("message", "loginsuccess");
						response.put("loginsuccess", "Logged in.");
						
						//User details for front-end.
						JSONObject userDetails = addUserToJSON(signinusername, conn);
						for (String key : JSONObject.getNames(userDetails)) {
							response.put(key, userDetails.get(key));
						}
						JSONObject feedDetails = addFeedToJSON(conn);
						for (String key : JSONObject.getNames(feedDetails)) {
							response.put(key, feedDetails.get(key));
						}
						//return all of the details of user and what is needed on front end
						return response;
					}
					else {
						response.put("message", "loginfail");
						response.put("loginfail", "Incorrect password.");
						return response;
					}
				}
				else {
					response.put("message", "loginfail");
					response.put("loginfail", "Username doesn't exist.");
					return response;
				}
			}
			else {
				response.put("message", "loginfail");
				response.put("loginfail", "Please fill in all of the fields.");
				return response;
			}
		} catch (SQLException sqle) {
			try {
				response.put("message", "loginfail");
				response.put("loginfailed", "Login failed.");
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return response;
	    } catch (JSONException e) {
			e.printStackTrace();
		} return response;
	}
	//for when to destroy ride, check database every time it is queried to see if any need to be deleted and delete them (addfeedtojson method)
	//make a dictionary of something, what was i doing idk fml
	public JSONObject makeRide(JSONObject message, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			String username = (String)message.getString("username");
			String origin = (String)message.getString("origin");
			String destination = (String)message.getString("destination");
			String carmodel = (String)message.getString("carmodel");
			String licenseplate = (String)message.getString("licenseplate");
			int cost = (int)message.getInt("cost");
			String datetime = (String)message.getString("datetime");
			String detours = (String)message.getString("detours");
			String hospitality = (String)message.getString("hospitality");
			String food = (String)message.getString("food");
			String luggage = (String)message.getString("luggage");
			int totalseats = (int)message.getInt("totalseats");
			
			//currently there is no preventing a ride from being created
			String addRide = "('" + username + "', '" + origin + "', '" + destination + "', '" + carmodel + "', '" + licenseplate + "', " + cost + ", '" + datetime + "', '" + detours + "', '" + hospitality + "', '" + food + "', '" + luggage + "', " + totalseats + ", " + (totalseats-1) + ")";
			st.execute(Constants.SQL_INSERT_RIDE + addRide + ";");
			
			ResultSet rs = null;
			rs = st.executeQuery("SELECT * FROM CurrentRides");
			while (rs.next()) {
				if (username.equals(rs.getString("Username")) && origin.equals(rs.getString("Origin")) && destination.equals(rs.getString("Destination")) && carmodel.equals(rs.getString("CarModel")) && hospitality.equals(rs.getString("Hospitality"))) {
					rideSize.put(rs.getInt("rideID"), totalseats-1);
					ArrayList<String> riders = new ArrayList<String>();
					riders.add(username);
					rideList.put(rs.getInt("rideID"), riders);
				}
			}
			
			response.put("message", "addridesuccess");
			JSONObject userDetails = addUserToJSON(username, conn);
			for (String key : JSONObject.getNames(userDetails)) {
				response.put(key, userDetails.get(key));
			}
			JSONObject feedDetails = addFeedToJSON(conn);
			for (String key : JSONObject.getNames(feedDetails)) {
				response.put(key, feedDetails.get(key));
			}
			return response;
		} catch (SQLException sqle) {
			try {
				response.put("message", "addridefail");
				response.put("addridefail", "Adding ride failed.");
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return response;
	    } catch (JSONException e) {
			e.printStackTrace();
			return response;
		}
	}
	public JSONObject joinRide(JSONObject message, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			int rideid = message.getInt("rideid");
			String username = message.getString("username");
			ArrayList<String> currentriders = rideList.get(rideid);
			boolean notonride = true;
			for (int i=0; i<currentriders.size(); i++) {
				if (currentriders.get(i).equals(username)) {
					notonride = false;
				}
			}
			if (!notonride) {
				response.put("message", "addriderfail");
				response.put("addriderfail", "This user is already on the trip");
			}
			else if (notonride && currentriders.size() < rideSize.get(rideid)) {
				currentriders.add(username);
				rideList.put(rideid, currentriders);
				response.put("message", "addridersuccessful");
				ResultSet rs = st.executeQuery("SELECT * FROM CurrentTrips WHERE rideID=" + rideid + ";");
				if (rs.next()) {
					st.executeUpdate("UPDATE CurrentTrips set SeatsAvailable = " + (rs.getInt("SeatsAvailable")-1) + " WHERE rideID=" + rideid + ";");
				}
			}
			else {
				response.put("message", "addriderfail");
				response.put("addriderfail", "There is no space");
			}
			
			JSONObject userDetails = addUserToJSON(username, conn);
			for (String key : JSONObject.getNames(userDetails)) {
				response.put(key, userDetails.get(key));
			}
			JSONObject feedDetails = addFeedToJSON(conn);
			for (String key : JSONObject.getNames(feedDetails)) {
				response.put(key, feedDetails.get(key));
			}
			
			return response;
		} catch (JSONException e) {
			e.printStackTrace();
			return response;
		} catch (SQLException e) {
			e.printStackTrace();
			return response;
		}
	}
	
	public JSONObject deleteRide(JSONObject message, Connection conn) {
		return null;
	}
	
	public JSONObject guestView(JSONObject message, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			response.put("message", "guestviewsuccess");
			JSONObject feedDetails = addFeedToJSON(conn);
			for (String key : JSONObject.getNames(feedDetails)) {
				response.put(key, feedDetails.get(key));
			}
			return response;
		} catch (JSONException e) {
			e.printStackTrace();
			try {
				response.put("message", "guestviewfail");
			} catch (JSONException e1) {
				e1.printStackTrace();
			}
			return response;
		}
	}
	
	public JSONObject addUserToJSON(String username, Connection conn) {
		JSONObject user = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			rs = st.executeQuery("SELECT * from TotalUsers WHERE username='" + username + "';");
			if (rs.next()) {
				user.put("username", rs.getString("Username"));
				user.put("password", rs.getString("Password"));
				user.put("age", rs.getString("Age"));
				user.put("picture", rs.getString("Picture"));
				user.put("email", rs.getString("Email"));
				user.put("phonenumber", rs.getString("PhoneNumber"));
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
			e.printStackTrace();
		}
		return user;
	}
	
	public JSONObject addFeedToJSON(Connection conn) {
		JSONObject feed = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			rs = st.executeQuery("SELECT * from CurrentTrips");
			//Loop through database of CurrentTrips
			int feedCounter = 0;
			int feedIndex = 1; 			//For keeping track of feed index
			while (rs.next()) {
				JSONObject currFeed = new JSONObject();
				String username = rs.getString("Username");
				Statement st1 = conn.createStatement();
				ResultSet rs1 = null;
				rs1 = st1.executeQuery("SELECT * from TotalUsers WHERE username='" + username + "';");
				if (rs1.next()) {
					currFeed.put("userpicture", rs1.getString("Picture"));
				}
				if (rs1 != null) {
					rs1.close();
				}
				if (st1 != null) {
					st1.close();
				}
				//make strings for each list of origins, destinations, cars, every single column in currenttrips table
				currFeed.put("rideid", rs.getString("rideID"));
				currFeed.put("username", rs.getString("Username"));
				currFeed.put("origin", rs.getString("StartingPoint"));
				currFeed.put("destination", rs.getString("DestinationPoint"));
				currFeed.put("carmodel", rs.getString("CarModel"));
				currFeed.put("licenseplate", rs.getString("LicensePlate"));
				currFeed.put("cost", rs.getString("Cost"));
				currFeed.put("datetime", rs.getString("Date/Time"));
				currFeed.put("detours", rs.getString("Detours"));
				currFeed.put("hospitality", rs.getString("Hospitality"));
				currFeed.put("food", rs.getString("Food"));
				currFeed.put("luggage", rs.getString("Luggage"));
				currFeed.put("totalseats", rs.getString("TotalSeats"));
				currFeed.put("seatsavailable", rs.getString("SeatsAvailable"));

				String users = "";
				for (int i=0; i<rideList.get(rs.getInt("rideID")).size(); i++) {
					if (i>0) {
						users += ", " + rideList.get(rs.getInt("rideID")).get(i);
					}
					else {
						users += rideList.get(rs.getInt("rideID")).get(i);
					}
				}
				currFeed.put("currentriders", users);
				feed.put("feed" + feedIndex, currFeed);

				//Increment trip counter + counter 
				feedCounter++; 
				feedIndex++;
			}
			//Placed feed size in the thing 
			feed.put("feedsize", feedCounter);
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return feed;
	}
	
	public byte[] toBinary(JSONObject message) {
		String messageToConvert = message.toString();
		byte[] converted = null;
		try {
			converted = messageToConvert.getBytes("UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return converted;
	}
	
	
	
	
	
	
	
	
	public JSONObject signUp(JSONObject message, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			String signupusername = (String) message.get("username");
			if (signupusername.length() > 0) {
				rs = st.executeQuery("SELECT * from TotalUsers");
				while (rs.next()) {
					if (rs.getString("Username").equals(signupusername)) {
						response.put("message", "signupfail");
						response.put("signupfail", "Username already exists.");
						return response;
						//return failed sign up message
					}
				}
				String signuppassword = (String)message.get("password");
				String signupage = (String)message.get("age");
				String signupemail = (String)message.get("email");
				String signuppicture = (String)message.get("picture");
				String signupdriver = (String)message.get("isDriver");
				String signupphonenumber = (String)message.get("phonenumber");
				if (signuppassword.equals("") || signupemail.equals("") || signuppicture.equals("") || signupdriver.equals("")) {
					response.put("message", "signupfail");
					response.put("signupfail", "Please fill in all of the fields.");
					return response;
					//return failed sign up message
				}
				int signupageint = -1;
				try {
					signupageint = Integer.parseInt(signupage);
				} catch (NumberFormatException e) {
					response.put("message", "signupfail");
					response.put("signupfail", "Please enter a valid age.");
					return response;
					//return failed sign up message
				}
				if (signupageint < 1) {
					response.put("message", "signupfail");
					response.put("signupfail", "Please enter a valid age.");
					return response;
					//return failed sign up message
				}
				int signupdriverint = 0;
				if (signupdriver.equals("yes")) {
					signupdriverint = 1;
				}
				
				//Account has successful inputs and is now entered into the database.
//				String addUser = "('" + signupusername + "', '" + signuppassword + "', " + signupage + ", '" + signupemail + "', '" + signuppicture + "', " + signupdriverbool + ")";
				String addUser = "('" + signupusername + "', '" + signuppassword + "', '" + signupemail + "', " + signupage + ", '" + signupphonenumber + "', '" + signuppicture + "', " + signupdriverint + ")";
//				System.out.println(Constants.SQL_INSERT_USER + addUser);
				st.execute(Constants.SQL_INSERT_USER + addUser + ";");
				response.put("message", "signupsuccess");
				response.put("signupsuccess", "Account was made.");
				
				//User details for front-end.
				JSONObject userDetails = addUserToJSON(signupusername, conn);
				for (String key : JSONObject.getNames(userDetails)) {
					response.put(key, userDetails.get(key));
				}
				JSONObject feedDetails = addFeedToJSON(conn);
				for (String key : JSONObject.getNames(feedDetails)) {
					response.put(key, feedDetails.get(key));
				}
				
				//return all of the details of user and whatever is needed on frontend
				return response;
			}
			else {
				response.put("message", "signupfail");
				response.put("signupfail", "Please enter a username.");
				return response;
				//return failed sign up message
			}
		} catch (SQLException sqle) {
			try {
				response.put("message", "signupfail");
				response.put("signupfail", "Sign up failed.");
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return response;
	    } catch (JSONException e1) {
			e1.printStackTrace();
			return response;
		}
	}
	@SuppressWarnings("finally")
	public JSONObject signIn(JSONObject message, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			String signinusername = (String) message.get("username");
			String signinpassword = (String) message.get("password");
			if (signinusername.length() > 0 && signinpassword.length() > 0) {
				rs = st.executeQuery("SELECT * from TotalUsers WHERE username='" + signinusername + "';");
				if (rs.next()) {
					if (rs.getString("Password").equals(signinpassword)) { //YOOOOO GET THE RIGHT COLUMN NUMBER
						response.put("message", "loginsuccess");
						response.put("loginsuccess", "Logged in.");
						
						//User details for front-end.
						JSONObject userDetails = addUserToJSON(signinusername, conn);
						for (String key : JSONObject.getNames(userDetails)) {
							response.put(key, userDetails.get(key));
						}
						JSONObject feedDetails = addFeedToJSON(conn);
						for (String key : JSONObject.getNames(feedDetails)) {
							response.put(key, feedDetails.get(key));
						}
						//return all of the details of user and what is needed on front end
						return response;
					}
					else {
						response.put("message", "loginfail");
						response.put("loginfail", "Incorrect password.");
						return response;
					}
				}
				else {
					response.put("message", "loginfail");
					response.put("loginfail", "Username doesn't exist.");
					return response;
				}
			}
			else {
				response.put("message", "loginfail");
				response.put("loginfail", "Please fill in all of the fields.");
				return response;
			}
		} catch (SQLException sqle) {
			try {
				response.put("message", "loginfail");
				response.put("loginfailed", "Login failed.");
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return response;
	    } catch (JSONException e) {
			e.printStackTrace();
		} return response;
	}
	public JSONObject parseMessage(JSONObject message) {
		Connection conn = null;
	    Statement st = null;
	    ResultSet rs = null;
	    Statement st1 = null;
	   
	    try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/Hitchhikers?user=root&password=root&useSSL=false");
	        st = conn.createStatement();
	        st1 = conn.createStatement();
			
	        if (message.get("message").equals("signup")) {
				return signUp(message, conn);
			}
			else if (message.get("message").equals("login")) {
				return signIn(message, conn);
			}
			else if (message.get("message").equals("joinride")) {
				return joinRide(message, conn);
			}
	        
		} catch (ClassNotFoundException | SQLException | JSONException e) {
			JSONObject response = new JSONObject();
			try {
				response.put("SQLFail", "SQL connection could not be made.");
			} catch (JSONException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();

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
	    		return null;
	    	}
		}
	    return null;
	}
}
