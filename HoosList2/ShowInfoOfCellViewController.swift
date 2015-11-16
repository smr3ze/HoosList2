//
//  ShowInfoOfCellViewController.swift
//  HoosList2
//
//  Created by Blake Goodwin on 10/28/15.
//  Copyright © 2015 Ram Ramkumar. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import Foundation

class ShowInfoOfCellViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate  {
    
    var tasks = [NSManagedObject]()

    let locationManager = CLLocationManager()
    var currentLoc = String()
    
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var takePhoto: UIButton!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var recommendedLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var startTitleLabel: UILabel!
    @IBOutlet weak var endTitleLabel: UILabel!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var dayTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //findMyLocationText()
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Task")
        
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            tasks = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        for task in tasks {
            if ((task.valueForKey("name") as! String) == name) {
                let startTime = task.valueForKey("startTime") as! NSDate
                print(startTime)
                let endTime = task.valueForKey("endTime") as! NSDate
                print(endTime)
                let day = task.valueForKey("day") as! String
                let recommended = task.valueForKey("recommended") as! Bool
                var completed = task.valueForKey("completed") as! Bool
                
                let location = task.valueForKey("location") as! String
                print(location)
                
                //process location text
                locationTitleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
                locationTitleLabel.textColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
                if(location == "nil"){
                    locLabel.text = "N/A"
                }
                else{
                    locLabel.text = location
                }
                
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let properDateFormatter = NSDateFormatter()
                properDateFormatter.dateFormat = "MM-dd-yyyy"

                //process start date display text
                startTitleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
                startTitleLabel.textColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
                if(dateFormatter.stringFromDate(startTime) == "2001-01-01"){
                    startDateLabel.text = "N/A"
                }
                else{
                    startDateLabel.text = properDateFormatter.stringFromDate(startTime)
                }
                
                endTitleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
                endTitleLabel.textColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
                //process end date display text
                if(dateFormatter.stringFromDate(endTime) == "2100-01-01"){
                    endDateLabel.text = "N/A"
                }
                else{
                    endDateLabel.text = properDateFormatter.stringFromDate(endTime)
                }
    
                //process day label
                dayTitleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
                dayTitleLabel.textColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
                if (day == "nil") {
                    dayLabel.text = "N/A"
                }
                else {
                    dayLabel.text = day
                }

                if (recommended) {
                    recommendedLabel.text = "Recommended!"
                }
                else {
                    recommendedLabel.text = " "
                }
                
                if(!completed){
                    //getting current date/day
                    let date = NSDate()
                    let dayFormatter = NSDateFormatter()
                    dayFormatter.dateFormat = "EEEE"
                    
                    let dayOfWeek = dayFormatter.stringFromDate(date)
                    //let currDateStr = dateFormatter.stringFromDate(date)
                    
                    var passReqs = true
                    
                    //checking day of week
                    if(!(dayOfWeek == day || day == "nil")){
                        passReqs = false
                        dayTitleLabel.textColor = UIColor(red: 217/255, green: 30/255, blue: 24/255, alpha: 1.0)
                        dayLabel.textColor = UIColor(red: 217/255, green: 30/255, blue: 24/255, alpha: 1.0)
                    }
                    
                    //checking date range
                    let dateComparisonResultStart:NSComparisonResult = date.compare(startTime)
                    
                    if(!(dateComparisonResultStart == NSComparisonResult.OrderedDescending)){
                        passReqs = false;
                        startDateLabel.textColor = UIColor(red: 217/255, green: 30/255, blue: 24/255, alpha: 1.0)
                        startTitleLabel.textColor = UIColor(red: 217/255, green: 30/255, blue: 24/255, alpha: 1.0)
                    }
                    
                    let dateComparisonResultEnd:NSComparisonResult = date.compare(endTime)
                    if(!(dateComparisonResultEnd == NSComparisonResult.OrderedAscending)){
                        passReqs = false;
                        endDateLabel.textColor = UIColor(red: 217/255, green: 30/255, blue: 24/255, alpha: 1.0)
                        endTitleLabel.textColor = UIColor(red: 217/255, green: 30/255, blue: 24/255, alpha: 1.0)
                    }
                    
                    //checking location
                    if(!(currentLoc == location || location == "nil")){
                        passReqs = false
                        locLabel.textColor = UIColor(red: 217/255, green: 30/255, blue: 24/255, alpha: 1.0)
                    }
                    
                    //if reqs are true, take photo
                    if(passReqs == true){
                        completed = true
                        print("completed:", completed)
                        //takePhoto.setTitle("Mark as completed!", forState: .Normal)
                        //takePhoto.enabled = true
                    }
                    //otherwise, disable button
                    else{
                        print("completed", completed)
//                        takePhoto.setTitle("Requirements not met!", forState: .Normal)
//                        takePhoto.enabled = false
                    }
                }
                else{
                    takePhoto.hidden = true
                }
            }
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func findMyLocationText() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func findMyLocation(sender: AnyObject) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil)
            {
                print("Error: " + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0
            {
                let pm = placemarks![0] 
                self.displayLocationInfo(pm)
            }
            else
            {
                print("Error with the data.")
            }
        })
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        //stop updating location to save battery life
        self.locationManager.stopUpdatingLocation()
//        print(placemark.subThoroughfare! + " " + placemark.thoroughfare!)
//        print(placemark.name!)
//        print(placemark.locality!)
//        print(placemark.administrativeArea! + " " + placemark.postalCode!)
//        print(placemark.country!)
        locationLabel.numberOfLines = 3
        currentLoc = placemark.subThoroughfare! + " " + placemark.thoroughfare!
            //+ ", "+ placemark.locality! + ", " + placemark.administrativeArea! + " " + placemark.postalCode!
        locationLabel.text = placemark.subThoroughfare! + " " + placemark.thoroughfare! + ", " + placemark.locality! + ", " + placemark.administrativeArea! + " " + placemark.postalCode!
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    var name = String()
    
    override func viewWillAppear(animated:Bool) {
        cellName.text = name;
        cellName.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        cellName.textColor = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1.0)
    }
    
    

}
