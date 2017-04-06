import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStreamWriter;
import java.net.Socket;

public class AppThread extends Thread {

	private InputStreamWriter ois;
	private OutputStreamWriter oos;
	private Server as;
	
	public AppThread(Socket s, Server as) {
		
		try {
			this.as = as;
			oos = new OutputStreamWriter(s.getOutputStream());
			ois = new ObjectInputStream(s.getInputStream());
			this.start();
		} catch (IOException ioe) {
			System.out.println("ioe: " + ioe.getMessage());
		}
	}
	
	public void sendMessage(String message) {
		try {
			oos.writeObject(message);
			oos.flush();
		} catch (IOException ioe) {
			System.out.println("ioe: " + ioe.getMessage());
		}
	}

	public synchronized void run() {
		try {
			while(true) {
				String message = (String)ois.readObject();
				System.out.println("This message was sent " + message);
				sendMessage(message);
			}
		} catch (ClassNotFoundException cnfe) {
			System.out.println("cnfe in run: " + cnfe.getMessage());
		} catch (IOException ioe) {
			System.out.println("ioe in run: " + ioe.getMessage());
		}
	}
}

//import java.io.IOException;
//import java.io.ObjectInputStream;
//import java.io.ObjectOutputStream;
//import java.net.Socket;
//
//public class AppThread extends Thread {
//
//	private ObjectInputStream ois;
//	private ObjectOutputStream oos;
//	private Server as;
//	
//	public AppThread(Socket s, Server as) {
//		
//		try {
//			this.as = as;
//			oos = new ObjectOutputStream(s.getOutputStream());
//			ois = new ObjectInputStream(s.getInputStream());
//			this.start();
//		} catch (IOException ioe) {
//			System.out.println("ioe: " + ioe.getMessage());
//		}
//	}
//	
//	public void sendMessage(ChatMessage message) {
//		try {
//			oos.writeObject(message);
//			oos.flush();
//		} catch (IOException ioe) {
//			System.out.println("ioe: " + ioe.getMessage());
//		}
//	}
//
//	public synchronized void run() {
//		try {
//			while(true) {
//				ChatMessage message = (ChatMessage)ois.readObject();
//				sendMessage(message);
//			}
//		} catch (ClassNotFoundException cnfe) {
//			System.out.println("cnfe in run: " + cnfe.getMessage());
//		} catch (IOException ioe) {
//			System.out.println("ioe in run: " + ioe.getMessage());
//		}
//	}
//}