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
    let toPopulate = Client.sharedInstance.json
    
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
        
        let imageString = toPopulate?["picture"] as! String;
        let url = URL(string: toPopulate?["picture"] as! String)
        let data = try? Data(contentsOf: url!)
        
        
        let image = UIImage(data: data!)
        
        
        let img = CIImage(image: image!)
        
        let vignette = CIFilter(name: "CIVignette")
        vignette?.setValue(img, forKey:kCIInputImageKey)
        vignette?.setValue(2, forKey:kCIInputIntensityKey)
        
        self.profileImage.image = UIImage(ciImage: (vignette?.outputImage)!)
        
        self.profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        self.profileImage.clipsToBounds = true


        
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
