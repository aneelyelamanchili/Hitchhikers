//
//  ProfileViewController.swift
//  Hitchhikers
//
//  Created by Aneel Yelamanchili on 4/5/17.
//  Copyright © 2017 William Z Wang. All rights reserved.
//

import UIKit
import SwiftIconFont
import SlideMenuControllerSwift
import CoreImage

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let logo = UIImage(named: "mountain_icon.png")
//        let imageView = UIImageView(image:logo)
//        self.navigationItem.titleView = imageView
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissView))
//        self.navigationItem.leftBarButtonItem?.icon(from: .Themify, code: "close", ofSize: 25)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.27, blue:0.31, alpha:1.0)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true;
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let img = CIImage(image: UIImage(named: "JeffreyMiller.jpg")!)
        
        let vignette = CIFilter(name: "CIVignette")
        vignette?.setValue(img, forKey:kCIInputImageKey)
        vignette?.setValue(2, forKey:kCIInputIntensityKey)
        //vignette?.setValue(30, forKey:kCIInputRadiusKey)
        
        self.profileImage.image = UIImage(ciImage: (vignette?.outputImage)!)
        profileImage.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        profileImage.contentMode = .scaleAspectFit
        profileImage.clipsToBounds = true

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem(viewController: "ProfileViewController")
    }
    
    func dismissView(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "FeedTableViewController") as! FeedTableViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        let slideMenuController = SlideController(mainViewController: nvc, leftMenuViewController: leftViewController)
        self.slideMenuController()?.changeMainViewController(slideMenuController, close: true)
    
    }
    
    
}
