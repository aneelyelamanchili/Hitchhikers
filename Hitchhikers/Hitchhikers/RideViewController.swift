//
//  RideViewController.swift
//  Hitchhikers
//
//  Created by William Z Wang on 4/7/17.
//  Copyright © 2017 William Z Wang. All rights reserved.
//

import UIKit
import MapKit

class RideViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var carModelLicense: UILabel!
    @IBOutlet weak var contactUser: UIButton!
    @IBOutlet weak var departure: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var luggage: UILabel!
    @IBOutlet weak var food: UILabel!
    @IBOutlet weak var hospitality: UILabel!
    @IBOutlet weak var detours: UILabel!
    
    var dName = String();
    var dImage = String();
    var carModel = String();
    var departurePlace = String();
    var dollars = String();
    var destinationPlace = String();
    var stuffToBring = String();
    var eat = String();
    var hospitalities = String();
    var detour = String();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        driverName.text = dName;
        
        driverImage.image = UIImage(named: dImage);
        carModelLicense.text = carModel;
        departure.text = departurePlace;
        price.text = dollars;
        destination.text = destinationPlace;
        luggage.text = stuffToBring;
        food.text = eat;
        hospitality.text = hospitalities;
        detours.text = detour;
        scrollView.frame = view.bounds
        self.scrollView.contentSize = self.contentView.bounds.size;
//        scrollView.contentSize = CGSize(width: 375, height: 1136);
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        scrollView.frame = view.bounds
//        contentView.frame = CGRect(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
