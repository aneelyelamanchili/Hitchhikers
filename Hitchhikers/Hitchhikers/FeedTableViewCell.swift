//
//  File.swift
//  Hitchhikers
//
//  Created by William Z Wang on 4/6/17.
//  Copyright © 2017 William Z Wang. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    
    var xCoordinate = Float();
    var yCoordinate = Float();
    
    var dName = String();
    var imageString = String();
    var carModel = String();
    var departurePlace = String();
    var dollars = String();
    var destinationPlace = String();
    var stuffToBring = String();
    var eat = String();
    var hospitalities = String();
    var detour = String();
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    // Read in from the database to configure the cell. Database json will be passed into this function
    // and will be used to set up the cell's properties and stored values
    func configureCell() {
        // Set up stored variables in the cell
        dName = "Jeffrey Miller,PhD";
        imageString = "jeffrey_miller.jpg";
        profileImage.image = UIImage(named:"JeffreyMiller.jpg");
        carModel = "Toyota Prius 7TWC807"
        departurePlace = "3025 Royal Street, Los Angeles, CA 90007";
        dollars = "$25-$30";
        destinationPlace = "Voodoo Doughnut 22 SW 3rd Ave, Portland, OR 97204";
        stuffToBring = "1-2 bags maximum";
        eat = "Will make stops; Feel free to bring snacks";
        hospitalities = "Will make frequent pit stops for bathroom; Camping out doors at night";
        detour = "Yes";
        
        profileImage.layer.cornerRadius = 31.5;
        profileImage.layer.masksToBounds = true;
        destinationLabel.text = departurePlace;
        departureTimeLabel.text = "April 8, 2017 11:00 am"
        
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        xCoordinate = Float(21.282778);
        yCoordinate = Float(-157.829444);
        
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
                                                                      regionRadius * 2.0, regionRadius * 2.0)
        let annotation = MKPointAnnotation();
        annotation.coordinate = CLLocationCoordinate2D(latitude: 21.282778, longitude: -157.829444)
        mapView.addAnnotation(annotation)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.isZoomEnabled = false;
        mapView.isScrollEnabled = false;
        mapView.isUserInteractionEnabled = false;
        
    }
    
    
    
}

