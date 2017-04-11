import org.json.JSONException;
import org.json.JSONObject;

public class tester {
	public static void main(String[] args) {
		Application x = new Application();
		JSONObject a = new JSONObject();
		try {
			//test login
			a.put("message", "login");
			a.put("username", "Adam");
			a.put("password", "mypassword");
			
			//test makeride
//			a.put("message", "makeride");
			
			//test signup
//			a.put("message", "signup");
//			a.put("username", "david");
//			a.put("password", "password");
//			a.put("email", "sealand@usc.edu");
//			a.put("age", "19");
//			a.put("picture", "truck.com");
//			a.put("phonenumber", "5033517120");
//			a.put("isDriver", "yes");
			JSONObject fuck = x.parseMessage(a);
			System.out.println(fuck.toString());
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
}
