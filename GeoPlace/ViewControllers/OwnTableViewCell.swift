//
//  OwnTableViewCell.swift
//  GeoPlace
//
//  Created by wtildestar on 04/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit

class OwnTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfPlace: UIImageView! {
        didSet {
            imageOfPlace.layer.cornerRadius = imageOfPlace.frame.size.height / 2
            imageOfPlace.clipsToBounds = true
        }
    }
    @IBOutlet var ratingControl: RatingControl!
//        {
//        didSet {
//            isUserInteractionEnabled = false
//        }
//    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
}
