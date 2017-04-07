//
//  File.swift
//  Hitchhikers
//
//  Created by William Z Wang on 4/6/17.
//  Copyright © 2017 William Z Wang. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell() {
        profileImage.image = UIImage(named:"jeffrey_miller.jpg");
        profileImage.layer.cornerRadius = 31.5;
        profileImage.layer.masksToBounds = true;
        destinationLabel.text = "University California, Berkley, Berkley CA 94720";
        departureTimeLabel.text = "April 8, 2017 11:00 am"
        mapView.isZoomEnabled = false;
        mapView.isScrollEnabled = false;
        mapView.isUserInteractionEnabled = false;
    }
    
}

