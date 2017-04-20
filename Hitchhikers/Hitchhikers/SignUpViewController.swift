//
//  SignUpViewController.swift
//  Hitchhikers
//
//  Created by William Z Wang on 4/5/17.
//  Copyright © 2017 William Z Wang. All rights reserved.
//

import UIKit
import SwiftIconFont

class SignUpViewController: UIViewController {
    @IBOutlet weak var btn: UIButton!
    var activeField: UITextField?

    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var phonenumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var profileURL: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let origImage = UIImage(named: "down_arrow.png")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        btn.tintColor = UIColor(red:0.19, green:0.27, blue:0.31, alpha:1.0)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardUp), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardDown), name: NSNotification.Name.UIKeyboardWillHide, object: nil)


        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func setField(sender: UITextField) {
        activeField = sender
    }
    
    func keyboardUp(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.view.frame.origin.y = 0
            if(activeField?.restorationIdentifier == "first") {
                self.view.frame.origin.y -= 0
            } else if(activeField?.restorationIdentifier == "last") {
                self.view.frame.origin.y -= 0
            } else if(activeField?.restorationIdentifier == "email") {
                self.view.frame.origin.y -= 0
            } else if(activeField?.restorationIdentifier == "age") {
                self.view.frame.origin.y -= 253
            } else if(activeField?.restorationIdentifier == "phone") {
                self.view.frame.origin.y -= 253
            } else if(activeField?.restorationIdentifier == "password") {
                self.view.frame.origin.y -= 253
            } else if(activeField?.restorationIdentifier == "profile") {
                self.view.frame.origin.y -= 253
            }
        }
        
    }
    
    func keyboardDown(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.view.frame.origin.y = 0
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func signUpUser(_ sender: Any) {
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("signup", forKey: "message")
        json.setValue(firstname.text, forKey: "firstname")
        json.setValue(lastname.text, forKey: "lastname")
        json.setValue(password.text, forKey: "password")
        json.setValue(age.text, forKey: "age")
        json.setValue(email.text, forKey: "email")
        json.setValue(phonenumber.text, forKey: "phonenumber")
        json.setValue(profileURL.text, forKey: "picture")
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        //print(jsonString)
        
        Client.sharedInstance.socket.write(data: jsonData)
        
    }
    
    public func didReceiveData() {
        print(Client.sharedInstance.json?["message"])
        
        if (Client.sharedInstance.json?["message"] as! String == "signupfail") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            
            let myAlert = UIAlertView()
            myAlert.title = "Signup Failure"
            myAlert.message = Client.sharedInstance.json?["signupfail"] as! String?
            myAlert.addButton(withTitle: "Dismiss")
            myAlert.delegate = self
            myAlert.show()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "FeedTableViewController") as! FeedTableViewController
            let leftViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
            
            let slideMenuController = SlideController(mainViewController: nvc, leftMenuViewController: leftViewController)
            UIApplication.shared.delegate?.window??.rootViewController = slideMenuController
            
            self.dismissKeyboard()
            
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
