//
//  DetailViewController.swift
//  Yelp
//
//  Created by Nguyen Thanh Thuc on 19/07/2016.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {
    
    
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var categories: UILabel!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var rateImage: UIImageView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var distance: UILabel!

    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let URL = business.imageURL
        mainImage.setImageWithURL(URL!)
        
        let rateURL = business.ratingImageURL
        rateImage.setImageWithURL(rateURL!)
        
        name.text = business.name
        distance.text = business.distance
        reviewCount.text = String(business.reviewCount)
        address.text = business.address
        categories.text = business.categories
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        mainImage.layer.masksToBounds = true
        mainImage.layer.cornerRadius = mainImage.bounds.size.width/2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
