
//
//  CoolAppsViewController.swift
//  EmojiAppSwiftify
//
//  Created by Guy Van Looveren on 7/26/14.
//  Copyright (c) 2014 Pro Sellers World. All rights reserved.
//

import Foundation
import UIKit

class CoolAppsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var coolAppsTable: UITableView!
    var coolAppData = [Dictionary<String, String>]()
    
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    let imageOne = UIImage(named: "cool_app_cell_one"), imageTwo = UIImage(named: "cool_app_cell_two")
    
    override func viewDidLoad() {
        coolAppData = EmojiDataLoader().getCoolAppData()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var coolAppCell : CoolAppsTableCell = tableView.dequeueReusableCellWithIdentifier("CoolAppsCell") as CoolAppsTableCell
        let xxx = (CGFloat(Float(indexPath.row) / 2))
        coolAppCell.backgroundColor = UIColor.clearColor()

        let appdata = coolAppData[indexPath.row]
        coolAppCell.appIcon.image = (UIImage(named: appdata["icon"]!))

        coolAppCell.appTitle.text = appdata["title"]
        coolAppCell.appComment.text = appdata["comment"]
        
        return coolAppCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 10
        if coolAppData.count > 0 {
           count = coolAppData.count
        }
        return count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let appdata = coolAppData[indexPath.row]
        if let url = NSURL(string:appdata["link"]!) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
}