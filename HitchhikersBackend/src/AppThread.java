//import java.io.BufferedInputStream;
//import java.io.BufferedReader;
//import java.io.DataInputStream;
//import java.io.DataOutputStream;
//import java.io.IOException;
//import java.io.InputStream;
//import java.io.InputStreamReader;
//import java.io.ObjectInputStream;
//import java.io.ObjectOutputStream;
//import java.io.OutputStreamWriter;
//import java.net.Socket;
//import java.nio.charset.StandardCharsets;
//
//import org.json.JSONException;
//import org.json.JSONObject;
//
//public class AppThread extends Thread {
//
//	private InputStream ois;
//	private OutputStreamWriter oos;
//	private Server as;
//	BufferedReader br;
//	DataInputStream inStream;
//	
//	public AppThread(Socket s, Server as) {
//		
//		try {
//			this.as = as;
////			oos = new OutputStreamWriter(s.getOutputStream(), StandardCharsets.UTF_8);
////			br = new BufferedReader(new InputStreamReader(s.getInputStream()));
//			DataOutputStream y = new DataOutputStream(s.getOutputStream());
//			inStream = new DataInputStream(s.getInputStream());
//			this.start();
//		} catch (IOException ioe) {
//			System.out.println("ioe: " + ioe.getMessage());
//		}
//	}
//	
//	public void sendMessage(JSONObject message) {
//		try {
//			oos.write(message.toString());
//			oos.flush();
//		} catch (IOException ioe) {
//			System.out.println("ioe: " + ioe.getMessage());
//		}
//	}
//
//	public synchronized void run() {
//		try {
//			while(true) {
//				int content = inStream.read();
//				if (content != -1)
//				System.out.print((char)content);
//				//JSONObject jsonObj = new JSONObject("{\"phonetype\":\"N95\",\"cat\":\"WP\"}");
//				//sendMessage(jsonObj);
//			}
//		}
////		catch (JSONException cnfe) {
////			System.out.println("cnfe in run: " + cnfe.getMessage());
////		}
//		catch (IOException ioe) {
//			System.out.println("ioe in run: " + ioe.getMessage());
//		}
//	}
//}


//import java.io.BufferedReader;
//import java.io.IOException;
//import java.io.InputStream;
//import java.io.InputStreamReader;
//import java.io.ObjectInputStream;
//import java.io.ObjectOutputStream;
//import java.io.OutputStreamWriter;
//import java.net.Socket;
//import java.nio.charset.StandardCharsets;
//
//import org.json.JSONException;
//import org.json.JSONObject;
//
//public class AppThread extends Thread {
//
//	private InputStream ois;
//	private OutputStreamWriter oos;
//	private Server as;
//	BufferedReader br;
//	
//	public AppThread(Socket s, Server as) {
//		
//		try {
//			this.as = as;
//			oos = new OutputStreamWriter(s.getOutputStream(), StandardCharsets.UTF_8);
//			br = new BufferedReader(new InputStreamReader(s.getInputStream()));
//			this.start();
//		} catch (IOException ioe) {
//			System.out.println("ioe: " + ioe.getMessage());
//		}
//	}
//	
//	public void sendMessage(JSONObject message) {
//		try {
//			oos.write(message.toString());
//			oos.flush();
//		} catch (IOException ioe) {
//			System.out.println("ioe: " + ioe.getMessage());
//		}
//	}
//
//	public synchronized void run() {
//		try {
//			while(true) {
//				String content = br.readLine();
//				System.out.println("This is the message being sent: " + content);
//				JSONObject jsonObj = new JSONObject("{\"phonetype\":\"N95\",\"cat\":\"WP\"}");
//				sendMessage(jsonObj);
//			}
//		} catch (JSONException cnfe) {
//			System.out.println("cnfe in run: " + cnfe.getMessage());
//		} catch (IOException ioe) {
//			System.out.println("ioe in run: " + ioe.getMessage());
//		}
//	}
//}

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;

public class AppThread extends Thread {

//	private ObjectInputStream ois;
//	private ObjectOutputStream oos;
	private Server as;
	BufferedReader br;
	
	public AppThread(Socket s, Server as) {
		
		try {
			this.as = as;
			//oos = new ObjectOutputStream(s.getOutputStream());
			br = new BufferedReader(new InputStreamReader(s.getInputStream()));
			this.start();
		} catch (IOException ioe) {
			System.out.println("ioe: " + ioe.getMessage());
		}
	}
	
	public void sendMessage(ChatMessage message) {
		//try {
			//oos.writeObject(message);
			//oos.flush();
		//} //catch (IOException ioe) {
		//	System.out.println("ioe: " + ioe.getMessage());
		//}
	}

	public synchronized void run() {
		try {
			while(true) {
				String x = br.readLine();
				if (x!=null) {
					System.out.println(x);
				}
//				System.out.print(br.readLine());
				//sendMessage(message);
			}
		} //catch (ClassNotFoundException cnfe) {
//			//System.out.println("cnfe in run: " + cnfe.getMessage());
		//}
		catch (IOException ioe) {
			System.out.println("ioe in run: " + ioe.getMessage());
		}
	}
}