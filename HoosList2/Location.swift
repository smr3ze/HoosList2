//
//  Location.swift
//  HoosList2
//
//  Created by Ram Ramkumar on 11/3/15.
//  Copyright © 2015 Ram Ramkumar. All rights reserved.
//

import Foundation
import CoreData

@objc(Location) class Location: NSManagedObject {
    
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var gpslocs: Task
}
