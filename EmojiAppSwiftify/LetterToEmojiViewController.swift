//
//  LetterToEmojiViewController.swift
//  EmojiAppSwiftify
//
//  Created by Guy Van Looveren on 7/24/14.
//  Copyright (c) 2014 Pro Sellers World. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import CoreData

class LetterToEmojiViewController : UIViewController, UITextViewDelegate, UITextFieldDelegate{
    
    @IBAction func unWindFromSelectionView(sender: UIStoryboardSegue){
        
        let sourceV : EmojiLetterTypeSelection = sender.sourceViewController as EmojiLetterTypeSelection
        selectedEmojiDictionary = sourceV.selectedEmojiDictionary
        defaultEmojiTxt.text = sourceV.selectedEmojiTitleString
        
        println(sourceV.selectedEmojiTitleString)
    }
    
    @IBAction func letterEmojiTypeSelectorButton(sender: UIButton) {
        tvDismiss()
        performSegueWithIdentifier("toLetterTypeSelection", sender: nil)
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    var saveActionAlertButton : UIAlertAction!
    var emojiFileNameAlert : UIAlertController!
    @IBAction func subHeaderButton(sender: UIButton) {

        if emojiTextView.text == "" {
            return
        }
        
        let emojiArt = emojiTextView.text
        let shareList : UIActivityViewController = UIActivityViewController(activityItems: [emojiArt], applicationActivities: nil)
        
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

//        saveActionAlertButton = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: fileNameEntered)
//        saveActionAlertButton.enabled = false
//        
//        emojiFileNameAlert = UIAlertController(title: "Emoji Filename", message: "Please input your desired filename. If filename is inuse, datafile will be overwritten.", preferredStyle: UIAlertControllerStyle.Alert)
//        emojiFileNameAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
//        emojiFileNameAlert.addAction(saveActionAlertButton)
//        emojiFileNameAlert.addTextFieldWithConfigurationHandler({(filenameTextField : UITextField!) in
//            filenameTextField.placeholder = "Filename"
//            filenameTextField.delegate = self
//            filenameTextField.keyboardType = UIKeyboardType.Default
//            filenameTextField.keyboardAppearance = UIKeyboardAppearance.Dark
//            
//            self.filenameTextField = filenameTextField
//            })
//        
//        presentViewController(emojiFileNameAlert, animated: true, completion: nil)
//
//        theApp.saveContext()
    }
    
    var filenameTextField : UITextField!
    var fResult = NSArray()
    
    // MARK: fileNameEntered
    func fileNameEntered(alert: UIAlertAction!){
        println(alert)
        println(filenameTextField.text)
        
        if emojiTextView.text.utf16Count == 0 {
            var saveAlert = UIAlertController(title: "Warning", message: "Please create your emoji first and try again.", preferredStyle: UIAlertControllerStyle.Alert)
            saveAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
            return presentViewController(saveAlert, animated: true, completion: nil)
        }
        
        var fRequest = NSFetchRequest(entityName: "EmojiSaveArt")
        fRequest.predicate = NSPredicate(format: "fileName = %@", (filenameTextField.text as String))
        fResult = theApp.managedObjectContext!.executeFetchRequest(fRequest, error: nil)!
        
        
        if fResult.count > 0 {
            var saveArtResult = fResult[0] as NSManagedObject
            saveArtResult.setValue(filenameTextField.text as String, forKey: "fileName")
            saveArtResult.setValue((emojiTextView.text as String), forKey: "saveArt")
            println("\n\n Saved ------ \n\n \(saveArtResult) \n\n and Replaced ------ \n\n \(fResult) \n\n")
        }else{
            var saveArtEntity = NSEntityDescription.insertNewObjectForEntityForName("EmojiSaveArt", inManagedObjectContext: theApp.managedObjectContext!) as NSManagedObject
            saveArtEntity.setValue(filenameTextField.text as String, forKey: "fileName")
            saveArtEntity.setValue((emojiTextView.text as String), forKey: "saveArt")
            println("\n\n Save ------ \n\n \(saveArtEntity) \n\n")
        }
        
        theApp.saveContext()
        
        println("Saved Emoji with Filename")
    }
    
    var theApp : AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    @IBOutlet weak var defaultEmojiTxt: UITextField!
    @IBOutlet weak var letterEmojiTypeSelectorButton: UIButton!
    @IBOutlet weak var emojiTextView: UITextView!
    var selectedEmojiDictionary = Dictionary<String, String>()
    
    
    override func viewDidLoad() {
        emojiTextView.text = nil
        emojiTextView.layer.cornerRadius = 4.0
        
        
        let def = (NSUserDefaults.standardUserDefaults().arrayForKey("defaultEmojiLetter"))
        println(def)
        if selectedEmojiDictionary.isEmpty == true {
            if (def == nil) {
                /*
                let emojiDefault = ["a" : "\u{0001F433}", "b" : "\u{0001F44D}", "c" : "\u{0001F349}", "d" : "\u{0001F37A}", "e" : "\u{0001F365}", "f" : "\u{0001F38F}", "g" : "\u{000270A}", "h" : "\u{0001F64C}", "i" : "\u{0001F488}", "j" : "\u{0001F3B7}", "k" : "\u{0001F38B}", "l" : "\u{0001F4AA}", "m" : "\u{303D}", "n" : "\u{0001F6A7}", "o" : "\u{2B55}", "p" : "\u{0001F6A9}", "q" : "\u{0001F388}", "r" : "\u{0001F331}", "s" : "\u{0001F4B0}", "t" : "\u{0001F344}", "u" : "\u{0001F445}", "v" : "\u{270C}", "w" : "\u{0001F450}", "x" : "\u{274C}", "y" : "\u{0001F337}", "z" : "\u{0001F4A4}"]
                
                var stringTitle = String()
                for oneStringEmo in emojiDefault{
                    stringTitle += String(oneStringEmo.1)
                }
                
                defaultEmojiTxt = stringTitle
                selectedEmojiDictionary = emojiDefault
                */
                
                defaultEmojiTxt.text = EmojiDataLoader().getLeterTypeSetArray(0)[0]
                println(EmojiDataLoader().getLeterTypeSetArray(0)[0])
                println(EmojiDataLoader().getLeterTypeSetDictionary(2))
                selectedEmojiDictionary = EmojiDataLoader().getLeterTypeSetDictionary(2)["EmojiSetOne"]!

                
            }else{
                defaultEmojiTxt.text = def![0] as? String
                selectedEmojiDictionary = def![1] as Dictionary
            }
        }
        
        
        var toolbar = UIToolbar()
        [UIBarButtonItem.alloc]
        toolbar.barStyle = UIBarStyle.BlackTranslucent
//        toolbar.setItems([UIImage.barWithFlex(), UIImage.barDoneWithTitle("Done", sTarGet: self, sAction: "tvDismiss")], animated: true) // ObjC -> Swift
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil), UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("tvDismiss"))]
        toolbar.sizeToFit()
        
        emojiTextView.inputAccessoryView = toolbar
    }
    
    func tvDismiss(){
        emojiTextView.resignFirstResponder()
/*
        NSUserDefaults.standardUserDefaults().setValue(emojiTextView.text as String, forKeyPath: "savedEmojiLetter")
        NSUserDefaults.standardUserDefaults().synchronize()
        println(NSUserDefaults.standardUserDefaults().objectForKey("savedEmojiLetter"))
*/
    }

    func textView(textView: UITextView!, shouldChangeTextInRange range: NSRange, replacementText text: String!) -> Bool {

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
            println("textString: \(textView.text.stringByReplacingCharactersInRange(Range<String.Index>(start: textView.text.startIndex, end: textView.text.endIndex), withString: String(foundString)))")
            
            emojiTextView.text = (textView.text.stringByReplacingCharactersInRange(Range<String.Index>(start: textView.text.endIndex, end: textView.text.endIndex), withString: String(foundString)))
            
            return false
        }
        
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView!) -> Bool {
        return true
    }
    
    // MARK -- TextField
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