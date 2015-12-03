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
        
        if (appDelegate.entityIsEmpty("Task")) {
            preloadData()
        }
        
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
        tableview.reloadData()
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
        else{
            cell.textLabel?.textColor = UIColor.blackColor()
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
    
    @IBAction func saveTask(segue: UIStoryboardSegue){
        tableview.reloadData()
    }
    
    
    @IBAction func cancelTask(segue: UIStoryboardSegue){
        
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
    
    func preloadData () {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDelegate.managedObjectContext
        
        
        // Retrieve data from the source file
        print("Launched preloadData")
        var fileArray = [String]()
        if let path = NSBundle.mainBundle().pathForResource("tasks", ofType: "txt") {
            if let file = try? String(contentsOfFile: path, usedEncoding: nil) {
                print("found file")
                fileArray = file.componentsSeparatedByString("\n")
            }
        }
        
        let postEndpoint: String = "http://goodwin.io/API/getTasks.php"
        guard let url = NSURL(string: postEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let retrieve = session.dataTaskWithRequest(urlRequest, completionHandler: {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET on /posts/1")
                print(error)
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                var d = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var arr = d!.componentsSeparatedByString("<")
                var dataweneed:NSString = arr[0] as NSString
                let data = try NSJSONSerialization.JSONObjectWithData(dataweneed.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers) as? NSArray
                
                var count = 1;
                for attrArray in data!{
                    let task = NSEntityDescription.insertNewObjectForEntityForName("Task", inManagedObjectContext:managedObjectContext) as! Task
                    task.id = String(count)
                    count++;
                    task.name = attrArray["name"] as! String
                    task.day = attrArray["weekday"] as! String
                    
                    //print(attrArray[1])
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    if (attrArray["startDate"] as! String == "nil") {
                        let faux = "2001-01-01";
                        task.startTime = dateFormatter.dateFromString(faux as String!)!
                    }
                    else {
                        task.startTime = dateFormatter.dateFromString(attrArray["startDate"] as! String)!
                    }
                    
                    if (attrArray["endDate"] as! String == "nil") {
                        let faux = "2100-01-01";
                        task.endTime = dateFormatter.dateFromString(faux)!
                    }
                    else {
                        task.endTime = dateFormatter.dateFromString(attrArray["endDate"] as! String)!
                    }
                    
                    task.location = attrArray["location"] as! String
                    //print(attrArray[5], ",", task.location)
                    
                    if (attrArray["recommended"] as! String == "1") {
                        task.recommended = true;
                    }
                    else {
                        task.recommended = false;
                    }
                    
                    task.completed = false;
                    
                    do {
                        try managedObjectContext.save()
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                    
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            
            
            dispatch_async(dispatch_get_main_queue(), {
                
                let fetchRequest = NSFetchRequest(entityName: "Task")
                
                //3
                do {
                    let results =
                    try managedObjectContext.executeFetchRequest(fetchRequest)
                    self.tasks = results as! [NSManagedObject]
                } catch let error as NSError {
                    print("Could not fetch \(error), \(error.userInfo)")
                }
                self.tableView.reloadData()
            })
        })
        retrieve.resume()
        
    }



}

