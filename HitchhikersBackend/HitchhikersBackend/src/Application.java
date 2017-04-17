import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeSet;

import javax.websocket.Session;

import org.json.JSONException;
import org.json.JSONObject;


public class Application {
	/* 
	 * rideList is a map mapping rideID's to an ArrayList that holds the usernames that
	 * are going on that ride. rideSize is a map mapping rideID's to the size of that ride.
	 */
	private Map<Integer, TreeSet<String>> rideList;
	private Map<Integer, Integer> rideSize;
	private Map<String, ArrayList<String>> previousSearches;
	public Application() {
		rideList = new HashMap<Integer, TreeSet<String>>();
		rideSize = new HashMap<Integer, Integer>();
		previousSearches = new HashMap<String, ArrayList<String>>();
		
		/*
		 * Initially, any rides in the database should be added into the maps when the
		 * application is first constructed. Typically, this shouldn't happen but it was
		 * used in testing functionality.
		 */
		Connection conn = null;
		Statement st = null;
		ResultSet rs = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/Hitchhikers?user=root&password=root&useSSL=false");
			st = conn.createStatement();
			rs = st.executeQuery("SELECT * FROM CurrentTrips");
			while (rs.next()) {
				rideList.put(rs.getInt("rideID"), new TreeSet<String>());
				rideList.get(rs.getInt("rideID")).add(rs.getString("Username"));
				rideSize.put(rs.getInt("rideID"), rs.getInt("TotalSeats"));
			}
			Statement st1 = conn.createStatement();
			ResultSet rs1 = st1.executeQuery("SELECT * FROM TotalUsers");
			while (rs1.next()) {
				previousSearches.put(rs1.getString("Username"), new ArrayList<String>());
			}
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}	
	}
	/*
	 * ParseMessage is the main method used for figuring out what to do with a JSONObject sent
	 * from the frontend app to the backend through the WebSocketEndpoint. Here, other functions
	 * are called based on the "message".
	 * Input JSON - "message",_____
	 * Output JSON - object sent back to frontend
	 */
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
				wsep.sendToSession(session, toBinary(deleteRide(message, conn)));
			}
			else if (message.get("message").equals("guestview")) {
				wsep.sendToSession(session, toBinary(guestView(message, conn)));
			}
			else if (message.get("message").equals("search")) {
				wsep.sendToSession(session, toBinary(search(message, conn)));
			}
			else if (message.get("message").equals("searchview")) {
				wsep.sendToSession(session, toBinary(searchView(message, conn)));
			}
			else if (message.get("message").equals("refreshdata")) {
				wsep.sendToSession(session, toBinary(refreshData(message, conn)));
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

	/*
	 * When a user enters all of their information and clicks sign up, the data is then sent here.
	 * Input - "message","signup"
	 * 		   "username",___
	 * 		   "password",___
	 * 		   "age",___
	 * 		   "email",___
	 * 		   "picture",___
	 * 		   "isDriver",yes/no
	 * 		   "phonenumber",___
	 * Output - "message","signupsuccess"/"signupfail" 
	 * 			if signupfail --> "signupfail",reason
	 * 			User data returned along with feed data in JSON
	 */
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
				signuppassword.replaceAll("\\s+","");
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
				
				previousSearches.put(signupusername, new ArrayList<String>());
				
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

	/*
	 * When a user signs in, this is the function that deals with correct/incorrect info.
	 * Input - "message","login"
	 * 		   "username",___
	 * 		   "password",___
	 * Output - "message","loginsuccess"/"loginfail"
	 * 			if loginsuccess --> all of user data and feed data returned in JSON
	 * 			if loginfail --> "loginfail",reason
	 */
	public JSONObject signIn(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			String signinusername = (String) message.get("username");
			String signinpassword = (String) message.get("password");
			signinpassword.replaceAll("\\s+","");
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
	
	/*
	 * When a user clicks makeRide and has inputted all of the info, they are sent here.
	 * Input - "message","makeride"
	 * 		   "username",who posted/logged in
	 * 		   "origin",___
	 * 		   "destination",___
	 * 		   "carmodel",___
	 * 		   "licenseplate",___
	 * 		   "cost",___(int)
	 * 		   "datetime",___
	 * 		   "detours",___
	 * 		   "hospitality",___
	 * 		   "food",___
	 * 		   "luggage",___
	 * 		   "totalseats",___(int)
	 * Output - "message","makeridefail"/"makeridesuccess"
	 * 			all of the feed and the user's profile returned
	 */
	public JSONObject makeRide(JSONObject message, Connection conn) {
		JSONObject response = new JSONObject();
		String username = "";
		try {
			Statement st = conn.createStatement();
			username = (String)message.getString("username");
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
			
			if (username.equals("") || origin.equals("") || destination.equals("") || carmodel.equals("") || licenseplate.equals("") || datetime.equals("") || detours.equals("") || hospitality.equals("") || food.equals("") || luggage.equals("")) {
				response.put("message", "addridefail");
				response.put("addridefail", "Adding ride failed.");
				JSONObject userDetails = addUserToJSON(username, conn);
				for (String key : JSONObject.getNames(userDetails)) {
					try {
						response.put(key, userDetails.get(key));
					} catch (JSONException e1) {
						e1.printStackTrace();
					}
				}
				JSONObject feedDetails = addFeedToJSON(conn);
				for (String key : JSONObject.getNames(feedDetails)) {
					try {
						response.put(key, feedDetails.get(key));
					} catch (JSONException e1) {
						e1.printStackTrace();
					}
				}
				return response;
			}

			String addRide = "('" + username + "', '" + origin + "', '" + destination + "', '" + carmodel + "', '" + licenseplate + "', " + cost + ", '" + datetime + "', '" + detours + "', '" + hospitality + "', '" + food + "', '" + luggage + "', " + totalseats + ", " + (totalseats-1) + ")";
			st.execute(Constants.SQL_INSERT_RIDE + addRide + ";");
			
			ResultSet rs = null;
			rs = st.executeQuery("SELECT * FROM CurrentRides");
			while (rs.next()) {
				if (username.equals(rs.getString("Username")) && origin.equals(rs.getString("Origin")) && destination.equals(rs.getString("Destination")) && carmodel.equals(rs.getString("CarModel")) && hospitality.equals(rs.getString("Hospitality"))) {
					rideSize.put(rs.getInt("rideID"), totalseats-1);
					TreeSet<String> riders = new TreeSet<String>();
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
				JSONObject userDetails = addUserToJSON(username, conn);
				for (String key : JSONObject.getNames(userDetails)) {
					try {
						response.put(key, userDetails.get(key));
					} catch (JSONException e1) {
						e1.printStackTrace();
					}
				}
				JSONObject feedDetails = addFeedToJSON(conn);
				for (String key : JSONObject.getNames(feedDetails)) {
					try {
						response.put(key, feedDetails.get(key));
					} catch (JSONException e1) {
						e1.printStackTrace();
					}
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return response;
	    } catch (JSONException e) {
			e.printStackTrace();
			return response;
		}
	}
	
	/*
	 * When a user wants to join a ride, they can join if they are already not on the ride
	 * and it is not full yet.
	 * Input - "message","joinride"
	 * 		   "joinrideid",ride's ID
	 * 		   "username",loggedinuser
	 * Output - "message","addriderfail"/"addridersuccess"
	 * 			if "addriderfail" --> "addriderfail",reason
	 * 			returns feed + currentuser
	 */
	public JSONObject joinRide(JSONObject message, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			int rideid = message.getInt("joinrideid");
			String username = message.getString("username");
			TreeSet<String> currentriders = rideList.get(rideid);
//			boolean notonride = true;
//			for (int i=0; i<currentriders.size(); i++) {
//				if (currentriders.get(i).equals(username)) {
//					notonride = false;
//				}
//			}
			if (!currentriders.add(username)) {
				response.put("message", "addriderfail");
				response.put("addriderfail", "This user is already on the trip");
			}
			else if (currentriders.size() < rideSize.get(rideid)) {
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
	
	/*
	 * Only the poster of the ride can actually delete a ride. The ride is then
	 * added to the table TotalPreviousTrips in order to study behavior and deal with
	 * complaints following a ride.
	 * Input - "message","deleteride"
	 * 		   "deleterideid",rideid to delete
	 * 		   "username",loggedinuser
	 * Output - "message","deleteridefail"/"deleteridesuccessful"
	 * 			returns feed and user info
	 */
	public JSONObject deleteRide(JSONObject message, Connection conn) {
		String currentuser = "";
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			Statement st1 = conn.createStatement();
			currentuser = message.getString("username");
			int rideid = Integer.parseInt(message.getString("deleterideid"));//rn taking a string from ios
			ResultSet rs1 = st1.executeQuery("SELECT * FROM TotalUsers WHERE Username='" + currentuser + "';");
			int userid = -1;
			if (rs1.next()) {
				userid = rs1.getInt("userID");
			}
			ResultSet rs = st.executeQuery("SELECT * FROM CurrentTrips WHERE rideID=" + rideid + ";");
			String username="";
			if (rs.next()) {
				//return fail it is not this user's ride
				username = rs.getString("Username");
			}
			if (!username.equals(currentuser)) {
				response.put("message", "deleteridefail");
				JSONObject userDetails = addUserToJSON(currentuser, conn);
				for (String key : JSONObject.getNames(userDetails)) {
					response.put(key, userDetails.get(key));
				}
				JSONObject feedDetails = addFeedToJSON(conn);
				for (String key : JSONObject.getNames(feedDetails)) {
					response.put(key, feedDetails.get(key));
				}
				return response;
			}
			
			String origin = rs.getString("StartingPoint");
			String destination = rs.getString("DestinationPoint");
			String carmodel = rs.getString("CarModel");
			String licenseplate = rs.getString("LicensePlate");
			int cost = rs.getInt("Cost");
			String datetime = rs.getString("Date/Time");
			String detours = rs.getString("Detours");
			String hospitality = rs.getString("Hospitality");
			String food = rs.getString("Food");
			String luggage = rs.getString("Luggage");
			int totalseats = rs.getInt("TotalSeats");
			int seatsavailable = rs.getInt("SeatsAvailable");
			
			int seatsfilled = totalseats-seatsavailable;
			
			String insertride = "(" + rideid + ", " + userid + ", '"+ username + "', '" + origin + "', '" + destination + "', '" + carmodel + "', '" + licenseplate + "', " + cost + ", '" + datetime + "', '" + detours + "', '" + hospitality + "', '" + food + "', '" + luggage + "', " + totalseats + ", " + seatsfilled + ")";
			
			rideList.remove(rideid);
			rideSize.remove(rideid);
			st.execute(Constants.SQL_INSERT_PREVIOUSRIDE + insertride + ";");
			st.execute("DELETE FROM CurrentTrips WHERE rideID=" + rideid + ";");
			
			response.put("message", "deleteridesuccessful");
			
			JSONObject userDetails = addUserToJSON(currentuser, conn);
			for (String key : JSONObject.getNames(userDetails)) {
				response.put(key, userDetails.get(key));
			}
			JSONObject feedDetails = addFeedToJSON(conn);
			for (String key : JSONObject.getNames(feedDetails)) {
				response.put(key, feedDetails.get(key));
			}
			
			return response;
		} catch (SQLException | JSONException e) {
			e.printStackTrace();
			JSONObject userDetails = addUserToJSON(currentuser, conn);
			for (String key : JSONObject.getNames(userDetails)) {
				try {
					response.put(key, userDetails.get(key));
				} catch (JSONException e1) {
					e1.printStackTrace();
				}
			}
			JSONObject feedDetails = addFeedToJSON(conn);
			for (String key : JSONObject.getNames(feedDetails)) {
				try {
					response.put(key, feedDetails.get(key));
				} catch (JSONException e1) {
					e1.printStackTrace();
				}
			}
			return response;
		}
	}
	
	/*
	 * When a guest opens the app without logging in, this is a special view where they
	 * can view all of the rides but that is it.
	 * Input - "message","guestview"
	 * Output - all of the rides in the feed
	 */
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

	/*
	 * When a user searches, any rides in the feed with that string present in the destination
	 * should be returned to be viewed by the user to choose from.
	 * Input - "message","search"
	 * 		   "search",search query
	 * Output - all of the rides with the search query in the destination string
	 * 			user info
	 */
	public JSONObject search(JSONObject message, Connection conn) {
		JSONObject response = new JSONObject();
		String currentuser = "";
		try {
			currentuser = message.getString("username");
			String searchquery = message.getString("search");
			previousSearches.get(currentuser).add(searchquery);
			if (previousSearches.get(currentuser).size()>6) {
				previousSearches.get(currentuser).remove(0);
			}
			Statement st = conn.createStatement();
			ResultSet rs = null;
			rs = st.executeQuery("SELECT * FROM CurrentTrips");
			int feedIndex = 1;
			int feedCounter = 0;
			while (rs.next()) {
				String destination = rs.getString("DestinationPoint");
				if (destination.contains(searchquery)) {
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
//					for (int i=0; i<rideList.get(rs.getInt("rideID")).size(); i++) {
//						if (i>0) {
//							users += ", " + rideList.get(rs.getInt("rideID")).get(i);
//						}
//						else {
//							users += rideList.get(rs.getInt("rideID")).get(i);
//						}
//					}
					TreeSet<String> riders = rideList.get(rs.getInt("rideID"));
					users += riders;
					users = users.substring(1, users.length()-1);
					currFeed.put("currentriders", users);
					response.put("feed" + feedIndex, currFeed);

					//Increment trip counter + counter 
					feedCounter++; 
					feedIndex++;
				}
			}
			response.put("feedsize", feedCounter);
			response.put("message", "searchsuccess");
			
			JSONObject userDetails = addUserToJSON(currentuser, conn);
			for (String key : JSONObject.getNames(userDetails)) {
				response.put(key, userDetails.get(key));
			}
			return response;
		} catch (JSONException | SQLException e) {
			try {
				response.put("message", "searchfail");
				JSONObject userDetails = addUserToJSON(currentuser, conn);
				for (String key : JSONObject.getNames(userDetails)) {
					response.put(key, userDetails.get(key));
				}
			} catch (JSONException e1) {
				e1.printStackTrace();
			}
			JSONObject feedDetails = addFeedToJSON(conn);
			for (String key : JSONObject.getNames(feedDetails)) {
				try {
					response.put(key, feedDetails.get(key));
				} catch (JSONException e1) {
					e1.printStackTrace();
				}
			}
			return response;
		}
	}
	
	/*
	 * Returns the previously searched destinations for the user.
	 * Input - "message","searchview"
	 * 		   "username",current user of app
	 * Output - "message","searchviewsuccessful"/"searchviewfail"
	 * 			"previoussearchsize",int x
	 * 			"previoussearch1","previoussearch2" to x,string searched
	 * 			all of the user info and ride info
	 */
	public JSONObject searchView(JSONObject message, Connection conn) {
		JSONObject response = new JSONObject();
		String currentuser = "";
		try {
			currentuser = message.getString("username");
			ArrayList<String> searches = previousSearches.get(currentuser);
			for (int i=0; i<searches.size(); i++) {
				response.put("previoussearch" + (i+1), searches.get(i));
			}
			response.put("previoussearchsize", searches.size());
			response.put("message", "searchviewsuccessful");
			
			JSONObject userDetails = addUserToJSON(currentuser, conn);
			for (String key : JSONObject.getNames(userDetails)) {
				response.put(key, userDetails.get(key));
			}
			JSONObject feedDetails = addFeedToJSON(conn);
			for (String key : JSONObject.getNames(feedDetails)) {
				response.put(key, feedDetails.get(key));
			}
			return response;
		} catch (JSONException e) {
			try {
				response.put("message", "searchviewfail");
				JSONObject userDetails = addUserToJSON(currentuser, conn);
				for (String key : JSONObject.getNames(userDetails)) {
					response.put(key, userDetails.get(key));
				}
			} catch (JSONException e1) {
				e1.printStackTrace();
			}
			JSONObject feedDetails = addFeedToJSON(conn);
			for (String key : JSONObject.getNames(feedDetails)) {
				try {
					response.put(key, feedDetails.get(key));
				} catch (JSONException e1) {
					e1.printStackTrace();
				}
			}
			return response;
		}
	}
	/*
	 * Just returns the feed and user data.
	 * input - "message","getdata"
	 * 		   "username",current user of app
	 * Output - "message","getdatasuccess"
	 * 			user and feed data
	 */
	public JSONObject refreshData(JSONObject message, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			String username = message.getString("username");
			JSONObject userDetails = addUserToJSON(username, conn);
			for (String key : JSONObject.getNames(userDetails)) {
				response.put(key, userDetails.get(key));
			}
			JSONObject feedDetails = addFeedToJSON(conn);
			for (String key : JSONObject.getNames(feedDetails)) {
				response.put(key, feedDetails.get(key));
			}
			response.put("message", "getdatasuccess");
			return response;
		} catch(JSONException e) {
			e.printStackTrace();
			try {
				response.put("message", "getdatafail");
			} catch (JSONException e1) {
				e1.printStackTrace();
			}
			return response;
		}
	}
	
	/*
	 * Returns the info for the user that sent the message to the backend to be returned.
	 * Input - username
	 * Output - "username"
	 * 			"password"
	 * 			"age"
	 * 			"picture"
	 * 			"email"
	 * 			"phonenumber"
	 * 			"isDriver","yes"/"no"
	 */
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
	/*
	 * Returns all of the rides that exist in the CurrentRides table in the database.
	 * Output - "feedsize", number of rides in feed
	 * 			JSON "feed"+x (ex. feed1 or feed2)
	 * 				"username",who posted ride
	 * 				"userpicture",picture of poster
	 * 				"rideid"
	 * 				"origin"
	 * 				"destination"
	 * 				"carmodel"
	 * 				"licenseplate"
	 * 				"cost"
	 * 				"datetime"
	 * 				"detours"
	 * 				"hospitality"
	 * 				"food"
	 * 				"luggage"
	 * 				"totalseats"
	 * 				"seatsavailable"
	 * 				"currentriders",string list of riders
	 */
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
//				for (int i=0; i<rideList.get(rs.getInt("rideID")).size(); i++) {
//					if (i>0) {
//						users += ", " + rideList.get(rs.getInt("rideID")).get(i);
//					}
//					else {
//						users += rideList.get(rs.getInt("rideID")).get(i);
//					}
//				}
				users += rideList.get(rs.getInt("rideID"));
				users = users.substring(1,users.length()-1);
				currFeed.put("currentriders", users);
				feed.put("feed" + feedIndex, currFeed);

				//Increment trip counter + counter 
				feedCounter++; 
				feedIndex++;
			}
			//Placed feed size in the JSON 
			feed.put("feedsize", feedCounter);
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return feed;
	}
	/*
	 * Converts the JSONObject into binary so that it can be sent to the frontend.
	 */
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
	    try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/Hitchhikers?user=root&password=root&useSSL=false");
	        st = conn.createStatement();
	        if (message.get("message").equals("signup")) {
				return signUp(message, conn);
			}
			else if (message.get("message").equals("login")) {
				return signIn(message, conn);
			}
			else if (message.get("message").equals("joinride")) {
				return joinRide(message, conn);
			}
			else if (message.get("message").equals("deleteride")) {
				return deleteRide(message, conn);
			}
			else if (message.get("message").equals("search")) {
				return search(message, conn);
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