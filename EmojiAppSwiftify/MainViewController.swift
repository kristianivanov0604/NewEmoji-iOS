//
//  MainViewController.swift
//  EmojiAppSwiftify
//
//  Created by Guy Van Looveren on 7/23/14.
//  Copyright (c) 2014 Pro Sellers World. All rights reserved.
//

import Foundation
import UIKit

class MainViewController : UIViewController{
    struct Static {
        static var mainViewController :MainViewController!
    }

    @IBAction func pushMoreApp(sender : UIButton){
        AppDelegate().showXplode()
        
    }
    
    @IBAction func pushButtons(sender : UIButton){
        if sender.tag == 0 || sender.tag == 1 {
            performSegueWithIdentifier("toStatic", sender: sender)
        }else if sender.tag == 2 {
            performSegueWithIdentifier("toEmojiText", sender: sender)
        }else if sender.tag == 3 {
            performSegueWithIdentifier("toLibrary", sender: sender)
        }else if sender.tag == 4 {
            performSegueWithIdentifier("toEmojiArt", sender: sender)
        }else if sender.tag == 5 {
            performSegueWithIdentifier("toCoolApps", sender: sender)
        }
    }
    
    override func viewWillAppear(animated : Bool) {
        println("MainViewController appeared")
    }
    
    override func viewDidLoad() {
        println("MainViewController loaded")
        Static.mainViewController = self
    }
    
    class func checkForRatePop() {
        let count = NSUserDefaults.standardUserDefaults().integerForKey("COUNT_LAUCNCH")
        if count % 4 == 0 && count > 0 {
            let rated = NSUserDefaults.standardUserDefaults().boolForKey("RATE_APPLICATION")
            if rated == false {
                
                // show rating notification
                var rateNowButton = UIAlertAction(title: "Rate Now!", style: UIAlertActionStyle.Default, handler: { (ACTION :UIAlertAction!)in
                    Static.mainViewController.rateAppNow()
                })
                rateNowButton.enabled = true
                var rateAppAlert = UIAlertController(title: "Do you enjoy using" + "\n" + "New Emoji Free?",
                    message: "If you do, please take the time to give us a nice review or rating." + "\n" + "It really helps us a lot!" + "\n" + "=)",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                rateAppAlert.addAction(UIAlertAction(title: "No Thanks", style: UIAlertActionStyle.Default, handler: nil))
                rateAppAlert.addAction(rateNowButton)
                Static.mainViewController.presentViewController(rateAppAlert, animated: true, completion: nil)
                
            }
        }
    }
    
    
    func rateAppNow() {
        let url = NSURL(string : "itms-apps://itunes.apple.com/app/id953422418")
        if url != nil {
            UIApplication.sharedApplication().openURL(url!)
            NSUserDefaults.standardUserDefaults().setValue(true, forKeyPath: "RATE_APPLICATION")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "toStatic" {
        var destinationView : StaticViewController = segue.destinationViewController as StaticViewController
        destinationView.selectedTag = sender.tag as Int
            
        }else if segue.identifier == "toEmojiText" {
            var letterToEmoji : LetterToEmojiViewController = segue.destinationViewController as LetterToEmojiViewController

        }
    }
}