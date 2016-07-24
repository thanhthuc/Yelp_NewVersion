//
//  YelpCell.swift
//  Yelp
//
//  Created by admin on 7/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class YelpCell: UITableViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var rateImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var countReviewLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    
    var business: Business! {
        didSet {
            let URL = business.imageURL
            mainImage.setImageWithURL(URL!)
            
            let rateURL = business.ratingImageURL
            rateImage.setImageWithURL(rateURL!)
            
            nameLabel.text = business.name
            distanceLabel.text = business.distance
            countReviewLabel.text = String(business.reviewCount!)
            addressLabel.text = business.address
            categoryLabel.text = business.categories
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainImage.layer.masksToBounds = true
        mainImage.layer.cornerRadius = 10
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}








