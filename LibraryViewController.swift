//
//  LibraryViewController.swift
//  EmojiAppSwiftify
//
//  Created by Guy Van Looveren on 7/25/14.
//  Copyright (c) 2014 Pro Sellers World. All rights reserved.
//

import Foundation
import UIKit

class LibraryViewController : UIViewController{
    
    @IBOutlet weak var searchLibrary: UISearchBar!
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func subButtonHeader(sender: UIButton) {
        
    }
    
}