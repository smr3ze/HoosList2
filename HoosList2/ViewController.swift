//
//  ViewController.swift
//  HoosList2
//
//  Created by Ram Ramkumar on 10/28/15.
//  Copyright © 2015 Ram Ramkumar. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    @IBOutlet var tableview: UITableView!
    
    let items = ["Sing the Good Ole Song", "Paint Beta Bridge", "Visit a vineyard"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = items[indexPath.item]
        return cell
    }
    
    let SegueIdentifier = "ShowInfoSegue"
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier {
            if let destination = segue.destinationViewController as? ShowInfoOfCellViewController {
                if let cellIndex = tableview.indexPathForSelectedRow?.row {
                    destination.name = items[cellIndex]
                }
            }
        }
    }

}

