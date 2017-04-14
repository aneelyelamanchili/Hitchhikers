//
//  FeedTableViewController.swift
//  Hitchhikers
//
//  Created by William Z Wang on 3/30/17.
//  Copyright © 2017 William Z Wang. All rights reserved.
//

import UIKit
import SwiftIconFont

class FeedTableViewController: UITableViewController {
    @IBOutlet weak var innerBarButtonItem: UIBarButtonItem?
    
    var toPopulate = Client.sharedInstance.json
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.backgroundColor = UIColor.gray
        
        let logo = UIImage(named: "mountain_icon.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.27, blue:0.31, alpha:1.0)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false;
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.innerBarButtonItem?.icon(from: .Themify, code: "plus", ofSize: 25)
        self.navigationItem.rightBarButtonItem?.icon(from: .Themify, code: "search", ofSize: 25)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "showRide",
            let destination = segue.destination as? RideViewController,
            let rowIndex = tableView.indexPathForSelectedRow?.row,
            let sectionIndex = tableView.indexPathForSelectedRow?.section
        {
            print("GOT HERE");
            print(rowIndex);
            let indexPath = IndexPath(row: rowIndex, section: sectionIndex);
            let cell = tableView.cellForRow(at: indexPath) as! FeedTableViewCell;
            destination.dName = cell.dName;
            destination.dImage = cell.imageString;
            destination.carModel = cell.carModel;
            destination.departurePlace = cell.departurePlace;
            destination.dollars = cell.dollars;
            destination.destinationPlace = cell.destinationPlace;
            destination.stuffToBring = cell.stuffToBring;
            destination.eat = cell.eat;
            destination.hospitalities = cell.hospitalities;
            destination.detour = cell.detour;
            destination.initialCoord = cell.initialCoord;
            destination.destinationCoord = cell.destinationCoord;
            destination.cellID = cell.cellID!;
            
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem(viewController: "FeedTableViewController")
        
        print("GOT TO VIEW WILL APPEAR")
        toPopulate = Client.sharedInstance.json
        print(toPopulate?["feedsize"])
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // Return the number of rows in the feed
        return toPopulate?["feedsize"] as! Int
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 300
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell

        // Configure the cell...
        print(toPopulate?["picture"])
        var feedNum: String = "feed" + String(indexPath.row + 1);
        print(feedNum);
        cell.configureCell(feed: feedNum, populate: toPopulate?[feedNum] as! [String : Any]);
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        
        return cell
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            toPopulate?["feedsize"] = (toPopulate?["feedsize"] as! Int) - 1;
//            toPopulate?.removeValue(forKey: (tableView.cellForRow(at: indexPath)).
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        tableView.reloadData();
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
