//
//  ViewController.swift
//  HoosList2
//
//  Created by Ram Ramkumar on 10/28/15.
//  Copyright © 2015 Ram Ramkumar. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import Foundation

class ViewController: UITableViewController, CLLocationManagerDelegate {
    
    var tasks = [NSManagedObject]()
    let locationManager = CLLocationManager()
    var currentLocSend = ""


    
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        findMyLocationText()
        
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
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.valueForKey("name") as? String
        let complete = task.valueForKey("completed") as? Int
        if (complete == 1) {
            cell.textLabel?.textColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
        }
        
        return cell
    }
    
    let SegueIdentifier = "ShowInfoSegue"
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier {
            if let destination = segue.destinationViewController as? ShowInfoOfCellViewController {
                if let cellIndex = tableview.indexPathForSelectedRow?.row {
                    let task = tasks[cellIndex]

                    destination.name = (task.valueForKey("name") as? String)!
                    destination.currentLoc = currentLocSend
                }
            }
        }
    }
    
    
    
    func findMyLocationText() {
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
        currentLocSend  = placemark.subThoroughfare! + " " + placemark.thoroughfare!
        //+ ", "+ placemark.locality! + ", " + placemark.administrativeArea! + " " + placemark.postalCode!

    }



}

