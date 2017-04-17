//
//  UIViewController.swift
//  Hitchhikers
//
//  Created by Aneel Yelamanchili on 4/5/17.
//  Copyright © 2017 William Z Wang. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setNavigationBarItem(viewController: String) {
        if(viewController == "FeedTableViewController") {
            self.addLeftBarButtonWithImage(UIImage(named: "hamburger_menu.png")!)
        } else {
            self.addLeftBarButtonWithImage(UIImage(named: "vertical_dots.png")!)
        }
//        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red:0.25, green:0.72, blue:0.91, alpha:1.0)
//        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red:0.25, green:0.72, blue:0.91, alpha:1.0)
        //self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
        //self.slideMenuController()?.addRightGestures()
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
}
