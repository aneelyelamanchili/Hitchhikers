//
//  RideViewController.swift
//  Hitchhikers
//
//  Created by William Z Wang on 4/7/17.
//  Copyright © 2017 William Z Wang. All rights reserved.
//

import UIKit
import MapKit

class RideViewController: UIViewController, UIScrollViewDelegate, MKMapViewDelegate {
    
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
    @IBOutlet weak var deleteRide: UIButton!
    
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
    var xCoordinate = Float();
    var yCoordinate = Float();
    var initialCoord = CLLocationCoordinate2D();
    var destinationCoord = CLLocationCoordinate2D();
    var cellID = String();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let initialLocation = CLLocation(latitude: CLLocationDegrees(xCoordinate), longitude: CLLocationDegrees(yCoordinate))
//        
//        let regionRadius: CLLocationDistance = 1000
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
//                                                                  regionRadius * 2.0, regionRadius * 2.0)
//        print(xCoordinate);
//        print(yCoordinate);
//        let annotation = MKPointAnnotation();
//        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(xCoordinate), longitude: CLLocationDegrees(yCoordinate))
//        mapView.addAnnotation(annotation)
//        mapView.setRegion(coordinateRegion, animated: true)
        
        displayRideRoute(initialCoord: initialCoord, destinationCoord: destinationCoord);
        
        mapView.isZoomEnabled = false;
        mapView.isScrollEnabled = false;
        mapView.isUserInteractionEnabled = false;
        
        driverName.text = dName;
        
        let imageString = dImage;
        let url = URL(string: imageString)
        let data = try? Data(contentsOf: url!)
        
        
        let image = UIImage(data: data!)
        driverImage.image = image;
        driverImage.layer.cornerRadius = 45.5;
        driverImage.layer.masksToBounds = true;
        
        carModelLicense.text = carModel;
        departure.text = departurePlace;
        price.text = dollars;
        destination.text = destinationPlace;
        luggage.text = stuffToBring;
        food.text = eat;
        hospitality.text = hospitalities;
        detours.text = detour;
        scrollView.frame = view.bounds
        scrollView.isUserInteractionEnabled = true
        scrollView.isExclusiveTouch = true
        scrollView.addSubview(deleteRide)
        self.scrollView.contentSize = self.contentView.bounds.size;
//        scrollView.contentSize = CGSize(width: 375, height: 1136);
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    func displayRideRoute(initialCoord: CLLocationCoordinate2D, destinationCoord: CLLocationCoordinate2D) {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        scrollView.frame = view.bounds
//        contentView.frame = CGRect(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteThisRide(sender: UIButton) {
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("deleteride", forKey: "message")
        json.setValue(Client.sharedInstance.json?["email"], forKey: "email")
        json.setValue(cellID, forKey: "deleterideid")
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())

        Client.sharedInstance.socket.write(data: jsonData)
        
        usleep(3000000)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "FeedTableViewController") as! FeedTableViewController
        
        mainViewController.toPopulate = Client.sharedInstance.json
        
        _ = navigationController?.popViewController(animated: true)
    
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
