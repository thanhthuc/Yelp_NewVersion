//
//  FiltersViewController.swift
//  Yelp
//
//  Created by admin on 7/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//
import Foundation
import AFNetworking

enum Preferences: String {
    case SortBy = "Sort by"
    case Deal = "Deal"
    case Radius = "Radius"
    case Categories = "Categories"
}

@objc protocol FiltersViewControllerDelegate {
    
    optional func filtersViewController(filtersViewController: FiltersViewController, categoryFilter: [String], dealFilter: Bool, sortFilter: Int, radius: Int)
    
}

class FiltersViewController: UIViewController {
    
    //for tableView
    var titleSections: [Preferences] = [.Deal, .Radius, .SortBy, .Categories]
    
    let structTableExpand = [["Offering Deal"], ["Auto", "1 mi", "3 mi", "5 mi"], ["Best Matched", "Distance", "Highest Rated"], CategoriesData.data()]

    let structTableColapse = [["Offering Deal"], ["Auto"], ["Best Matched"], [CategoriesData.data()[0], CategoriesData.data()[1], CategoriesData.data()[2]]]
    
    var structTableColapseFirst = [["Offering Deal"], ["Auto"], ["Best Matched"], [CategoriesData.data()[0], CategoriesData.data()[1], CategoriesData.data()[2]]]
    
    var isVisitedAtRow: [[Bool]] = [[Bool](count: 1, repeatedValue: false), [Bool](count: 5, repeatedValue: false),
                                     [Bool](count: 3, repeatedValue: false), [Bool](count: CategoriesData.data().count, repeatedValue: false)]
    
    
    //save data from cell
    var offeringDeal: Bool = false
    var sortBySelected: Int = 0
    var radius: Int = 0
    var switchCategoriesStates: [Int: Bool] = [:]
    
    
    //filter viewcontroller
    var delegate: FiltersViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTable()
        // Do any additional setup after loading the view.
    }
    
    func configTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40
        
        //Register cell from nib
        tableView.registerNib(UINib(nibName: "FilterCheckCell", bundle: nil), forCellReuseIdentifier: "checkCell")
        tableView.registerNib(UINib(nibName: "FilterSwitchCell", bundle: nil), forCellReuseIdentifier: "switchCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelAction(sender: AnyObject) {
        
         self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSearchAction(sender: AnyObject) {
        
        var categoriesfilters = [String]()
        
        for (row, isSelected) in switchCategoriesStates {
            if isSelected {
                categoriesfilters.append(CategoriesData.code()[row])
            }
        }
        

        delegate?.filtersViewController!(self, categoryFilter: categoriesfilters, dealFilter: offeringDeal, sortFilter: sortBySelected, radius: radius)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func resetAllFilter(sender: AnyObject) {
        
        let alertVC = UIAlertController(title: "Reset filters?", message: "Do you want reset filters to default", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
        }
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
}


extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleSections[section].rawValue
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return structTableColapseFirst.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 3 {
            //return seeMoreCell
            return structTableColapseFirst[section].count + 1
        }
        else {
            return structTableColapseFirst[section].count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
  
        //reuse cell
        let cellCheck = tableView.dequeueReusableCellWithIdentifier("checkCell") as! FilterCheckCell
        let cellSwitch = tableView.dequeueReusableCellWithIdentifier("switchCell") as! FilterSwitchCell
        
        //filter delegate
        cellSwitch.delegate = self
        cellCheck.delegate = self
        
        //init state
        cellSwitch.switchButton.on = switchCategoriesStates[indexPath.row] ?? false
        
        let section = indexPath.section
        if section == 0 {
            cellSwitch.titleLabel.text = structTableColapseFirst[indexPath.section][indexPath.row]
            return cellSwitch
        }
        
        else if section == 1 || section == 2 {
            cellCheck.titleLabel.text = structTableColapseFirst[indexPath.section][indexPath.row]
            if indexPath.row == 0 {
                cellCheck.checkButton.setImage(UIImage(named: "orange_check"), forState: UIControlState.Normal)
            }
            else {
                cellCheck.checkButton.setImage(UIImage(named: "gray_check"), forState: UIControlState.Normal)
            }
            return cellCheck
        }
        
        else {
            let numOfRowInSection = tableView.numberOfRowsInSection(indexPath.section)
            if indexPath.row == 3 && numOfRowInSection == 4{
                cellSwitch.titleLabel.hidden = true
                cellSwitch.switchButton.hidden = true
                cellSwitch.seeMoreLabel.text = "See more"
                cellSwitch.seeMoreLabel.hidden = false
            }
            else if indexPath.row == CategoriesData.data().count {
                cellSwitch.titleLabel.hidden = true
                cellSwitch.switchButton.hidden = true
                cellSwitch.seeMoreLabel.text = "Colapse"
                cellSwitch.seeMoreLabel.hidden = false
            }
            else {
                cellSwitch.titleLabel.text = structTableColapseFirst[indexPath.section][indexPath.row]
                cellSwitch.titleLabel.hidden = false
                cellSwitch.switchButton.hidden = false
                cellSwitch.seeMoreLabel.hidden = true
            }
            return cellSwitch

        }
   
    }
    
   
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let section = indexPath.section
        let row = indexPath.row
        let countCategories = CategoriesData.data().count
        //if section is categories, just colapse and expand at seeMoreCell
        
        if section == 0 {
            //do not load section
        }
        
        else if section == 3 {
            if indexPath.row == 3 {
                structTableColapseFirst[section] = structTableExpand[section]
                tableView.reloadSections(NSIndexSet(index: section) , withRowAnimation: .Fade)
            }
            else if indexPath.row == countCategories {
                structTableColapseFirst[section] = structTableColapse[section]
                tableView.reloadSections(NSIndexSet(index: section) , withRowAnimation: .Fade)
            }
        }
            
        //this is should colapse each cell
        else {
            if isVisitedAtRow[section][row] == false {
                
                structTableColapseFirst[section] = structTableExpand[section]
                //reset all cell to visited
                for row in 0..<isVisitedAtRow[section].count {
                    isVisitedAtRow[section][row] = true
                }
                
                //give data to row 0
                if section == 1 {
                    structTableColapseFirst[section][0] = structTableColapse[section][row]
                    if indexPath.row == 0 {
                        radius = 1
                    }
                    if indexPath.row == 1 {
                        radius = 3
                    }
                    if indexPath.row == 2 {
                        radius = 5
                    }
                }
                if section == 2 {
                    structTableColapseFirst[section][0] = structTableColapse[section][row]
                    sortBySelected  = indexPath.row
                }
            }
                
            else {
                structTableColapseFirst[section] = structTableColapse[section]
                //reset all cell to not visited
                for row in 0..<isVisitedAtRow[section].count {
                    isVisitedAtRow[section][row] = false
                }
                
                //give data to row 0
                if section == 1 || section == 2 {
                    structTableColapseFirst[section][0] = structTableExpand[section][row]
                    sortBySelected  = indexPath.row
                }
            }
            tableView.reloadSections(NSIndexSet(index: section) , withRowAnimation: .Fade)
        }
    }
}


extension FiltersViewController: FilterSwitchCellDelegate, FilterCheckCellDelegate {
    
    
    func filterSwitchCell(filterSwitchCell: FilterSwitchCell, value: Bool) {
        
        let indexPath = tableView.indexPathForCell(filterSwitchCell)
        if indexPath?.section == 0 {
            offeringDeal = value
        }
        else {
            switchCategoriesStates[indexPath!.row] = value
        }
    }
    
    func filterCheckCell(filterCheckCell: FilterCheckCell, isSelected: Bool) {
        
    }
    
}










