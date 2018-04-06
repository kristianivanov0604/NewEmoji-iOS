//
//  StaticViewController.swift
//  EmojiAppSwiftify
//
//  Created by Guy Van Looveren on 7/23/14.
//  Copyright (c) 2014 Pro Sellers World. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import Social

class StaticViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate{
    
    @IBAction func emojiScrollerNxtPage(sender: UIButton) {
        if sender.tag == 0 {
            var prvsOffset : Int! = Int(emojiScroller.contentOffset.x - emojiScroller.frame.size.width)
            
            println("fr: \(emojiScroller.frame)")
            println("sOff: \(emojiScroller.contentOffset)")
            println("o: \(prvsOffset)")
            println("w: \(emojiScroller.contentSize)")
            
            if prvsOffset < 0 {
                prvsOffset = 0
            }
            
            emojiScroller.setContentOffset(CGPointMake(CGFloat(prvsOffset), 0), animated: true)
        }else{
            var nxtOffset : Int! = Int(emojiScroller.contentOffset.x)
            
            println("fr: \(emojiScroller.frame)")
            println("sOff: \(emojiScroller.contentOffset)")
            println("o: \(nxtOffset)")
            println("w: \(emojiScroller.contentSize)")
            
            
            if nxtOffset < Int(emojiScroller.contentSize.width - emojiScroller.frame.size.width){
                nxtOffset = Int(emojiScroller.contentOffset.x + emojiScroller.frame.size.width)
            }
            
            emojiScroller.setContentOffset(CGPointMake(CGFloat(nxtOffset), 0), animated: true)
        }
    }

    
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var mainHeader: UIImageView!
    @IBOutlet weak var mainBackground: UIImageView!
    @IBOutlet weak var prvsButton: UIButton!
    @IBOutlet weak var nxtButton: UIButton!
    @IBOutlet weak var scrlBGImageView: UIImageView!
    @IBOutlet weak var scrollPager: UIPageControl!
    @IBOutlet weak var emojiScroller: UIScrollView!
    @IBOutlet weak var emojiScrollerNxtPage: UIButton!
    @IBOutlet var staticCollectionView : UICollectionView?
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var icon_imageView: UIImageView!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var bg_view: UIImageView!
    var staticImageView : [String]?
    var emojiCategory = Dictionary<String, [String]!>()
    var selectedEmoji : String?, selectedEmojiCategory : String!, isAnimated : Bool!
    var selectedTag : Int?
    var dividerWDC = Float(), pageWDC = CGFloat()
    var buttOrigin : CGFloat = 0
    var prevCatBtn :UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let itemsInOneRow : Int! = self.view.frame.size.height == 480 ? 2 : 3
        var flowLayout : CustomFlowLayout = CustomFlowLayout(itemsInOneRow: itemsInOneRow)
        
        staticCollectionView?.setCollectionViewLayout(flowLayout, animated: false)
        staticCollectionView?.pagingEnabled
        
        
        
        emojiScroller.pagingEnabled = true
        emojiScroller.scrollEnabled = true
        emojiScroller.backgroundColor = UIColor.clearColor()
        view.bringSubviewToFront(prvsButton)
        view.bringSubviewToFront(nxtButton)
        
        staticImageView = ["1", "2", "3", "5", "7", "9", "10", "1", "2", "3", "5", "7", "9", "10", "1", "2", "3", "5", "7", "9", "10", "1", "2", "3", "5", "7", "9", "10"]
        
        if selectedTag == 0 { //always return true for testing all mainCategoryButton
            isAnimated = false
            mainBackground.image = UIImage(named: "static_emotion_bg")
            icon_imageView.image = UIImage(named: "0_icon")
            bg_view.image = UIImage(named: "0_bg")
            backButton.setImage(UIImage(named: "0_backButton"), forState: .Normal)
            navTitle.text = "STATIC"


            emojiCategory = EmojiDataLoader().emojiRetrieve(selectedTag!)
            selectedEmojiCategory = Array(emojiCategory.keys)[0]

        }else if selectedTag == 1 {
            isAnimated = true
            mainBackground.image = UIImage(named: "animeted_emoticons_bg")
            icon_imageView.image = UIImage(named: "1_icon")
            bg_view.image = UIImage(named: "1_bg")
            backButton.setImage(UIImage(named: "1_backbutton"), forState: .Normal)
            navTitle.text = "ANIMATIONS"

            emojiCategory = EmojiDataLoader().emojiRetrieve(selectedTag!)
            selectedEmojiCategory = Array(emojiCategory.keys)[0]
        }
        
        println(Array(emojiCategory.keys))
        
        var cgCount : CGFloat = 1

        for var x = 0; x < emojiCategory.count; x++ {
            var emojiCatSelector : UIButton! = UIButton()
            println("buttName: \(Array(emojiCategory.keys)[x])")
            
            if x > 0{
                if (cgCount % 3) == 1 {
                    buttOrigin += (50  + 70)
                }else{
                    buttOrigin += (50  + 30)
                }
                //                    buttOrigin = ((70 * x) + 20)
            }else{
                buttOrigin = 35
            }
            
            println(buttOrigin)
            
            cgCount++
            
            //sample
            
            
            
            emojiCatSelector.frame = CGRectMake(CGFloat(buttOrigin)-5, 15, 60, 50)
            emojiCatSelector.addTarget(self, action: Selector("emojiCategoryButtonSelected:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            //Edit: Nov 24
            //Adjusted the image category to its respective sites.
            //Code was based on selected category type at index 0 to always pick the first item for the selected category as the main icon for the emojiSelector ScrollView
            emojiCatSelector.layer.cornerRadius = 8.0
            emojiCatSelector.layer.masksToBounds = true
            
            if selectedTag == 0 {
                let tempStringCategory = Array(emojiCategory.keys)[x]
                if x > 0 {
                    emojiCatSelector.setImage(UIImage(named: emojiCategory[tempStringCategory]![0]), forState: UIControlState.Normal)
                } else {                    
                    emojiCatSelector.setImage(UIImage(named: String(format: "%@-sel", emojiCategory[tempStringCategory]![0])), forState: UIControlState.Normal)
                    prevCatBtn = emojiCatSelector
                }
            }else{
                let tempStringCategory = Array(emojiCategory.keys)[x]
                if x > 0 {
                    emojiCatSelector.setImage(UIImage.animatedImageWithAnimatedGIFData(NSData.dataWithContentsOfMappedFile((format: emojiCategory[tempStringCategory]![0])) as NSData), forState: UIControlState.Normal)
                } else {
                    emojiCatSelector.setImage(UIImage(named: tempStringCategory), forState: UIControlState.Normal)
                    prevCatBtn = emojiCatSelector
                }
            }
            emojiCatSelector.backgroundColor = UIColor.clearColor()
            emojiCatSelector.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
            emojiCatSelector.tag = x
            
            println("b: \(emojiCatSelector)")
            
            emojiScroller.addSubview(emojiCatSelector!)
        }
        
        //Edit: Nov 24
        //buttOrigin was the one to make adjustment based on this kind of code. Next time please provide a proper formula that doesn't add Constant Values. What if the clien ask us to add new buttons? then this workaround below won't work anymore.
        
        //INFO : add another 70pts to buttOrigin to create a blank space for the UIScrollView : emojiScroller to function well. emojiScroller uses pagingEnabled: function to create page like effect when scrolling through it
        
        if selectedTag == 0 {
            buttOrigin += (50  + 30)
        }else{
            buttOrigin += (50  + 30) * 2
        }
        
        
        println("contentSize: \(emojiScroller.contentSize)")
    }
    
    override func viewDidLayoutSubviews() {
        emojiScroller.contentSize = CGSizeMake(buttOrigin + 85, emojiScroller.frame.size.height)
        
        println("collectionSize vDS: \(staticCollectionView!.contentSize)")
        
        //**********
        println(UIDevice.currentDevice().model)
            println("collectionSize wDC: \(staticCollectionView!.contentSize)")
            dividerWDC = Float(CGRectGetWidth(self.staticCollectionView!.frame)) //6
            
            pageWDC = CGFloat(Float((staticCollectionView!.contentSize as CGSize).width) / Float(dividerWDC))
            scrollPager.numberOfPages = Int(ceil(pageWDC))
        
        
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

        selectedEmojiCategory = Array(emojiCategory.keys)[sender.tag]
        if (isAnimated == true) {
            //animated icon highlighting
            let prevCategory = Array(emojiCategory.keys)[prevCatBtn.tag]
            prevCatBtn.setImage(UIImage.animatedImageWithAnimatedGIFData(NSData.dataWithContentsOfMappedFile((format: emojiCategory[prevCategory]![0])) as NSData), forState: UIControlState.Normal)
            sender.setImage(UIImage(named: selectedEmojiCategory), forState: UIControlState.Normal)

        } else {
            //static icon highlighting
            let prevCategory = Array(emojiCategory.keys)[prevCatBtn.tag]
            prevCatBtn.setImage(UIImage(named: emojiCategory[prevCategory]![0]), forState: UIControlState.Normal)
            sender.setImage(UIImage(named: String(format: "%@-sel", emojiCategory[selectedEmojiCategory]![0])), forState: UIControlState.Normal)
        }
        prevCatBtn = sender

        staticCollectionView?.reloadData()
    }
    
    func updateProNow() {
        let url = NSURL(string : "itms-apps://itunes.apple.com/app/id953422418")
        if url != nil {
            UIApplication.sharedApplication().openURL(url!)
        }
    }

    
    func collectionView(collectionView: UICollectionView!, willDisplayCell cell: UICollectionViewCell!, forItemAtIndexPath indexPath: NSIndexPath!) {
//        println(loadNewEmojiSet)
//        if loadNewEmojiSet == true {
//                if indexPath == collectionView.indexPathsForVisibleItems().endIndex {
//                    loadNewEmojiSet = false
                    println("collectionSize  wDC: \(staticCollectionView!.contentSize)")
                    dividerWDC = Float(CGRectGetWidth(self.staticCollectionView!.frame)) //9
                    
                    pageWDC = CGFloat(Float((staticCollectionView!.contentSize as CGSize).width) / Float(dividerWDC))
                    scrollPager.numberOfPages = Int(ceil(pageWDC))
//                }
            
//        }
        //println("Number of Page: \(ceil(page))")
        //println("Number of Elements: \(countElements(emojiCategory[selectedEmojiCategory]!!))")
        //println("Divider: \(divider) Page: \(page) Number: \(Int(ceil(page)))")
        
        //println("content: \(staticCollectionView!.contentSize)")
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        println(emojiCategory[selectedEmojiCategory]!!)
        return countElements(emojiCategory[selectedEmojiCategory]!!)

    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier : String = "Cell"
        var cell : StaticCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as StaticCollectionViewCell
        
        var cellImage : UIImage!
        
        if isAnimated == true {
            cellImage = UIImage.animatedImageWithAnimatedGIFData(NSData.dataWithContentsOfMappedFile((format: emojiCategory[selectedEmojiCategory]![indexPath.row])) as NSData)
        }else{
            cellImage = UIImage(named: emojiCategory[selectedEmojiCategory]![indexPath.row])
        }
        
        println("ssssSS: \(cellImage.size)")
        println("ssssSSFr: \(cell.emoticonImageView?.frame)")
        
        cell.emoticonImageView!.image = cellImage
        cell.backgroundColor = UIColor.whiteColor()
        cell.emoticonImageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        var scaledRadius : CGFloat!
        if cellImage.size.width > cellImage.size.height {
            scaledRadius = cell.emoticonImageView!.frame.size.width * 0.2		
        }else{
            scaledRadius = cell.emoticonImageView!.frame.size.height * 0.2
        }
        
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor(red: 77/255, green: 208/255, blue: 185/255, alpha: 1.0).CGColor
        
        cell.layer.cornerRadius = scaledRadius
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var emojiImageShare : AnyObject! //switch to any object to handle dynamic data.
        if isAnimated == true {
            selectedEmoji = emojiCategory[selectedEmojiCategory]![indexPath.row]
            emojiImageShare = NSData.dataWithContentsOfMappedFile(selectedEmoji!) as NSData //UIImage.animatedImageWithAnimatedGIFData(NSData.dataWithContentsOfMappedFile((format: emojiCategory[selectedEmojiCategory]![indexPath.row])) as NSData)
        }else{
            selectedEmoji = emojiCategory[selectedEmojiCategory]![indexPath.row]
            emojiImageShare = UIImage(named: selectedEmoji!)
        }
        
        println("\n\n          selectedEmoji: \(selectedEmoji) \n\n")
        
        self.shareThisImage(emojiImageShare)
        
    }
    
    func shareThisImage(emoji : AnyObject){
        let Items :NSArray = [emoji]
        let shareList : UIActivityViewController = UIActivityViewController(activityItems: Items, applicationActivities: nil)
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
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        var cOffset : CGFloat!, witdh : CGFloat!
        cOffset = staticCollectionView?.contentOffset.x
        witdh = staticCollectionView?.frame.size.width
        
        //println("Current Offset x: \(staticCollectionView?.contentOffset.x)")
        //println("Raw: \(cOffset / witdh)")
        //println("Width: \(witdh)")
        //println("Current Page: \(ceil(CGFloat(cOffset) / CGFloat(witdh)))")
        
        scrollPager.currentPage = Int(ceil(CGFloat(cOffset) / CGFloat(witdh)))
    }
    
    /*
    func collectionView(collectionView: UICollectionView!, willDisplaySupplementaryView view: UICollectionReusableView!, forElementKind elementKind: String!, atIndexPath indexPath: NSIndexPath!) {
        println(UICollectionReusableView)
    }*/
    
    @IBAction func backButtonTapped(sender : UIButton){
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == 1 {   // Send To contact
            
            if MFMessageComposeViewController.canSendText(){
                
                var messageComposer : MFMessageComposeViewController = MFMessageComposeViewController()
                var pngData : NSData = UIImagePNGRepresentation(UIImage(named: selectedEmoji!))
                var fileName : String = selectedEmoji! + ".png"
                messageComposer.messageComposeDelegate = self;
                messageComposer.addAttachmentData(pngData, typeIdentifier:"public.data", filename:fileName)
                self.presentViewController(messageComposer, animated: true, completion: nil)
                
            }
            
        }else if buttonIndex == 2 { // Send To Email
            
            if MFMailComposeViewController.canSendMail(){
                var emailComposer : MFMailComposeViewController = MFMailComposeViewController()
                emailComposer.mailComposeDelegate = self
                /*
                var pngData : NSData = UIImagePNGRepresentation(UIImage(named: selectedEmoji))
                var fileName : String = selectedEmoji! + ".png"
                println("\n\n       img: \(selectedEmoji) \n\n")
                println("       fileName: \(fileName) \n\n")
                emailComposer.addAttachmentData(pngData, mimeType: "image/png", fileName: fileName)
                self.presentViewController(emailComposer, animated: true, completion: nil)
                */
                
                var imgData : NSData!
                var fileName : String!
                
                //--- gif
                if isAnimated == true {
                imgData = NSData.dataWithContentsOfMappedFile(selectedEmoji!) as NSData
                
                }else{
                fileName = selectedEmoji! + ".png"
                }
                //---
                
                println("\n\n       img: \(selectedEmoji) \n\n")
                println("       fileName: \(fileName) \n\n")

                
                emailComposer.addAttachmentData(imgData, mimeType: "image/png", fileName: fileName)
                self.presentViewController(emailComposer, animated: true, completion: nil)

                
            }
            
        }else if buttonIndex == 3 { // Copy to Clipboard
            var pasteBoard : UIPasteboard = UIPasteboard.generalPasteboard()
            var copiedImage : UIImage = UIImage(named: selectedEmoji!)!
            pasteBoard.image = copiedImage
        }
    }
    
    
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion:{
                println(MFMailComposeResult)
            })
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion:{
                println(MessageComposeResult)
            
            })
    }
    
}