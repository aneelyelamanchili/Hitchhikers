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

    var socket = WebSocket(url: URL(string: "ws://192.241.211.78:1234/")!)
    
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
        print("Received data: \(data.count)")
    }
    
    func connect() {
        socket.delegate = self
        socket.connect()
    }


}
