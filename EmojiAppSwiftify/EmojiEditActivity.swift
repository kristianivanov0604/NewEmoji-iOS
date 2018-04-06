//
//  EmojiEditActivity.swift
//  SampleSwift
//
//  Created by Yingcheng Li on 12/23/14.
//  Copyright (c) 2014 Dave. All rights reserved.
//

import UIKit

class EmojiEditActivity: UIActivity {
    
    var emojiartViewController :EmojiArtViewController!
    override func activityType() -> String? {
        return "your Custom Type"
    }
    
    override func activityTitle() -> String? {
        return "Edit"
    }
    
    
    override func activityImage() -> UIImage? {
        return UIImage(named: "edit_button.png")
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        return true
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        
    }
    
    override func performActivity() {
        emojiartViewController.showEmojiArtEdit()
    }
}
