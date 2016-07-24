//
//  SwitchCell.swift
//  Yelp
//
//  Created by Nguyen Thanh Thuc on 18/07/2016.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterSwitchCellDelegate {
    optional func filterSwitchCell(filterSwitchCell: FilterSwitchCell, value: Bool)
}

class FilterSwitchCell: UITableViewCell {
    
    var delegate: FilterSwitchCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var switchButton: UISwitch!
    
    @IBOutlet weak var seeMoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        seeMoreLabel.hidden = true
        seeMoreLabel.layer.cornerRadius = 5
        seeMoreLabel.layer.masksToBounds = true
        
        switchButton.onTintColor = UIColor(colorLiteralRed: 208/255.0, green: 25/255.0, blue: 42/255.0, alpha: 1)
    }
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func onSwitchAction(sender: UISwitch) {
        delegate!.filterSwitchCell!(self, value: sender.on)
    }
    
    
}
