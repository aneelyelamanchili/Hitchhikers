//
//  ViewController.swift
//  Auto Complete
//
//  Created by Agus Cahyono on 11/11/16.
//  Copyright © 2016 balitax. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import MapKit

class GMSMapViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, GMSAutocompleteViewControllerDelegate, MKMapViewDelegate {
    
    // OUTLETS
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var previousSearchTableView: UITableView!
    @IBOutlet weak var currentLocation: UILabel!
    
    // VARIABLES
    var locationManager = CLLocationManager();
    var initialCoord = CLLocationCoordinate2D();
    var initialAddress = String();
    
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
        
        previousSearchTableView.dataSource = self as! UITableViewDataSource
        previousSearchTableView.delegate = self as! UITableViewDelegate
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        previousSearchTableView.rowHeight = UITableViewAutomaticDimension
        previousSearchTableView.estimatedRowHeight = 140
        
        initLocation();
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    func displayRoutes(initialCoord: CLLocationCoordinate2D, destinationCoord: CLLocationCoordinate2D) {
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
    
    // MARK: CLLocation Manager Delegate
    func initLocation() {
        initialCoord = (locationManager.location?.coordinate)!;
        
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialCoord,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        let annotation = MKPointAnnotation();
        annotation.coordinate = CLLocationCoordinate2D(latitude: initialCoord.latitude, longitude: initialCoord.longitude)
        mapView.addAnnotation(annotation)
        mapView.setRegion(coordinateRegion, animated: true)
        
        var location = locationManager.location;
        
        CLGeocoder().reverseGeocodeLocation(location!, completionHandler: {(placemarks, error) -> Void in
            print(location!)
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                print(String(describing: pm?.locality))
                print(pm!.administrativeArea);
                print(pm!.postalCode);
                print(pm!.country);
                
                var partOne: String = pm!.locality! + ", " + pm!.administrativeArea!;
                var partTwo: String = ", " + pm!.postalCode! + ", " + pm!.country!;
                
                self.currentLocation.text = "Current Location: " + partOne + partTwo;
                self.initialAddress = partOne + partTwo;
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while get location \(error)")
    }
    
    // MARK: GOOGLE AUTO COMPLETE DELEGATE
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
//        let regionRadius: CLLocationDistance = 1000
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(place.coordinate,
//                                                                  regionRadius * 2.0, regionRadius * 2.0)
//        let annotation = MKPointAnnotation();
//        annotation.coordinate = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
//        mapView.addAnnotation(annotation)
        
        displayRoutes(initialCoord: initialCoord, destinationCoord: place.coordinate);
        
//        mapView.setRegion(coordinateRegion, animated: true)
//        mapView.isZoomEnabled = false;
//        mapView.isScrollEnabled = false;
//        mapView.isUserInteractionEnabled = false;
        
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        self.dismiss(animated: true, completion: nil) // dismiss after select place
        
        self.currentLocation.text = "From: " + initialAddress + "\n" + "To: " + place.formattedAddress!;
    }
    
    @IBAction func dismissView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        print("ERROR AUTO COMPLETE \(error)")
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil) // when cancel search
    }
    
    @IBAction func openSearchAddress(_ sender: UIBarButtonItem) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        //TEST
        autoCompleteController.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.27, blue:0.31, alpha:1.0)
        
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath as IndexPath) as! SearchTableViewCell
        
        cell.addressLabel.text = "3025 Royal Street, Los Angeles, CA 90007"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let cell = previousSearchTableView.cellForRow(at: indexPath) as! SearchTableViewCell
        print(cell.addressLabel.text!);
        var address = cell.addressLabel.text!;
        self.currentLocation.text = "From: " + initialAddress + "\n" + "To: " + address;
        var geocoder = CLGeocoder()
        
        // Put new annotation in and zoom into that coordinate
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if let placemark = placemarks?[0] {
//                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
//                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//                let coordinate = placemark.location!.coordinate
//                let region = MKCoordinateRegion(center: coordinate, span: span)
//                self.mapView.setRegion(region, animated: true)
                
                
                self.displayRoutes(initialCoord: self.initialCoord, destinationCoord: (placemark.location?.coordinate)!)
            }
        })
    }
}

