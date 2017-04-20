//
//  ProfileTableViewController.swift
//  Hitchhikers
//
//  Created by Aneel Yelamanchili on 4/11/17.
//  Copyright © 2017 William Z Wang. All rights reserved.
//

import Foundation
import UIKit
import SwiftIconFont

class ProfileTableViewController: UITableViewController {
    @IBOutlet var table: UITableView!
    @IBOutlet weak var firstname: UILabel!
    @IBOutlet weak var lastname: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var password: UILabel!
    
    let toPopulate = Client.sharedInstance.json
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.table.isScrollEnabled = false;
        
        firstname.text = toPopulate?["firstname"] as! String
        lastname.text = toPopulate?["lastname"] as! String
        age.text = toPopulate?["age"] as! String
        phoneNumber.text = toPopulate?["phonenumber"] as! String
        email.text = toPopulate?["email"] as! String
        
        var toSetPass:String = ""
        for i in 0 ..< (toPopulate?["password"] as! String).length {
            toSetPass += "•";
        }
        password.text = toSetPass;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        if (indexPath.row == 0 || indexPath.row == indexPath.section-1) {
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, -cell.bounds.size.width, 0);
        }
        
        return cell
    }
    
}
