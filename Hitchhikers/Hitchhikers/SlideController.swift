//
//  SlideController.swift
//  Hitchhikers
//
//  Created by Aneel Yelamanchili on 4/5/17.
//  Copyright © 2017 William Z Wang. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift

class SlideController: SlideMenuController {
    override func isTagetViewController() -> Bool {
        if let vc = UIApplication.topViewController() {
            if vc is FeedTableViewController ||
                vc is ProfileViewController {
                return true
            }
        }
        
        return false
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
