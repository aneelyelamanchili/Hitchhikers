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

class FeedTableViewCell: UITableViewCell, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    
    var xCoordinate = Float();
    var yCoordinate = Float();
    
    var initialCoord = CLLocationCoordinate2D();
    var destinationCoord = CLLocationCoordinate2D();
    
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
    var departureTime = String();
    var seatsAvailable = String();
    var cellID: String?
    
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
    func configureCell(feed: String, populate: [String: Any]) {
//        print(populate);
        cellID = populate["rideid"] as! String
        
        
        dName = (populate["firstname"] as? String)! + " " + (populate["lastname"] as? String)!
        imageString = populate["userpicture"] as! String;
        let url = URL(string: populate["userpicture"] as! String)
        print(populate["userpicture"] as! String)
        let data = try? Data(contentsOf: url!)
        
        profileImage.image = UIImage(data: data!);
        carModel = (populate["carmodel"] as! String) + " " + (populate["licenseplate"] as! String);
        departurePlace = populate["origin"] as! String;
        dollars = "$" + (populate["cost"] as! String);
        destinationPlace = populate["destination"] as! String;
        stuffToBring = populate["luggage"] as! String;
        eat = populate["food"] as! String;
        hospitalities = populate["hospitality"] as! String;
        detour = populate["detours"] as! String;
        
        profileImage.layer.cornerRadius = 31.5;
        profileImage.layer.masksToBounds = true;
        destinationLabel.text = destinationPlace;
        destinationLabel.sizeToFit();
        departureTime = populate["datetime"] as! String;
        departureTimeLabel.text = departureTime;
        
        seatsAvailable = populate["seatsavailable"] as! String;
        
        // Dispatch groups to fix asynchronous calls
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        var geocoder = CLGeocoder();
        geocoder.geocodeAddressString(departurePlace, completionHandler: {(placemarks, error) -> Void in
            if let placemark = placemarks?[0] {

                self.initialCoord = (placemark.location?.coordinate)!;

            }
            myGroup.leave()
        })
        
        myGroup.enter()
        var geocoder2 = CLGeocoder();
        geocoder2.geocodeAddressString(destinationPlace, completionHandler: {(placemarks, error) -> Void in
            if let placemark2 = placemarks?[0] {
                //                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                self.destinationCoord = (placemark2.location?.coordinate)!;
            }
            myGroup.leave()
        })
        
        
        myGroup.notify(queue: DispatchQueue.main, execute: {
            self.displayCellRoutes(initialCoord: self.initialCoord, destinationCoord: self.destinationCoord);
        })
        
        displayCellRoutes(initialCoord: self.initialCoord, destinationCoord: self.destinationCoord);

        mapView.isZoomEnabled = false;
        mapView.isScrollEnabled = false;
        mapView.isUserInteractionEnabled = false;
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    func displayCellRoutes(initialCoord: CLLocationCoordinate2D, destinationCoord: CLLocationCoordinate2D) {
        // Remove all previous annotatations
        let annotations = self.mapView.annotations;
        
        for annotation in annotations {
            if let annotation = annotation as? MKAnnotation
            {
                self.mapView.removeAnnotation(annotation)
            }
        }
        
        // Remove all previous map overlays
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        
        // Create the routes to and from two locations
        // 1.
        mapView.delegate = self
        
        // 2.
        let sourceLocation = CLLocationCoordinate2D(latitude: initialCoord.latitude, longitude: initialCoord.longitude)
        let destinationLocation = CLLocationCoordinate2D(latitude: destinationCoord.latitude, longitude: destinationCoord.longitude)
        
        // 3.
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 5.
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Times Square"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Empire State Building"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        // 6.
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        // 7.
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            //            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
  
}

