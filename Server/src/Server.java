import java.io.File;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;
import java.util.Scanner;
import java.util.TreeMap;
import java.util.Vector;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;



public class Server {
	
	private Vector<AppThread> appThreads;
	public Server() {

		
		ServerSocket ss = null;
		appThreads = new Vector<>();
		
			
				try {
					ss = new ServerSocket(1234);
					System.out.println("serversocket made");
					while (true) {
						Socket s = ss.accept();
						System.out.println("connection from " + s.getInetAddress());
						AppThread appC = new AppThread(s, this);
						appThreads.add(appC);
					}
				} catch (IOException ioe) {

				} finally {
					if (ss != null) {
						try {
							ss.close();
						} catch (IOException ioe) {
							System.out.println("ioe closing ss: " + ioe.getMessage());
						}
					}
				}
			}
		
	public static void main(String [] args) {
		new Server();
	}
}


