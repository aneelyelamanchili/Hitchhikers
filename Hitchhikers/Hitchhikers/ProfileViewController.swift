//
//  ProfileViewController.swift
//  Hitchhikers
//
//  Created by Aneel Yelamanchili on 4/5/17.
//  Copyright © 2017 William Z Wang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let logo = UIImage(named: "mountain_icon.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.27, blue:0.31, alpha:1.0)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false;
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0)
        //        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    
}
