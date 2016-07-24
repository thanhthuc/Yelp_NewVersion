//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import MBProgressHUD

class BusinessesViewController: UIViewController, FiltersViewControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let mapViewMini = MKMapView(frame: CGRectMake(0, 0, 100, 200))
    
    //location manager
     var locationManager = CLLocationManager()
    
    var businesses: [Business]!
    var searchString: [Business]!
    var heighHeader: Int!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigation search
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        //map view and corelocation
        mapViewConfig()
        //add annotation
        let coordinate =  CLLocationCoordinate2D(latitude: 37.7833, longitude: -122.4167)
        // draw circular overlay centered in San Francisco
        let circleOverlay: MKCircle = MKCircle(centerCoordinate: coordinate, radius: 1000)
        mapView.addOverlay(circleOverlay)
        mapViewMini.addOverlay(circleOverlay)
        
        //tableView
        tableViewConfig()
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.searchString = businesses
            self.tableView.reloadData()
            self.addAnotationAtCoordinate()
//            for item in businesses {
//                
//            }

            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapViewConfig() {
        //make map view delegate
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapViewMini.delegate = self
        mapViewMini.showsUserLocation = true
        
        // set the region to display, this also sets a correct zoom level
        // set starting center location in San Francisco
        let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        goToLocation(centerLocation)
        
        //make corelocation delegate
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
    }
    
    func tableViewConfig() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableHeaderView = mapViewMini
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: true)
        mapViewMini.setRegion(region, animated: true)
    }
    
    func addAnotationAtCoordinate() {
        
        if businesses != nil {
            for item in businesses {
                let long = item.coordinate!["longitude"]! as! Double
                let lat = item.coordinate!["latitude"]! as! Double
                let anotation = Annotation(title: "this is annotation", locationName: item.address!, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                mapView.addAnnotation(anotation)
                mapViewMini.addAnnotation(anotation)
            }
        }
        
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "detailSegue" {
            
            let vc = segue.destinationViewController as! DetailViewController
            
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            
            vc.business = searchString[(indexPath?.row)!]
        }
        else {
            let nav = segue.destinationViewController as! UINavigationController
            let nextVC = nav.topViewController as! FiltersViewController
            nextVC.delegate = self
        }
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, categoryFilter: [String], dealFilter: Bool, sortFilter: Int, radius: Int) {
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let sortFilter = YelpSortMode(rawValue: sortFilter)
        
        Business.searchWithTerm("Thai", sort: sortFilter, categories: categoryFilter, deals: dealFilter, radius: radius) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.searchString = businesses
            self.tableView.reloadData()
            
            self.addAnotationAtCoordinate()
            
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
    @IBAction func typeShowView(sender: UIButton) {
        
        if sender.currentTitle == "Map" {
            
            self.mapView.alpha = 0
            self.tableView.alpha = 1
            UIView.animateWithDuration(0.3, delay: 0.2, options: .TransitionFlipFromRight, animations: {() in
                
                self.mapView.alpha = 1
                self.tableView.alpha = 0
                sender.setTitle("List", forState: .Normal)
       
                }, completion:nil)
        }
            
        else if sender.currentTitle == "List" {
            self.mapView.alpha = 1
            self.tableView.alpha = 0
            UIView.animateWithDuration(0.3, delay: 0.2, options: .TransitionFlipFromLeft, animations: {() in
                
                self.mapView.alpha = 0
                self.tableView.alpha = 1
                sender.setTitle("Map", forState: .Normal)
                }, completion:nil)
        }
    }
    
}

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchString != nil {
            return searchString.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! YelpCell
        cell.business = searchString[indexPath.row]
        
        return cell
    }
    
}


extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            searchString = businesses
        }
        else {
            searchString = businesses.filter({(businessItem: Business) -> Bool in
                
                var isRangeOfString = false
                
                if ((businessItem.address!.rangeOfString(searchText, options: .CaseInsensitiveSearch)) != nil) {
                    isRangeOfString = true
                }
                if ((businessItem.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch)) != nil) {
                    isRangeOfString = true
                }
                if ((businessItem.categories!.rangeOfString(searchText, options: .CaseInsensitiveSearch)) != nil) {
                    isRangeOfString = true
                }
                
                return isRangeOfString
            })
        }
        tableView.reloadData()
    }
}

extension BusinessesViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotationView"
        
        // custom image annotation
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        else {
            annotationView!.annotation = annotation
        }
        annotationView!.pinTintColor = UIColor.greenColor()
        annotationView!.leftCalloutAccessoryView = UIImageView(image: UIImage(named: "restaurant_pin"))
        
        annotationView!.canShowCallout = true
        annotationView!.calloutOffset = CGPoint(x: -5, y: 5)
        
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let circleView = MKCircleRenderer(overlay: overlay)
        circleView.strokeColor = UIColor.redColor()
        circleView.lineWidth = 1
        return circleView
    }
}

//location manager delegate
extension BusinessesViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //locationManager.stopUpdatingLocation()
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: true)
        }
    }
}


















