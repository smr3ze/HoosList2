//
//  ViewController.swift
//  HoosList2
//
//  Created by Ram Ramkumar on 10/28/15.
//  Copyright © 2015 Ram Ramkumar. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let items = ["item1", "item2", "item3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

}

