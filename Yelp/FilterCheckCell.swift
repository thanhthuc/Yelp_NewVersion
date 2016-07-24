//
//  FilterCellHaveCheck.swift
//  Yelp
//
//  Created by Nguyen Thanh Thuc on 18/07/2016.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterCheckCellDelegate {
    optional func filterCheckCell(filterCheckCell: FilterCheckCell, isSelected: Bool)
}

class FilterCheckCell: UITableViewCell {

    var delegate: FilterCheckCellDelegate!
 
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var checkButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    @IBAction func onCheckAction(sender: UIButton) {
        
//        if sender.selected == false {
//            checkButton.setImage(UIImage(named: "checked"), forState: .Normal)
//            sender.selected = true
//        }
//        else {
//            checkButton.setImage(UIImage(named: "uncheck"), forState: .Normal)
//            sender.selected = false
//        }
//        
        
        self.delegate.filterCheckCell!(self, isSelected: sender.selected)
    }
    
}
