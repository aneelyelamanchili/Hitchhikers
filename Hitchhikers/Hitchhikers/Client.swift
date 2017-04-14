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
    var socket = WebSocket(url: URL(string: "ws://bc331cbd.ngrok.io/HitchhikersBackend/ws")!)
    
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
        //print("Received data: \(data)")
        
        if let str = String(data: data, encoding: String.Encoding.utf8) {
            json = convertToDictionary(text: str)
            print(str)
            if(json!["message"] as? String == "loginfail" || json?["message"] as? String == "loginsuccess") {
                LoginViewController().didReceiveData()
            } else if(json!["message"] as? String == "deleteridesuccessful") {
                print("Got into here")
                RideViewController().goBack()
            } else if(json!["message"] as? String == "makeridesuccess") {
                AddRideViewController().goBack()
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
