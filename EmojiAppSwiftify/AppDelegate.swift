//
//  AppDelegate.swift
//  EmojiAppSwiftify
//
//  Created by Guy Van Looveren on 7/23/14.
//  Copyright (c) 2014 Pro Sellers World. All rights reserved.
//
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ChartboostDelegate {
                            
    var window: UIWindow?
    var XPLODE_APP_ID = "NewEmojiFree17a74ff9310d4e4c8398c03c8e3c01d0"
    var XPLODE_APP_SECRET = "c3221aecbae428fa00ab1501148eaa7f"
    var CHARTBOOST_APP_ID = "54ac312b43150f1f89b6905b"
    var CHARTBOOST_APP_SIGN = "dcbc4133cfa419040cc370257868904f7c7617a6"
    var REVMOB_ID = "54ac59c574c7005b69c8374e"

    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
        
        // Initializing Xplode
        initXplode()
        initRevMob()

        // db loading
        EmojiDataLoader().emojiLoadAllData()
        
        return true
    }
    
    func initXplode() {
        NSUserDefaults.standardUserDefaults().setValue(false, forKeyPath: "XPLODE_SUCCESS")
        NSUserDefaults.standardUserDefaults().synchronize()
        Xplode.initializeWithAppHandle(XPLODE_APP_ID,
            appSecret: XPLODE_APP_SECRET,
            andCompletionHandler: { (error:NSError!) -> Void in
                //code
                if error == nil {
                    // Xplode initialized successfully
                    NSUserDefaults.standardUserDefaults().setValue(true, forKeyPath: "XPLODE_SUCCESS")
                    NSUserDefaults.standardUserDefaults().synchronize()
                } else {
                    println("\(error)")
                }
        })
    }
    
    func showXplode() {
        let xplode_success = NSUserDefaults.standardUserDefaults().boolForKey("XPLODE_SUCCESS")
        if xplode_success == true {
            Xplode.presentPromotionForBreakpoint("more_apps", withCompletionHandler: nil, andDismissHandler: nil)
        } else {
            println("XPLODE did not be initialized yet.")
            initXplode()
        }
    }
    
    func initRevMob() {
        NSUserDefaults.standardUserDefaults().setValue(false, forKeyPath: "REVMOB_SUCCESS")
        NSUserDefaults.standardUserDefaults().synchronize()
        let completionBlock: () -> Void = {
            NSUserDefaults.standardUserDefaults().setValue(true, forKeyPath: "REVMOB_SUCCESS")
            NSUserDefaults.standardUserDefaults().synchronize()
            RevMobAds.session().showFullscreen()
        }
        let errorBlock:(error:NSError!) -> Void = {error in
            println(error)
        }
        RevMobAds.startSessionWithAppID(REVMOB_ID, withSuccessHandler: completionBlock, andFailHandler: errorBlock)
    }
    
    func showRevMob() {
        let revmob_success = NSUserDefaults.standardUserDefaults().boolForKey("REVMOB_SUCCESS")
        if revmob_success == true {
            RevMobAds.session().showFullscreen()
        } else {
            println("XPLODE did not be initialized yet.")
            initRevMob()
        }
    }
    
    func showChartBoost() {
        Chartboost.startWithAppId(CHARTBOOST_APP_ID, appSignature:CHARTBOOST_APP_SIGN, delegate:self)
        Chartboost.showInterstitial(CBLocationHomeScreen)
    }
    
    func shouldDisplayInterstitial(location: String) -> Bool {
        println("displayed Intersitial")
        return true
    }
    
    func didFailToLoadInterstitial(location:String, withError error:CBLoadError) {
        println("\(error)")
    }
    
    func didDismissInterstitial(location: String) {
        println("dismissed interstitial at location %@", location);
    }

    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // count launching
        let count = NSUserDefaults.standardUserDefaults().integerForKey("COUNT_LAUCNCH") + 1
        NSUserDefaults.standardUserDefaults().setValue(count, forKeyPath: "COUNT_LAUCNCH")
        NSUserDefaults.standardUserDefaults().synchronize()
        MainViewController.checkForRatePop()
        println("Application lanched count: \(count)")
        showChartBoost()
        showRevMob()
    }

    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

        // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "nfrh.jjjjj" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("EmojiSaveArtModel", withExtension: "momd")
        return NSManagedObjectModel(contentsOfURL: modelURL!)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("EmojiSaveArtModel.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            //error = NSError.errorWithDomain("YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

