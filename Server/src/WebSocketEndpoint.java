

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.Socket;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import org.json.simple.JSONObject;
//import org.json.JSONException;
//import org.json.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

//TEST WITH var ws = new WebSocket('ws://localhost:8080/Server/ws'); in CHROME DEV TOOLS ctrl shift j

@ServerEndpoint(value = "/ws")

public class WebSocketEndpoint {
	private static final Logger logger = Logger.getLogger("BotEndpoint");
	private static final Map<String, Session> sessions = new HashMap<String, Session>();
//	private static final Map<String, Factory> factories = new HashMap<>();
	private static Lock lock = new ReentrantLock();

	@OnOpen
	public void open(Session session) {
		lock.lock();
		logger.log(Level.INFO, "Connection opened. (id:)" + session.getId());
		sessions.put(session.getId(), session);
		lock.unlock();
	}

	@OnMessage
	public void onMessage(byte[] b, boolean last, Session session) {
		lock.lock();
		String printMe="";
		try {
			printMe = new String(b, "US-ASCII");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		JSONParser parser = new JSONParser();
		JSONObject json = null;
		try {
			json = (JSONObject) parser.parse(printMe);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		Connection conn = null;
	    Statement st = null;
	    ResultSet rs = null;
	   
	    try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/Hitchhikers?user=root&password=root&useSSL=false");
	        st = conn.createStatement();
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}
	        
		try {
			if (json.get("SignUpUsername")!=null) {
				String signupusername = (String) json.get("SignUpUsername");
				if (signupusername.length() > 0) {
					rs = st.executeQuery("SELECT * from TotalUsers");
					while (rs.next()) {
						if (rs.getString("Username").equals(signupusername)) {
							//return failed sign up message
						}
						else {
							if (json.get("Password")!=null || json.get("Age")!=null || json.get("Email")!=null || json.get("Picture")!=null || json.get("isDriver")!=null) {
								//return failed sign up message
							}
							String signuppassword = (String)json.get("Password");
							String signupage = (String)json.get("Age");
							String signupemail = (String)json.get("Email");
							String signupdriver = (String)json.get("isDriver");
							int signupageint = -1;
							try {
								signupageint = Integer.parseInt(signupage);
							} catch (NumberFormatException e) {
								//return failed sign up message
							}
							if (signupageint < 1) {
								//return failed sign up message
							}
							boolean signupdriverbool = false;
							if (signupdriver.equals("yes")) {
								signupdriverbool = true;
							}
							//any more checks to do? if not, add them to database
						}
					}
				}
				else {
					//return failed username message
				}
				
						
			}
		} catch (SQLException sqle) {
	    	System.out.println (sqle.getMessage());
	    }
		
			System.out.println(printMe + json.get("message"));
		
//		Factory factory = factories.get(session.getId());
//		if (factory != null) {
//			// factory already created, listen
//			factory.listen(message);
//		} else {
//			// factory not yet created, use message as text file
//			InputStream is = new ByteArrayInputStream(message.getBytes());
//			new FactoryParser(session, this, is);
//			factories.put(session.getId(), new FactoryParser(session, this, is).factory);
//		}
		lock.unlock();
	}

	@OnClose
	public void close(Session session) {
		lock.lock();
		logger.log(Level.INFO, "Connection closed. (id:)" + session.getId());
		sessions.remove(session.getId());
//		if (factories.get(session.getId()) != null) {
//			factories.get(session.getId()).killWorkers();
//			factories.remove(session.getId());
//		}
		lock.unlock();
	}

	@OnError
	public void onError(Throwable error) {
		error.printStackTrace();
	}

	public void sendToSession(Session session, String message) {
		lock.lock();
		try {
			session.getBasicRemote().sendText(message);
		} catch (IOException ex) {
			sessions.remove(session.getId());
			logger.log(Level.SEVERE, ex.getMessage(), ex.getStackTrace());
		}
		lock.unlock();
	}
}
