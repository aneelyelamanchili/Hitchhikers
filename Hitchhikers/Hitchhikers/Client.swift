//
//  Client.swift
//  Hitchhikers
//
//  Created by Aneel Yelamanchili on 3/30/17.
//  Copyright © 2017 William Z Wang. All rights reserved.
//

import Foundation
import SocketIO

class Client: NSObject {
    static let sharedInstance = Client()
    var socket = SocketIOClient(socketURL: URL(string: "http://94a43d5f.ngrok.io")!, config: [.log(true), .forcePolling(true)])

    override init() {
        super.init()
        
        socket.on("test") { dataArray, ack in
            print(dataArray)
        }
        
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }

}
