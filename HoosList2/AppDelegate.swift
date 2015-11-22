//
//  AppDelegate.swift
//  HoosList2
//
//  Created by Ram Ramkumar on 10/28/15.
//  Copyright © 2015 Ram Ramkumar. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.backItem
        navigationBarAppearance.tintColor = UIColor.whiteColor()
        navigationBarAppearance.barTintColor = UIColor(red:0.02, green:0.44, blue:0.82, alpha:1.0)
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        print("starting didFinishLaunchingWithOptions")
        if (entityIsEmpty("Task")) {
            preloadData()
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "edu.virginia.cs.httpscs4720.HoosList2" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("HoosList2", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func preloadData () {
        let managedObjectContext = self.managedObjectContext

        

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
        
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
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
                    task.name = attrArray["name"] as! String
                    task.day = attrArray["weekday"] as! String
                    
                    //print(attrArray[1])
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    if (attrArray["startDate"] as! String == "nil") {
                        let faux = "2001-01-01";
                        task.startTime = dateFormatter.dateFromString(faux)!
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
            // now we have the post, let's just print it to prove we can access it
            //print("The post is: " + post.description)

            
            // the post object is a dictionary
            // so we just access the title using the "title" key
            // so check for a title and print it if we have one
//            if let postTitle = data["title"] as? String {
//                print("The title is: " + postTitle)
//            }
        })
        task.resume()

//        for lines in fileArray {
//
//            let task = NSEntityDescription.insertNewObjectForEntityForName("Task", inManagedObjectContext:managedObjectContext) as! Task
//            var attrArray = lines.componentsSeparatedByString(",")
//            task.id = attrArray[0]
//            task.name = attrArray[1]
//            task.day = attrArray[2]
//            
//            print(attrArray[1])
//            
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            
//            if (attrArray[3] == "nil") {
//                let faux = "2001-01-01";
//                task.startTime = dateFormatter.dateFromString(faux)!
//            }
//            else {
//                task.startTime = dateFormatter.dateFromString(attrArray[3])!
//            }
//            
//            if (attrArray[4] == "nil") {
//                let faux = "2100-01-01";
//                task.endTime = dateFormatter.dateFromString(faux)!
//            }
//            else {
//                task.endTime = dateFormatter.dateFromString(attrArray[4])!
//            }
//            
//            task.location = attrArray[5]
//            print(attrArray[5], ",", task.location)
//            
//            if (attrArray[6] == "1") {
//                task.recommended = true;
//            }
//            else {
//                task.recommended = false;
//            }
//
//            task.completed = false;
//            
//            do {
//                try managedObjectContext.save()
//            } catch let error as NSError  {
//                print("Could not save \(error), \(error.userInfo)")
//            }
//        }
        

    

    }
    
    
    func entityIsEmpty(entity: String) -> Bool
    {
        let managedObjectContext = self.managedObjectContext

    
        let request = NSFetchRequest(entityName: "Task")
        
        
        do {
            let results:NSArray? = try managedObjectContext.executeFetchRequest(request)
            if results!.count == 0
            {
                return true
            }
            else
            {
                return false
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return false
        }
        
        

        
    }

}