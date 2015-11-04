//
//  ViewController.swift
//  HoosList2
//
//  Created by Ram Ramkumar on 10/28/15.
//  Copyright © 2015 Ram Ramkumar. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var tasks = [NSManagedObject]()

    
    @IBOutlet var tableview: UITableView!
    
    let items = ["Sing the Good Ole Song", "Paint Beta Bridge", "Visit a vineyard"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
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
        
        return cell
    }
    
    let SegueIdentifier = "ShowInfoSegue"
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier {
            if let destination = segue.destinationViewController as? ShowInfoOfCellViewController {
                if let cellIndex = tableview.indexPathForSelectedRow?.row {
                    let task = tasks[cellIndex]

                    destination.name = (task.valueForKey("name") as? String)!
                }
            }
        }
    }

}

