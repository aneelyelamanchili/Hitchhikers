//
//  AddRideViewController.swift
//  Hitchhikers
//
//  Created by William Z Wang on 4/5/17.
//  Copyright © 2017 William Z Wang. All rights reserved.
//

import UIKit
import SwiftIconFont
import GoogleMaps
import GooglePlaces
import MapKit

class AddRideViewController: UIViewController, UITextFieldDelegate, GMSAutocompleteViewControllerDelegate {
    
    let sharedModel = Client.sharedInstance
    var activeField: UITextField?
    var current = Bool();
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var currentLocationTextField: UITextField!
    @IBOutlet weak var destinationLocationTextField: UITextField!
    @IBOutlet weak var searchCurrent: UIButton!
    @IBOutlet weak var searchDestination: UIButton!
    @IBOutlet weak var inputDollars: UITextField!
    @IBOutlet weak var maxLuggage: UITextField!
    @IBOutlet weak var foodOnTrip: UITextField!
    @IBOutlet weak var hospitalities: UITextField!
    @IBOutlet weak var detouring: UITextField!
    @IBOutlet weak var carModel: UITextField!
    @IBOutlet weak var licensePlate: UITextField!
    @IBOutlet weak var dateAndTime: UITextField!
    @IBOutlet weak var totalSeats: UITextField!
    @IBOutlet weak var submit: UIButton!

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
        self.navigationItem.leftBarButtonItem?.icon(from: .Themify, code: "arrowleft", ofSize: 25)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddRideViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddRideViewController.keyboardUp), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddRideViewController.keyboardDown), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        scrollView.frame = view.bounds
        self.scrollView.contentSize = self.contentView.bounds.size;
        
        // Do any additional setup after loading the view.
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
//        let regionRadius: CLLocationDistance = 1000
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(place.coordinate,
//                                                                  regionRadius * 2.0, regionRadius * 2.0)
//        let annotation = MKPointAnnotation();
//        annotation.coordinate = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
//        mapView.addAnnotation(annotation)
//        mapView.setRegion(coordinateRegion, animated: true)
//        mapView.isZoomEnabled = false;
//        mapView.isScrollEnabled = false;
//        mapView.isUserInteractionEnabled = false;
//        
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
        self.dismiss(animated: true, completion: nil) // dismiss after select place
//
//        
//        self.currentLocation.text = "Current Location: " + place.formattedAddress!;
        
        print("Place address: \(place.formattedAddress)")
        if(current) {
            currentLocationTextField.text = place.formattedAddress;
        }
        
        else {
            destinationLocationTextField.text = place.formattedAddress;
        }
        
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

    
    @IBAction func openSearchAddressCurrent(_ sender: UIButton) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        //TEST
        autoCompleteController.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.27, blue:0.31, alpha:1.0)
        
//        locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
        current = true;
    }
    
    @IBAction func openSearchAddressDestination(_ sender: Any) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        //TEST
        autoCompleteController.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.27, blue:0.31, alpha:1.0)
        
        //        locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
        current = false;
    }
    
    
    @IBAction func setField(sender: UITextField) {
        activeField = sender
    }
    
    func keyboardUp(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.view.frame.origin.y = 57
            if(activeField?.placeholder == "Current Location") {
                self.view.frame.origin.y -= 0
            } else if(activeField?.placeholder == "Destination Location") {
                self.view.frame.origin.y -= 0
            } else if(activeField?.placeholder == "$$$$$") {
                self.view.frame.origin.y -= 0
            } else if(activeField?.placeholder == "Maximum Luggage") {
                self.view.frame.origin.y -= 0
            } else if(activeField?.placeholder == "Food/Snacks on Trip") {
                self.view.frame.origin.y -= 253
            } else if(activeField?.placeholder == "Hospitality Notes") {
                self.view.frame.origin.y -= 253
            } else if(activeField?.placeholder == "Will you be detouring?") {
                self.view.frame.origin.y -= 253
            }
        }
    
    }
    
    func keyboardDown(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.view.frame.origin.y = 57
        }
    
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: Write Text Action
    
    @IBAction func submitRide(_ sender: Any) {
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("makeride", forKey: "message")
        json.setValue(Client.sharedInstance.json?["email"], forKey: "email")
        json.setValue(currentLocationTextField.text, forKey: "origin")
        json.setValue(destinationLocationTextField.text, forKey: "destination")
        json.setValue(Int(inputDollars.text!) ?? 0, forKey: "cost")
        json.setValue(maxLuggage.text, forKey: "luggage")
        json.setValue(foodOnTrip.text, forKey: "food")
        json.setValue(hospitalities.text, forKey: "hospitality")
        json.setValue(detouring.text, forKey: "detours")
        json.setValue(carModel.text, forKey: "carmodel")
        json.setValue(licensePlate.text, forKey: "licenseplate")
        json.setValue(dateAndTime.text, forKey: "datetime")
        json.setValue(totalSeats.text, forKey: "totalseats")
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        //print(jsonString)
        
        Client.sharedInstance.socket.write(data: jsonData)
    }
    
    func goBack() {
        let myAlert = UIAlertView()
        if(Client.sharedInstance.json?["message"] as? String == "addridesuccess") {
            myAlert.title = "Ride added"
            myAlert.message = "Successfully created a ride"
            myAlert.addButton(withTitle: "Dismiss")
            myAlert.delegate = self
            myAlert.show()
            navigationController?.popViewController(animated: true)
        } else {
            myAlert.title = "Could not create ride"
            myAlert.message = Client.sharedInstance.json?["addridefail"] as! String?
            myAlert.addButton(withTitle: "Dismiss")
            myAlert.delegate = self
            myAlert.show()
        }
    }

    
    // MARK: Disconnect Action
    
    @IBAction func disconnect(_ sender: UIButton) {

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
