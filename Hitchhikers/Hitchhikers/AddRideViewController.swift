//
//  AddRideViewController.swift
//  Hitchhikers
//
//  Created by William Z Wang on 4/5/17.
//  Copyright © 2017 William Z Wang. All rights reserved.
//

import UIKit
import SwiftIconFont

class AddRideViewController: UIViewController, UITextFieldDelegate {
    
    let sharedModel = Client.sharedInstance
    var activeField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        

        let logo = UIImage(named: "mountain_icon.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.27, blue:0.31, alpha:1.0)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false;
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem?.icon(from: .Themify, code: "arrowleft", ofSize: 25)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddRideViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddRideViewController.keyboardUp), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddRideViewController.keyboardDown), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func setField(sender: UITextField) {
        activeField = sender
    }
    
    func keyboardUp(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.view.frame.origin.y = 57
            if(activeField?.placeholder == "Current Location") {
                self.view.frame.origin.y -= 0
            } else if(activeField?.placeholder == "Destination Location") {
                self.view.frame.origin.y -= 0
            } else if(activeField?.placeholder == "$$$$$") {
                self.view.frame.origin.y -= 0
            } else if(activeField?.placeholder == "Maximum Luggage") {
                self.view.frame.origin.y -= 0
            } else if(activeField?.placeholder == "Food/Snacks on Trip") {
                self.view.frame.origin.y -= 253
            } else if(activeField?.placeholder == "Hospitality Notes") {
                self.view.frame.origin.y -= 253
            } else if(activeField?.placeholder == "Will you be detouring?") {
                self.view.frame.origin.y -= 253
            }
        }
    
    }
    
    func keyboardDown(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.view.frame.origin.y = 57
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
    
    // MARK: Write Text Action
    
    @IBAction func writeText(_ sender: UIButton) {
        sharedModel.socket.write(string: "hello there!")
    }
    
    // MARK: Disconnect Action
    
    @IBAction func disconnect(_ sender: UIButton) {
        if sharedModel.socket.isConnected {
            //sender.currentTitle = "Connect"
            sharedModel.socket.disconnect()
        } else {
            //sender.currentTitle = "Disconnect"
            sharedModel.socket.connect()
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
