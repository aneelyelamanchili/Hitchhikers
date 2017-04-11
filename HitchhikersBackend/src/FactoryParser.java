

import java.awt.Point;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.util.StringTokenizer;

import javax.websocket.Session;


/**
 * CSCI-201 Web Factory
 * FactoryParser.java
 * Purpose: parses the pre-defined factory.txt text file that was sent by the WebSocketEndpoint.
 */
class FactoryParser {
//	Factory factory;
	Session session;
	WebSocketEndpoint webSocketEndpoint;

	/**
	 * Constructs and executes the parser onto the inputstream
	 * @param session saves instance of the session that is executing the parser
	 * @param webSocketEndpoint saves instance of websocket that will be passed to the Factory
	 * @param is the InputStream, which is the loaded factory.txt file.
	 */
	FactoryParser(Session session, WebSocketEndpoint webSocketEndpoint, InputStream is) {
		this.session = session;
		this.webSocketEndpoint = webSocketEndpoint;
		System.out.println(convertStreamToString(is));
		//BufferedReader br = null;
//		try {
//			//br = new BufferedReader(new InputStreamReader(is)); // load the factory file
//			//readFile(br); // parse file
//		} catch (IOException fnfe){
//			fnfe.printStackTrace();
//		} finally {
//			if(br != null){
//				try {
//					br.close();
//				} catch (IOException ioe1){
//					ioe1.printStackTrace();
//				}
//			}
//		}
	}
	static String convertStreamToString(java.io.InputStream is) {
	    @SuppressWarnings("resource")
		java.util.Scanner s = new java.util.Scanner(is).useDelimiter("\\A");
	    return s.hasNext() ? s.next() : "";
	}
	/**
	 * Creates instance of Factory and attempts to parse each line of the factory.txt
	 * @param br reads the inputstream that will be parsed
	 * @return the instance of Factory that was created
	 * @throws IOException
	 */
	private void readFile(BufferedReader br) throws IOException {
//		Factory factory = new Factory(session, webSocketEndpoint);
		String line = br.readLine();
		while (line != null) {
			System.out.print(line);
//			line = line.trim();
//			if (line.startsWith("--") || line.length() == 0) {
//				// ignore line since it is a comment or blank line
//			} else if (line.startsWith(utilities.Constants.resourceString)) {
//				FactoryResource resource = parseResource(line);
//				factory.addResource(resource);
//			} else if (line.startsWith(utilities.Constants.productString)) {
//				FactoryProduct product = parseProduct(line);
//				factory.addProduct(product);
//			} else if (line.startsWith(utilities.Constants.factoryNameString)) {
//				parseFactory(factory, line);
//			} else if (line.startsWith(utilities.Constants.taskboardString)) {
//				parseTaskBoardLocation(factory, line);
//			} else { // unrecognized line
//				Util.printMessageToCommand(Constants.unrecognizedLine + line);
//			}
			line = br.readLine();
		}

		// final setup
//		factory.createNodes();
//		factory.sendFactory();
//
//		return factory;
	}

	
//	private FactoryProduct parseProduct(String line) {
//		StringTokenizer st = new StringTokenizer(line, Constants.factoryFileDelimeter);
//		st.nextToken(); // description, which should be "Product"
//		String name = st.nextToken();
//		FactoryProduct product = new FactoryProduct();
//		product.setName(name);
//		
//		// parse quantity
//		int productQuantity = 0;
//		try {
//			productQuantity = Integer.parseInt(st.nextToken());
//			if (productQuantity < 0) productQuantity = 0;
//		} catch (Exception ex) {
//			// if the productQuantity can't be made into an integer, we will use 0 as the quantity
//			Util.printExceptionToCommand(ex);
//		}
//		product.setQuantity(productQuantity);
//		
//		// parse resources that are required by product
//		while (st.hasMoreElements()) {
//			String resourceName = st.nextToken();
//			int quantity = 0;
//			try {
//				quantity = Integer.parseInt(st.nextToken());
//				if (quantity < 0) quantity = 0;
//			} catch (Exception ex) {
//				// if the quantity can't be made into an integer, we will use 0 as the quantity
//				Util.printExceptionToCommand(ex);
//			}
//			product.addResourceNeeded(new FactoryResource(resourceName, quantity));
//		}
//		
//		return product;
//	}

//	private void parseFactory(Factory factory, String line) {
//		StringTokenizer st = new StringTokenizer(line, Constants.factoryFileDelimeter);
//		
//		// description, which should be "Name"
//		st.nextToken();
//		String name = st.nextToken();
//		factory.setName(name);
//		
//		// parse the # of workers
//		int numberOfWorkers = 0;
//		try {
//			numberOfWorkers = Integer.parseInt(st.nextToken());
//			if (numberOfWorkers < 0) numberOfWorkers = 0;
//		} catch (Exception ex) {
//			// if the numberOfWorkers can't be made into an integer, we will have 0 workers
//			Util.printExceptionToCommand(ex);
//		}
//		factory.setNumberOfWorkers(numberOfWorkers);
//		
//		// parse the # of rows and columns
//		int width = 0;
//		int height = 0;
//		try {
//			width = Integer.parseInt(st.nextToken());
//			if (width < 0) width = 0;
//			height = Integer.parseInt(st.nextToken());
//			if (height < 0) height = 0;
//		} catch (Exception ex) {
//			Util.printExceptionToCommand(ex);
//		}
//		factory.setDimensions(width,height);
//	}

//	private void parseTaskBoardLocation(Factory factory, String line) {
//		StringTokenizer st = new StringTokenizer(line, Constants.factoryFileDelimeter);
//		st.nextToken(); // skip "Task Board"
//		int x = 0, y = 0;
//		try {
//			x = Integer.parseInt(st.nextToken());
//			if (x < 0) x = 0;
//			y = Integer.parseInt(st.nextToken());
//			if (y < 0) y = 0;
//		} catch (Exception ex) {
////			Util.printExceptionToCommand(ex);
//		}
//		factory.setTaskBoardLocation(new Point(x,y));
//	}
}
