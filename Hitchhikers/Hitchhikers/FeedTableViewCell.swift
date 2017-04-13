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
        imageString = "JeffreyMiller.jpg";
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
        
//        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
//        xCoordinate = Float(21.282778);
//        yCoordinate = Float(-157.829444);
        
        // These coordinates will change depending on what the server sends back
        initialCoord = CLLocationCoordinate2D(latitude: 37.309927, longitude: -122.057035)
        destinationCoord = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0059)
        
//        let tempController = GMSMapViewController();
        displayCellRoutes(initialCoord: initialCoord, destinationCoord: destinationCoord);
//        let regionRadius: CLLocationDistance = 1000
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
//                                                                      regionRadius * 2.0, regionRadius * 2.0)
//        let annotation = MKPointAnnotation();
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 21.282778, longitude: -157.829444)
//        mapView.addAnnotation(annotation)
//        mapView.setRegion(coordinateRegion, animated: true)
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

