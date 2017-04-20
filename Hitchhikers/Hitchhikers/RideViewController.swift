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
    @IBOutlet weak var departure: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var luggage: UILabel!
    @IBOutlet weak var food: UILabel!
    @IBOutlet weak var hospitality: UILabel!
    @IBOutlet weak var detours: UILabel!
    @IBOutlet weak var deleteRide: UIButton!
    @IBOutlet weak var joinRide: UIButton!
    @IBOutlet weak var seatsLeft: UILabel!
    
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
    var seatsAvailable = String();
    var cellID = String();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let logo = UIImage(named: "mountain_icon.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.27, blue:0.31, alpha:1.0)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false;
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
//        self.innerBarButtonItem?.icon(from: .Themify, code: "plus", ofSize: 25)
//        self.navigationItem.rightBarButtonItem?.icon(from: .Themify, code: "search", ofSize: 25)
        
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
        departure.sizeToFit();
        price.text = dollars;
        destination.text = destinationPlace;
        destination.sizeToFit();
        luggage.text = stuffToBring;
        luggage.sizeToFit();
        food.text = eat;
        food.sizeToFit();
        hospitality.text = hospitalities;
        hospitality.sizeToFit();
        detours.text = detour;
        seatsLeft.text = seatsAvailable;
        scrollView.frame = view.bounds
        scrollView.isUserInteractionEnabled = true
        scrollView.isExclusiveTouch = true
        scrollView.addSubview(deleteRide)
        scrollView.addSubview(joinRide)
        self.scrollView.contentSize = self.contentView.bounds.size;
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

            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
    
    }
    
    @IBAction func joinRide(sender: UIButton) {
        print("HELLO")
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("joinride", forKey: "message")
        json.setValue(Client.sharedInstance.json?["email"], forKey: "email")
        json.setValue(cellID, forKey: "joinrideid")
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        
        
        Client.sharedInstance.socket.write(data: jsonData)
    }
    
    public func displayAlert() {
        let myAlert = UIAlertView()
        if(Client.sharedInstance.json?["message"] as? String == "addridersuccessful") {
            myAlert.title = "Joined ride"
            myAlert.message = "Successfully joined ride"
            myAlert.addButton(withTitle: "Dismiss")
            myAlert.delegate = self
            myAlert.show()
            let i : Int!
            
            let s = self.seatsLeft.text
            if let x = Int(s!) {
                    i = x - 1
                    self.seatsLeft.text = i.description
            }
        } else {
            myAlert.title = "Could not join ride"
            myAlert.message = Client.sharedInstance.json?["addriderfail"] as! String?
            myAlert.addButton(withTitle: "Dismiss")
            myAlert.delegate = self
            myAlert.show()
        }
    }
    
    public func goBack() {
        let myAlert = UIAlertView()
        if(Client.sharedInstance.json?["message"] as? String == "deleteridesuccessful") {
            myAlert.title = "Deleted ride"
            myAlert.message = "Successfully deleted ride"
            myAlert.addButton(withTitle: "Dismiss")
            myAlert.delegate = self
            myAlert.show()
            navigationController?.popViewController(animated: true)
        } else {
            myAlert.title = "Could not delete ride"
            myAlert.message = Client.sharedInstance.json?["deleteridefail"] as! String?
            myAlert.addButton(withTitle: "Dismiss")
            myAlert.delegate = self
            myAlert.show()
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
