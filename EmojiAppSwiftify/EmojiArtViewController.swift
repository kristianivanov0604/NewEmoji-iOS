//
//  EmojiArtViewController.swift
//  EmojiAppSwiftify
//
//  Created by Guy Van Looveren on 7/24/14.
//  Copyright (c) 2014 Pro Sellers World. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MessageUI
import Social

class EmojiArtViewController : UIViewController, UITextViewDelegate, UIScrollViewDelegate, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var emojiArtEditV: UITextView!
    @IBOutlet weak var emojiArtHeader: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var artScrollView: UIScrollView!
    
    @IBOutlet weak var prvsButton: UIButton!
    @IBOutlet weak var nxtButton: UIButton!
    @IBOutlet weak var emojiScroller: UIScrollView!
    @IBOutlet weak var emojiScrollerNxtPage: UIButton!
    @IBOutlet weak var categoryView: UIView!
    
    var theApp : AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    var selectedEmojiDictionary = Dictionary<String, String>()
    var fResult = NSArray()
    var toolbar = UIToolbar()
    
    var filenameTextField : UITextField!
    var saveActionAlertButton : UIAlertAction!
    var emojiFileNameAlert : UIAlertController!
    
    var emojiCategory = Dictionary<String, [String]!>()
    var emojiArtwork = Dictionary<String, [String]!>()
    var buttOrigin : CGFloat = 0
    var artworkCategories = ["LOVE", "FUN", "MOOD", "ANIMALS", "OTHERS"]
    var selectedEmojiCategory = "LOVE"
    var selectedEmojiTag :Int = 0
    var didLoad : Bool = false
    var prevCatBtn :UIButton!
    var isEditting :Bool = false
    var isChanged :Bool = false
    var emojiEditRect :CGRect! = CGRect()
    
    @IBAction func cancelButton(sender: UIButton) {
        if isEditting {
            dismissKeyboard()
            if isChanged {
                
            }
            closeEmojiArtEdit()
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func saveButton(sender: UIButton) {

        dismissKeyboard()
        if isChanged {
            saveActionAlertButton = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (ACTION :UIAlertAction!)in
                //your code here...
                self.emojiArtwork[self.selectedEmojiCategory]![self.selectedEmojiTag] = self.emojiArtEditV.text
                EmojiDataLoader().saveEmojiArework(self.selectedEmojiCategory, emojiTexts:self.emojiArtwork[self.selectedEmojiCategory]!)
                self.changeCategory()
                self.closeEmojiArtEdit()
            })
            saveActionAlertButton.enabled = true
            emojiFileNameAlert = UIAlertController(title: "Save Emoji Art",
                message: "If you press save, the edited" + "\n" + "Emoji Art will be saved, and the" + "\n" + "original Emoji Art will be lost.",
                preferredStyle: UIAlertControllerStyle.Alert)
            emojiFileNameAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            emojiFileNameAlert.addAction(saveActionAlertButton)
            presentViewController(emojiFileNameAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func emojiScrollerNxtPage(sender: UIButton) {
        if sender.tag == 0 {
            var prvsOffset : Int! = Int(emojiScroller.contentOffset.x - emojiScroller.frame.size.width)
            
            if prvsOffset < 0 {
                prvsOffset = 0
            }
            
            emojiScroller.setContentOffset(CGPointMake(CGFloat(prvsOffset), 0), animated: true)
        }else{
            var nxtOffset : Int! = Int(emojiScroller.contentOffset.x)
            
            if nxtOffset < Int(emojiScroller.contentSize.width - emojiScroller.frame.size.width){
                nxtOffset = Int(emojiScroller.contentOffset.x + emojiScroller.frame.size.width)
            }
            
            emojiScroller.setContentOffset(CGPointMake(CGFloat(nxtOffset), 0), animated: true)
        }
    }
    
    override func viewDidLoad() {
        saveButton.enabled = false
        artScrollView.directionalLockEnabled = true
        
        var toolbar = UIToolbar()
        [UIBarButtonItem.alloc]
        toolbar.barStyle = UIBarStyle.BlackTranslucent
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil), UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("dismissKeyboard"))]
        toolbar.sizeToFit()
        
        emojiArtEditV.inputAccessoryView = toolbar        
        emojiArtEditV.hidden = true
        emojiArtEditV.layer.cornerRadius = 4.0
        emojiArtEditV.delegate = self
        
        var fRequest = NSFetchRequest(entityName: "EmojiSaveArt")
        fRequest.returnsObjectsAsFaults = false
        fResult = theApp.managedObjectContext!.executeFetchRequest(fRequest, error: nil)!
        if fResult.count > 0 {
            println("Load Def Emoji Free")
        }
        
        selectedEmojiDictionary = EmojiDataLoader().getLeterTypeSetDictionary(2)["EmojiSetOne"]!
        
        didLoad = false;
    }
    
    override func viewDidLayoutSubviews() {
        if didLoad {
            return;
        }
        didLoad = true;
        emojiScroller.pagingEnabled = true
        emojiScroller.scrollEnabled = true
        emojiScroller.backgroundColor = UIColor.clearColor()
        view.bringSubviewToFront(prvsButton)
        view.bringSubviewToFront(nxtButton)
        emojiArtwork = EmojiDataLoader().loadEmojiArtwork()
        emojiCategory = EmojiDataLoader().emojiRetrieve(0)
        
        var cgCount : CGFloat = 0
        var cgUnitWidth : CGFloat = (emojiScroller.frame.size.width - 60) / 3.0
        
        buttOrigin = 30;
        println("buttonOrigin: \(emojiScroller.frame.size.width)")
        for var x = 0; x < emojiCategory.count; x++ {
            var emojiCatSelector : UIButton! = UIButton()
            println("buttName: \(Array(emojiCategory.keys)[x])")
            
            cgCount++
            
             emojiCatSelector.tag = x
            emojiCatSelector.frame = CGRectMake(CGFloat(buttOrigin) + (cgUnitWidth - 60) / 2, 15, 60, 50)
            emojiCatSelector.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
            emojiCatSelector.backgroundColor = UIColor.clearColor()
            emojiCatSelector.addTarget(self, action: Selector("emojiCategoryButtonSelected:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            buttOrigin += cgUnitWidth
            if cgCount % 3 == 0 {
                buttOrigin += 60
            }
            
            emojiCatSelector.layer.cornerRadius = 8.0
            emojiCatSelector.layer.masksToBounds = true
            var categories = EmojiDataLoader().getArtworkCategories()

            var image = UIImage(named: String(format: "articon-0\(x+1)-%@", categories[x]))
            if x == 0 {
                image = UIImage(named: String(format: "articon-0\(x+1)-%@-SEL", categories[x]))
                prevCatBtn = emojiCatSelector
            }
            emojiCatSelector.setImage(image, forState: UIControlState.Normal)

            emojiScroller.addSubview(emojiCatSelector!)
        }
        
        var pageCount : CGFloat = 0
        pageCount = (CGFloat)(emojiCategory.count / 3) + ((emojiCategory.count % 3 > 0 ? 1 : 0))
        emojiScroller.contentSize = CGSizeMake(emojiScroller.frame.size.width * pageCount, emojiScroller.frame.size.height)
        emojiEditRect = emojiArtEditV.frame

        changeCategory()
        
    }
    
    func emojiCategoryButtonSelected(sender: UIButton!) {
        println("sender: \(sender.tag)")
        
        if sender.tag > 2 {
            
            // show updating notification
            var updateProButton = UIAlertAction(title: "Get It❤", style: UIAlertActionStyle.Default, handler: { (ACTION :UIAlertAction!)in
                self.updateProNow()
            })
            updateProButton.enabled = true
            var UpdateProAlert = UIAlertController(title: "Want more Emojis?",
                message: "Get the PRO version!",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            UpdateProAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            UpdateProAlert.addAction(updateProButton)
            presentViewController(UpdateProAlert, animated: true, completion: nil)
            return
        }

        var categories = EmojiDataLoader().getArtworkCategories()
        selectedEmojiCategory = categories[sender.tag]
        
        var image = UIImage(named: String(format: "articon-0\(prevCatBtn.tag+1)-%@", categories[prevCatBtn.tag]))
        prevCatBtn.setImage(image, forState: UIControlState.Normal)
        
        var imageSel = UIImage(named: String(format: "articon-0\(sender.tag+1)-%@-SEL", selectedEmojiCategory))
        sender.setImage(imageSel, forState: UIControlState.Normal)
        
        prevCatBtn = sender

        changeCategory()
    }
    
    func updateProNow() {
        let url = NSURL(string : "itms-apps://itunes.apple.com/app/id953422418")
        if url != nil {
            UIApplication.sharedApplication().openURL(url!)
        }
    }

    func changeCategory() {
        let emojiArray = emojiArtwork[selectedEmojiCategory] as [String]!
        
        var artScrollW : CGFloat = artScrollView.frame.size.width
        var artScrollH : CGFloat = artScrollView.frame.size.height
        
        // remove all subviews...
        let subViews = artScrollView.subviews
        for subview in subViews {
            subview.removeFromSuperview()
        }
        
        artScrollView.pagingEnabled = false
        
        
        var curY : CGFloat = 30
        if emojiArray.count > 0 {
            for var indexOfEmoji = 0; indexOfEmoji < emojiArray.count; indexOfEmoji++ {
                let textEmoji = emojiArray[indexOfEmoji]
                var emojiArtCustomLabel : UILabel! = UILabel()
                var emojiArtRectButton : UIButton! = UIButton()
                var emojiArtRectBack : UIView! = UIView()
                var image : UIImage!
                
                emojiArtCustomLabel.tag = indexOfEmoji + 1
                emojiArtCustomLabel.backgroundColor = UIColor.clearColor()
                emojiArtCustomLabel.numberOfLines = 0
                emojiArtCustomLabel.font = UIFont.systemFontOfSize(16.0)
                
                var fitSize = textEmoji.boundingRectWithSize(CGSize(width: 1000, height: 100000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16.0)], context: nil).size
                if fitSize.width > artScrollW - 60 {
                    fitSize = CGSizeMake(artScrollW - 60, fitSize.height)
                }
                emojiArtCustomLabel.frame = CGRectMake((artScrollW - fitSize.width) / 2 + CGFloat((indexOfEmoji % 2 == 0) ? 10.0 : -10.0), curY, fitSize.width, fitSize.height )
                emojiArtCustomLabel.text = textEmoji
                
                
                emojiArtRectButton.frame = CGRectMake(
                    //emojiArtCustomLabel.frame.origin.x
                    (indexOfEmoji % 2 == 0) ? 30 : 10,
                    emojiArtCustomLabel.frame.origin.y - 10,
                    /*emojiArtCustomLabel.frame.size.width*/
                    artScrollView.frame.size.width - 40,
                    emojiArtCustomLabel.frame.size.height + 20)
                emojiArtRectButton.tag = indexOfEmoji
                emojiArtRectButton.backgroundColor = UIColor.clearColor()
                
                image = UIImage(named: (indexOfEmoji % 2 == 0) ? "msg_greenback.png" : "msg_grayback.png")
                image = image.stretchableImageWithLeftCapWidth((indexOfEmoji % 2 == 0) ? 17 : 24, topCapHeight:14)
                emojiArtRectButton.setBackgroundImage(image, forState: UIControlState.Normal)

                emojiArtRectButton.addTarget(self, action: Selector("emojiAreworkTouchUp:"), forControlEvents: UIControlEvents.TouchUpInside)

                artScrollView.addSubview(emojiArtRectButton)
                artScrollView.addSubview(emojiArtCustomLabel)

                curY += fitSize.height + 30
            }
            
            artScrollView.contentSize = CGSizeMake(artScrollW, curY)
            
        }
        
        
    }
    
    func emojiAreworkTouchUp(sender: UIButton!) {
        // sharing Artwork
        selectedEmojiTag = sender.tag
        shareThisEmojiArt()
    }
    
    func shareThisEmojiArt(){
        let emojiArt = emojiArtwork[selectedEmojiCategory]![selectedEmojiTag]
        var emojiEditActivity = EmojiEditActivity()
        emojiEditActivity.emojiartViewController = self
        let shareList : UIActivityViewController = UIActivityViewController(activityItems: [emojiArt], applicationActivities: [emojiEditActivity])

        shareList.excludedActivityTypes = [
            // categoryShare
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo,
            UIActivityTypePostToWeibo,
            // categoryAction
            UIActivityTypePrint,
            UIActivityTypeAssignToContact,
            UIActivityTypeAddToReadingList
        ]
        
        presentViewController(shareList, animated: true, completion: {
            println("Success ActivitySheet Presentation")
        })
    }
    
    func showEmojiArtEdit() {
        let emojiArt = emojiArtwork[selectedEmojiCategory]![selectedEmojiTag]
        isEditting = true
        isChanged = false
        emojiArtHeader.image = UIImage(named: "emoji_art_header")
        var textview : UITextView! = UITextView()
        emojiArtEditV.text = emojiArt
        emojiArtEditV.hidden = false
        artScrollView.hidden = true
        categoryView.userInteractionEnabled = false
        saveButton.enabled = true
    }

    func closeEmojiArtEdit() {
        isEditting = false
        emojiArtHeader.image = UIImage(named: "emoji_art_bg_default")
        emojiArtEditV.hidden = true
        artScrollView.hidden = false
        categoryView.userInteractionEnabled = true
        saveButton.enabled = false
    }
    
    func keyboardWasShown(notification :NSNotification)
    {
        // Get the size of the keyboard.
        if let userInfo = notification.userInfo {
            let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()
            let rect = UIScreen.mainScreen().bounds
//            emojiArtEditV.frame = CGRectMake(emojiEditRect.origin.x, emojiEditRect.origin.y, emojiEditRect.width, rect.height - keyboardSize.height - emojiEditRect.origin.y - 10)
            emojiArtEditV.frame = CGRectMake(emojiEditRect.origin.x, emojiEditRect.origin.y, emojiEditRect.width, 164)
        }
    }

    func textViewShouldBeginEditing(textView: UITextView!) -> Bool {
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("keyboardWasShown:"), name:UIKeyboardDidShowNotification, object: nil)
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView!) -> Bool {
        dismissKeyboard()
        emojiArtEditV.frame = emojiEditRect
        return true
    }
    
    func dismissKeyboard() {
        emojiArtEditV.resignFirstResponder()
    }
    
    // TODO: textView
    func textView(textView: UITextView!, shouldChangeTextInRange range: NSRange, replacementText text: String!) -> Bool {

        isChanged = true
        /*
        if countElements(selectedEmojiDictionary) > 0 {
            if text.isEmpty == false {
                var foundString : Character = Character(text)
                
                println("foundString: \(foundString)")
                println("range: \(range)")
                
                switch foundString {
                case "a", "A":
                    foundString = Character(selectedEmojiDictionary["a"]!)
                    
                case "b", "B":
                    foundString = Character(selectedEmojiDictionary["b"]!)
                    
                case "c", "C":
                    foundString = Character(selectedEmojiDictionary["c"]!)
                    
                case "d", "D":
                    foundString = Character(selectedEmojiDictionary["d"]!)
                    
                case "e", "E":
                    foundString = Character(selectedEmojiDictionary["e"]!)
                    
                case "f", "F":
                    foundString = Character(selectedEmojiDictionary["f"]!)
                    
                case "g", "G":
                    foundString = Character(selectedEmojiDictionary["g"]!)
                    
                case "h", "H":
                    foundString = Character(selectedEmojiDictionary["h"]!)
                    
                case "i", "I":
                    foundString = Character(selectedEmojiDictionary["i"]!)
                    
                case "j", "J":
                    foundString = Character(selectedEmojiDictionary["j"]!)
                    
                case "k", "K":
                    foundString = Character(selectedEmojiDictionary["k"]!)
                    
                case "l", "L":
                    foundString = Character(selectedEmojiDictionary["l"]!)
                    
                case "m", "M":
                    foundString = Character(selectedEmojiDictionary["m"]!)
                    
                case "n", "N":
                    foundString = Character(selectedEmojiDictionary["n"]!)
                    
                case "o", "O":
                    foundString = Character(selectedEmojiDictionary["o"]!)
                    
                case "p", "P":
                    foundString = Character(selectedEmojiDictionary["p"]!)
                    
                case "q", "Q":
                    foundString = Character(selectedEmojiDictionary["q"]!)
                    
                case "r", "R":
                    foundString = Character(selectedEmojiDictionary["r"]!)
                    
                case "s", "S":
                    foundString = Character(selectedEmojiDictionary["s"]!)
                    
                case "t", "T":
                    foundString = Character(selectedEmojiDictionary["t"]!)
                    
                case "u", "U":
                    foundString = Character(selectedEmojiDictionary["u"]!)
                    
                case "v", "V":
                    foundString = Character(selectedEmojiDictionary["v"]!)
                    
                case "w", "W":
                    foundString = Character(selectedEmojiDictionary["x"]!)
                    
                case "x", "X":
                    foundString = Character(selectedEmojiDictionary["x"]!)
                    
                case "y", "Y":
                    foundString = Character(selectedEmojiDictionary["y"]!)
                    
                case "z", "Z":
                    foundString = Character(selectedEmojiDictionary["z"]!)
                    
                default:
                    println("default")
                    
                    return true
                }
                
                println("converted String: \(foundString)")
                let original = emojiArtEditV.text as NSString
                let replace = String(foundString) as NSString
                let changed = original.stringByReplacingCharactersInRange(range, withString: replace)
                emojiArtEditV.text = changed
                let position = NSMakeRange(range.location + replace.length, 0)
                println("position: \(position)")
                emojiArtEditV.selectedRange = position
                
                return false
            }
        }
*/
        return true
    }
    
    // MARK: TextField Config
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        emojiFileNameAlert.dismissViewControllerAnimated(true, completion: nil)
        return true
    }
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        if string.isEmpty == false {
            saveActionAlertButton.enabled = true
        }else{
            saveActionAlertButton.enabled = false
        }
        return true
    }
    
}