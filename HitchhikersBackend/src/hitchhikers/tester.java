package hitchhikers;
import org.json.JSONException;
import org.json.JSONObject;

public class tester {
	public static void main(String[] args) {
		Application x = new Application();
		JSONObject a = new JSONObject();
		try {
			//test login
//			a.put("message", "login");
//			a.put("username", "Adam");
//			a.put("password", "mypassword");
			
			//signup
//			a.put("message", "signup");
//			a.put("username", "DAVID");
//			a.put("password", "password");
//			a.put("email", "sealand@usc.edu");
//			a.put("age", "19");
//			a.put("picture", "truck.com");
//			a.put("phonenumber", "5033517120");
//			a.put("isDriver", "yes");
//			JSONObject fuck = x.parseMessage(a);
//			System.out.println(fuck.toString());
//			a.put("message", "signup");
//			a.put("username", "ANEEL");
//			a.put("password", "password");
//			a.put("email", "sealand@usc.edu");
//			a.put("age", "19");
//			a.put("picture", "truck.com");
//			a.put("phonenumber", "5033517120");
//			a.put("isDriver", "yes");
//			fuck = x.parseMessage(a);
//			System.out.println(fuck.toString());
			a.put("message", "signup");
			a.put("username", "DOM");
			a.put("password", "password");
			a.put("email", "sealand@usc.edu");
			a.put("age", "19");
			a.put("picture", "truck.com");
			a.put("phonenumber", "5033517120");
			a.put("isDriver", "yes");
			JSONObject fuck = x.parseMessage(a);
			System.out.println(fuck.toString());
			//test joinride
			a.put("message", "joinride");
			a.put("joinrideid", 2);
			a.put("username", "DOM");
			fuck = x.parseMessage(a);
			System.out.println(fuck.toString() + "\n");
//			
//			a.put("message", "joinride");
//			a.put("rideid", 2);
//			a.put("username", "DAVID");
//			fuck = x.parseMessage(a);
//			System.out.println(fuck.toString());
//			a.put("message", "joinride");
//			a.put("rideid", 2);
//			a.put("username", "ANEEL");
//			fuck = x.parseMessage(a);
//			System.out.println(fuck.toString());
			//test makeride
//			a.put("message", "makeride");
			
			//test signup
//			a.put("message", "signup");
//			a.put("username", "DANK");
//			a.put("password", "password");
//			a.put("email", "sealand@usc.edu");
//			a.put("age", "19");
//			a.put("picture", "truck.com");
//			a.put("phonenumber", "5033517120");
//			a.put("isDriver", "yes");
//			fuck = x.parseMessage(a);
////			System.out.println(fuck.get("message"));
//			a.put("message", "joinride");
//			a.put("rideid", 2);
//			a.put("username", "DANK");
			
//			a.put("message", "deleteride");
//			a.put("deleterideid", "1");
//			a.put("username", "Adam");
			
			//search test
			a.put("message", "search");
			a.put("search", "Doughnut");
			a.put("username", "Adam");
			fuck = x.parseMessage(a);
			System.out.println(fuck.toString());
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
}
