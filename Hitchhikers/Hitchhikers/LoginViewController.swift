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
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: "FeedTableViewController") as! FeedTableViewController
        let leftViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        let slideMenuController = SlideController(mainViewController: nvc, leftMenuViewController: leftViewController)
        UIApplication.shared.delegate?.window??.rootViewController = slideMenuController
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
