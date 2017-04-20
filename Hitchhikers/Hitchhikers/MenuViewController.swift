//
//  MenuViewController.swift
//  Hitchhikers
//
//  Created by Aneel Yelamanchili on 4/5/17.
//  Copyright © 2017 William Z Wang. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    case main = 0
    case profile
    case logout
}

protocol LeftMenuProtocol: class {
    func changeViewController(_ menu: LeftMenu)
}

class MenuViewController: UIViewController, LeftMenuProtocol {
    
    var tableView = UITableView()
    var menus = ["Main", "Payment", "Logout"]
    var mainViewController: UIViewController!
    var profileViewController: UIViewController!
    
    let toPopulate = Client.sharedInstance.json
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(red:0.15, green:0.27, blue:0.36, alpha:1.0)
        
        let viewSize:CGSize = self.view.frame.size;
        let newView = UIView(frame: CGRect(x: 0, y: 0, width: viewSize.width-105, height: 150))
        newView.backgroundColor = UIColor(red:0.19, green:0.27, blue:0.31, alpha:1.0)
        
        let imageString = toPopulate?["picture"] as! String;
        let url = URL(string: toPopulate?["picture"] as! String)
        let data = try? Data(contentsOf: url!)
        
        
        let image = UIImage(data: data!)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 15, y: 20, width: 100, height: 100)
        imageView.layer.borderWidth = 0.1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        newView.addSubview(imageView)
        
        let label = UILabel(frame: CGRect(x: 190, y: 74, width: 200, height: 21))
        label.center = CGPoint(x: 190, y: 74)
        label.textAlignment = .center
        label.text = (toPopulate?["firstname"] as? String)! + " " + (toPopulate?["lastname"] as? String)!
        label.textColor = UIColor.white
        newView.addSubview(label)
        
        self.tableView.frame = CGRect(x: 0, y: 150, width: viewSize.width-105, height: viewSize.height)
        //self.tableView.separatorColor = UIColor.clear
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 25, 0, 80);
        self.tableView.tableFooterView = UIView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        self.profileViewController = UINavigationController(rootViewController: profileViewController)
        
        self.tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: "BaseTableViewCell")
        self.view.addSubview(self.tableView)
        self.view.addSubview(newView);

        let gesture = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.handleTap(sender:)))
        newView.addGestureRecognizer(gesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        dismiss(animated: true, completion: nil)
//    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .main:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "FeedTableViewController") as! FeedTableViewController
            let leftViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
            let slideMenuController = SlideController(mainViewController: nvc, leftMenuViewController: leftViewController)
            
            let sendMessage = Client.sharedInstance.json
            mainViewController.toPopulate = sendMessage
            
            self.slideMenuController()?.changeMainViewController(slideMenuController, close: true)
        case .profile:
            self.slideMenuController()?.changeMainViewController(self.profileViewController, close: true)
        case .logout:
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            // vc is the Storyboard ID that you added
//            // as! ... Add your ViewController class name that you want to navigate to
//            let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            self.present(controller, animated: true, completion: { () -> Void in
//            })
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = mainViewController
            self.dismiss(animated: true) {
                Client.sharedInstance.closeConnection()
                let _ = self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.slideMenuController()?.changeMainViewController(self.profileViewController, close: true)
    }
    
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            switch menu {
            case .main, .profile, .logout:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(menus.count)
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            switch menu {
            case .main, .profile, .logout:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
}

extension MenuViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            // future development
        }
    }
}
