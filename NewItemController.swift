//
//  NewItemController.swift
//  HoosList2
//
//  Created by Ram Ramkumar on 12/1/15.
//  Copyright © 2015 Ram Ramkumar. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import Foundation

class NewItemController: UITableViewController {
    
    var tasks = [NSManagedObject]()
    
    @IBOutlet weak var taskNameField: UITextField!
    
    
    @IBOutlet weak var weekdayField: UITextField!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var locationField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveTask" {
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedObjectContext = appDelegate.managedObjectContext
            
            //2
            let fetchRequest = NSFetchRequest(entityName: "Task")
            
            //3
            do {
                let results =
                try managedObjectContext.executeFetchRequest(fetchRequest)
                tasks = results as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }

            
            let task = NSEntityDescription.insertNewObjectForEntityForName("Task", inManagedObjectContext:managedObjectContext) as! Task
            
            task.id = String(tasks.count + 1)
            
            let name = taskNameField.text!
            task.name = String(name)
            
            let day = weekdayField.text!
            task.day = String(day)
            
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let startDateString = dateFormatter.stringFromDate(startDatePicker.date)
            let endDateString = dateFormatter.stringFromDate(endDatePicker.date)
            
            task.startTime = startDatePicker.date
            
            task.endTime = endDatePicker.date
            
            let location = locationField.text!
            task.location = String(location)
            
            task.recommended = false
            
            task.completed = false
            
            do {
                try managedObjectContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
            
            let request = NSMutableURLRequest(URL: NSURL(string: "http://goodwin.io/API/submitTask.php")!)
            request.HTTPMethod = "POST"
            
            
            
            let postString = "name=" + name + "&weekday=" + day + "&startDate=" + startDateString + "&endDate=" + endDateString + "&location=" + location
            
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let req = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    return
                }
                
                print("response = \(response)")
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
            }
            req.resume()
            
            
        }
    }

}
