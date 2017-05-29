//
//  Client.swift
//  Hitchhikers
//
//  Created by Aneel Yelamanchili on 3/30/17.
//  Copyright © 2017 William Z Wang. All rights reserved.
//

import Foundation
import Starscream

class Client: NSObject, WebSocketDelegate {
    static let sharedInstance = Client()
    
    var json: [String: Any]?
    //ws://hhbackend5.herokuapp.com/ws
    var socket = WebSocket(url: URL(string: "ws://hhbackend5.herokuapp.com/ws")!) // Heroku connection string
//    var socket = WebSocket(url: URL(string: "ws://localhost:8080/ws")!)   // Localhost connection string
//    var socket = WebSocket(url: URL(string: "ws://13.58.122.58:8080/ws")!) // AWS connection String
    
    // MARK: Websocket Delegate Methods.
    
    func websocketDidConnect(socket: WebSocket) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("Received text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        print("Received data: \(data)")
        
        if let str = String(data: data, encoding: String.Encoding.utf8) {
            json = convertToDictionary(text: str)
            //print(str)
            print(json!["message"])
            if(json!["message"] as? String == "loginfail" || json?["message"] as? String == "loginsuccess") {
                LoginViewController().didReceiveData()
            } else if(json!["message"] as? String == "deleteridesuccessful" || json!["message"] as? String == "deleteridefail") {
                print("Got into here")
                let vc = UIApplication.topViewController() as? RideViewController
                vc?.goBack()
                
            } else if(json!["message"] as? String == "addridesuccess" || json!["message"] as? String == "addridefail") {
                let vc = UIApplication.topViewController() as? AddRideViewController
                vc?.goBack()
            } else if(json!["message"] as? String == "signupsuccess" || json!["message"] as? String == "signupfail") {
                //SignUpViewController().didReceiveData()
                let vc = UIApplication.topViewController() as? SignUpViewController
                vc?.didReceiveData()
            } else if(json!["message"] as? String == "guestviewsuccess") {
                LoginViewController().guestView()
            } else if(json!["message"] as? String == "addridersuccessful" || json!["message"] as? String == "addriderfail") {
                let vc = UIApplication.topViewController() as? RideViewController
                vc?.displayAlert()
            } else if(json!["message"] as? String == "getdatasuccess") {
                print("GOT HERE")
                let vc = UIApplication.topViewController() as? FeedTableViewController
                vc?.refreshData()
            } else if(json!["message"] as? String == "someonejoinedride") {
                let vc = UIApplication.topViewController()
                
                let alertController = UIAlertController(title: "New rider", message: json!["someonejoinedride"] as? String, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in}
                alertController.addAction(action)
                
                vc?.present(alertController, animated: true, completion: nil)
            } else if(json!["message"] as? String == "searchsuccess") {
                let vc = UIApplication.topViewController() as? GMSMapViewController
                vc?.goBack()
            }
        } else {
            print("not a valid UTF-8 sequence")
        }
    }
    
    func establishConnection(completion: @escaping ()->Void) {
        socket.delegate = self
        socket.connect()
        socket.onConnect = {
            completion()
        }
    }

    func closeConnection() {
        socket.disconnect()
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

}
