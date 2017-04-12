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

class GMSMapViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, GMSAutocompleteViewControllerDelegate {
    
    // OUTLETS
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var previousSearchTableView: UITableView!
    @IBOutlet weak var currentLocation: UILabel!
    
    // VARIABLES
    var locationManager = CLLocationManager();
    var initialCoord = CLLocationCoordinate2D();
    
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
        
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(place.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        let annotation = MKPointAnnotation();
        annotation.coordinate = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        mapView.addAnnotation(annotation)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.isZoomEnabled = false;
        mapView.isScrollEnabled = false;
        mapView.isUserInteractionEnabled = false;
        
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        self.dismiss(animated: true, completion: nil) // dismiss after select place
        
        
        self.currentLocation.text = "Current Location: " + place.formattedAddress!;
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
        
        cell.addressLabel.text = "3025 Royal Street, Los Angeles, CA 90007 wowowowo wowowow owowoowowoww owowow"
        return cell
    }
}

