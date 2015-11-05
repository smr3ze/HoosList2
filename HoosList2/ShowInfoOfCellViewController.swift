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

class ShowInfoOfCellViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate  {
    
    var tasks = [NSManagedObject]()

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var takePhoto: UIButton!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var recommendedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
                
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                //let stringFormatter = NSDateFormatter()
                //dateFormatter.dateFormat = "dd-MM-yyyy"
                //let fauxdate = "2001-01-01"
                
                
                startDateLabel.text = dateFormatter.stringFromDate(startTime)
                endDateLabel.text = dateFormatter.stringFromDate(endTime)

    
                
                if (day == "nil") {
                    dayLabel.text = "No day requirement"
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
                
                
                
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
    
    

}
