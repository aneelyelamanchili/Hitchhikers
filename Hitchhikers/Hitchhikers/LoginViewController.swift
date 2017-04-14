//
//  LoginViewController.swift
//  Hitchhikers
//
//  Created by William Z Wang on 3/30/17.
//  Copyright © 2017 William Z Wang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let sharedModel = Client.sharedInstance
    
    var sendMessage: [String: Any]?
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        if(self.sharedModel.socket.isConnected) {
            print("Success")
        } else {
            print("Failure")
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("login", forKey: "message")
        json.setValue(username.text, forKey: "email")
        json.setValue(password.text, forKey: "password")
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        //print(jsonString)
        
        Client.sharedInstance.socket.write(data: jsonData as Data)
        
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//       //if  segue.identifier == "loginSegue",
//          if  let destination = segue.destination as? FeedTableViewController
//        {
//            print("GOT HERE");
//            // Set the destination dictionary to the current dictionary
//            destination.toPopulate = sendMessage;
//        }
//        
//    }
    
    public func didReceiveData() {
        print(Client.sharedInstance.json?["message"])
        
        if (Client.sharedInstance.json?["message"] as! String == "loginfail") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            
            let myAlert = UIAlertView()
            myAlert.title = "Login Failure"
            myAlert.message = Client.sharedInstance.json?["loginfail"] as! String? 
            myAlert.addButton(withTitle: "Dismiss")
            myAlert.delegate = self
            myAlert.show()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            print("SUCCESS")
            // Convert dictionary to string
//            do {
//                sendMessage = try JSONSerialization.jsonObject(with: Client.sharedInstance.json?["message"] as! Data, options: .allowFragments) as! Dictionary<String, Any>
//            } catch {
//                print("parse error")
//            }
            
            sendMessage = Client.sharedInstance.json
            
            print(sendMessage?["message"])
            
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "FeedTableViewController") as! FeedTableViewController
            let leftViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
            
            let slideMenuController = SlideController(mainViewController: nvc, leftMenuViewController: leftViewController)
            UIApplication.shared.delegate?.window??.rootViewController = slideMenuController
            
            mainViewController.toPopulate = sendMessage
            
            self.navigationController?.pushViewController(mainViewController, animated: true)
            
        }

    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
