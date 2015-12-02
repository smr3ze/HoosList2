//
//  NewItemController.swift
//  HoosList2
//
//  Created by Ram Ramkumar on 12/1/15.
//  Copyright © 2015 Ram Ramkumar. All rights reserved.
//

import UIKit

class NewItemController: UITableViewController {
    
    @IBOutlet weak var taskNameField: UITextField!
    
    
    @IBOutlet weak var weekdayField: UITextField!
    
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    
    @IBOutlet weak var endDatePicker: NSLayoutConstraint!

    
    @IBOutlet weak var locationField: UITextField!
    
    
    @IBAction func cancelTask(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func saveTask(segue: UIStoryboardSegue){
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveTask" {
        }
    }

}
