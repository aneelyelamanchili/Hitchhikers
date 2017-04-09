

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.Socket;
import java.nio.ByteBuffer;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
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

import org.json.JSONObject;
//import org.json.simple.JSONObject;
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
	private static Application application = new Application();
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
		application.parseMessage(json, session, this);
		//send message back, convert to 
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

	public void sendToSession(Session session, byte[] message) {
		lock.lock();
		
		try {
			ByteBuffer b = ByteBuffer.wrap(message);
			session.getBasicRemote().sendBinary(b);
		} catch (IOException ex) {
			sessions.remove(session.getId());
			logger.log(Level.SEVERE, ex.getMessage(), ex.getStackTrace());
		}
		lock.unlock();
	}
	public void sendToSessions(ArrayList<Session> sendTo, String message) {
		lock.lock();
		lock.unlock();
	}
}
