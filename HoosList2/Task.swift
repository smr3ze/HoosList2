//
//  Task.swift
//  HoosList2
//
//  Created by Ram Ramkumar on 11/3/15.
//  Copyright © 2015 Ram Ramkumar. All rights reserved.
//

import Foundation
import CoreData

@objc(Task) class Task: NSManagedObject {
    
    @NSManaged var id: Int32
    @NSManaged var name: String
    @NSManaged var startTime: NSDate
    @NSManaged var endTIme: NSDate
    @NSManaged var day: String
    @NSManaged var recommended: Bool
    @NSManaged var completed: Bool
    @NSManaged var location: Location
}