//
//  EmojiDataLoader.swift
//  EmojiAppSwiftify
//
//  Created by Guy Van Looveren on 7/28/14.
//  Copyright (c) 2014 Pro Sellers World. All rights reserved.
//

import Foundation
import CoreData

var emojiCategory = Dictionary<String, [String]!>(), emojiCategoryTwo = Dictionary<String, [String]!>()
var emojiSelector = [Dictionary<String, [String]!>]()
var emojiArrayKey : [String]!, emojiStringSetArray = [String]()
var emojiDictionary = Dictionary<String, Dictionary<String, String>>()
var artworkCategories = ["LOVE", "FUN", "MOOD", "ANIMALS", "OTHERS"]

var theApp : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate

class EmojiDataLoader {
    
    // MARK: Load All Emoji Data
    func emojiLoadAllData() {
        loadEmojiImageData()
        loadLetterTypeData()
        gifDirectoryFinder()
    }
    
    // MARK: Image Data
    func loadEmojiImageData() {
        
        println("Loading Emojis")
        //        if selectedTag == 0 { //always return true for testing all mainCategoryButton
        
        var emojiIconForRetinaMad = [String](), emojiIconForRetinaLoving = [String](), emojiIconForRetinaNoCategory = [String](), emojiIconForRetinaUnHappy = [String](), emojiIconForRetinaVeryHappy = [String]()
        
        for var index = 1; index <= 42; ++index {
            if index < 10{
                emojiIconForRetinaLoving.append(NSString(format: "retina_Loving-00\(index)"))
            }else{
                emojiIconForRetinaLoving.append(String(format: "retina_Loving-0\(index)"))
            }
        }
        
        emojiCategory["Retina Loving"] = emojiIconForRetinaLoving
        
        for var index = 1; index <= 41; index++ {
            if index < 10{
                emojiIconForRetinaMad.append(String(format: "retina_Mad-00\(index)"))
            }else{
                emojiIconForRetinaMad.append(String(format: "retina_Mad-0\(index)"))
            }
        }
        emojiCategory["Retina Mad"] = emojiIconForRetinaMad
        
        for var index = 1; index <= 57; index++ {
            if index < 10 {
                emojiIconForRetinaNoCategory.append(String(format: "retina_no_category-00\(index)"))
            }else{
                emojiIconForRetinaNoCategory.append(String(format: "retina_no_category-0\(index)"))
            }
        }
        emojiCategory["Retina No Category"] = emojiIconForRetinaNoCategory
        
        for var index = 1; index <= 68; index++ {
            if index < 10 {
                emojiIconForRetinaUnHappy.append(String(format: "retina_UnHappy-00\(index)"))
            }else{
                emojiIconForRetinaUnHappy.append(String(format: "retina_UnHappy-0\(index)"))
            }
        }
        emojiCategory["Retina UnHappy"] = emojiIconForRetinaUnHappy
        
        for var index = 1; index <= 104; index++ {
            if index < 10 {
                emojiIconForRetinaVeryHappy.append(String(format: "retina_VeryHappy-00\(index)"))
            }else if index < 100{
                emojiIconForRetinaVeryHappy.append(String(format: "retina_VeryHappy-0\(index)"))
            }else{
                emojiIconForRetinaVeryHappy.append(String(format: "retina_VeryHappy-\(index)"))
            }
        }
        
        emojiCategory["Retina Very Happy"] = emojiIconForRetinaVeryHappy
        
        emojiSelector.append(emojiCategory)
        
    }
    
    func loadEmojiArtwork() -> Dictionary<String, [String]!>{
        
        var emojiArtwork = Dictionary<String, [String]!>()

        for category in artworkCategories {

            let def = NSUserDefaults.standardUserDefaults().arrayForKey(category)
            if (def == nil) {
                let catePath = NSBundle.mainBundle().pathForResource(category, ofType: "plist")
                let cateEmojis = NSArray(contentsOfFile: catePath!)
                let emojiTexts = cateEmojis as [String]
                saveEmojiArework(category, emojiTexts: emojiTexts)
                emojiArtwork[category] = emojiTexts
            } else {
                var emojiTexts :[String] = def! as [String]
                emojiArtwork[category] = emojiTexts
            }

        }
        return emojiArtwork

    }
    
    func saveEmojiArework(category:String, emojiTexts:[String]) {
        NSUserDefaults.standardUserDefaults().setValue(emojiTexts, forKeyPath: category)
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    // get artwork categories
    func getArtworkCategories() -> [String] {
        return artworkCategories
    }


    // get coolapp data array
    func getCoolAppData() -> [Dictionary<String, String>] {

        let coolappData = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("COOLAPPS", ofType: "plist")!)
        let appDataArray = coolappData as [Dictionary<String, String>]
        return appDataArray
    }

    // MARK: Retriever
    /**
    Will return Set Base on Index
    */
    func emojiRetrieve(index: Int) -> Dictionary<String, [String]!>{
//        println("\(emojiSelector.count) \(index)")
        return emojiSelector[index]
    }
    
    // MARK: loadLetterTypeData
    func loadLetterTypeData() {
        
        let emojiOne = ["a" : "\u{0001F433}", "b" : "\u{0001F44D}", "c" : "\u{0001F349}", "d" : "\u{0001F37A}", "e" : "\u{0001F365}", "f" : "\u{0001F38F}", "g" : "\u{000270A}", "h" : "\u{0001F64C}", "i" : "\u{0001F488}", "j" : "\u{0001F3B7}", "k" : "\u{0001F38B}", "l" : "\u{0001F4AA}", "m" : "\u{303D}", "n" : "\u{0001F6A7}", "o" : "\u{2B55}", "p" : "\u{0001F6A9}", "q" : "\u{0001F388}", "r" : "\u{0001F331}", "s" : "\u{0001F4B0}", "t" : "\u{0001F344}", "u" : "\u{0001F445}", "v" : "\u{270C}", "w" : "\u{0001F450}", "x" : "\u{274C}", "y" : "\u{0001F337}", "z" : "\u{0001F4A4}"]
        
        let emojiTwo = ["a" : "\u{0001F40A}", "b" : "\u{0001F517}", "c" : "\u{0001F4DE}", "d" : "\u{0001F31C}", "e" : "\u{0001F4DA}", "f" : "\u{0001F343}", "g" : "\u{0001F35C}", "h" : "\u{0001F3BF}", "i" : "\u{0001F38D}", "j" : "\u{0001F489}", "k" : "\u{0001F4A6}", "l" : "\u{0001F462}", "m" : "\u{0001F380}", "n" : "\u{0001F3AD}", "o" : "\u{26BE}", "p" : "\u{0001F3C1}", "q" : "\u{0001F390}", "r" : "\u{2049}", "s" : "\u{26A1}", "t" : "\u{0001F334}", "u" : "\u{0001F458}", "v" : "\u{0001F355}", "w" : "\u{2693}", "x" : "\u{2702}", "y" : "\u{0001F4D}", "z" : "\u{0001F528}"]
        
        let emojiThree = ["a" : "\u{24D0}", "b" : "\u{24D1}", "c" : "\u{24D2}", "d" : "\u{24D3}", "e" : "\u{24D4}", "f" : "\u{24D5}", "g" : "\u{24D6}", "h" : "\u{24D7}", "i" : "\u{24D8}", "j" : "\u{24D9}", "k" : "\u{24DA}", "l" : "\u{24DB}", "m" : "\u{24DC}", "n" : "\u{24DD}", "o" : "\u{24DE}", "p" : "\u{24DF}", "q" : "\u{24E0}", "r" : "\u{24E1}", "s" : "\u{24E2}", "t" : "\u{24E3}", "u" : "\u{24E4}", "v" : "\u{24E5}", "w" : "\u{24E6}", "x" : "\u{24E7}", "y" : "\u{24E8}", "z" : "\u{24E9}"]
        
        let emojiFour = ["a" : "\u{FF41}", "b" : "\u{FF42}", "c" : "\u{FF43}", "d" : "\u{FF44}", "e" : "\u{FF45}", "f" : "\u{FF46}", "g" : "\u{FF47}", "h" : "\u{FF48}", "i" : "\u{FF49}", "j" : "\u{FF4A}", "k" : "\u{FF4B}", "l" : "\u{FF4C}", "m" : "\u{FF4D}", "n" : "\u{FF4E}", "o" : "\u{FF4F}", "p" : "\u{FF50}", "q" : "\u{FF51}", "r" : "\u{FF52}", "s" : "\u{FF53}", "t" : "\u{FF54}", "u" : "\u{FF55}", "v" : "\u{FF56}", "w" : "\u{FF57}", "x" : "\u{FF58}", "y" : "\u{FF59}", "z" : "\u{FF5A}"]
        
        let emojiFive = ["a" : "\u{FF21}", "b" : "\u{FF22}", "c" : "\u{FF23}", "d" : "\u{FF24}", "e" : "\u{FF25}", "f" : "\u{FF26}", "g" : "\u{FF27}", "h" : "\u{FF28}", "i" : "\u{FF29}", "j" : "\u{FF2A}", "k" : "\u{FF2B}", "l" : "\u{FF2C}", "m" : "\u{FF2D}", "n" : "\u{FF2E}", "o" : "\u{FF2F}", "p" : "\u{FF30}", "q" : "\u{FF31}", "r" : "\u{FF32}", "s" : "\u{FF33}", "t" : "\u{FF34}", "u" : "\u{FF35}", "v" : "\u{FF36}", "w" : "\u{FF37}", "x" : "\u{FF38}", "y" : "\u{FF39}", "z" : "\u{FF3A}"]
        
        let emojiSix = ["a" : "\u{249c}", "b" : "\u{249d}", "c" : "\u{249e}", "d" : "\u{249f}", "e" : "\u{24a0}", "f" : "\u{24a1}", "g" : "\u{24a2}", "h" : "\u{24a3}", "i" : "\u{24a4}", "j" : "\u{24a5}", "k" : "\u{24a6}", "l" : "\u{24a7}", "m" : "\u{24a8}", "n" : "\u{24a9}", "o" : "\u{24aa}", "p" : "\u{24ab}", "q" : "\u{24ac}", "r" : "\u{24ad}", "s" : "\u{24ae}", "t" : "\u{24af}", "u" : "\u{24b0}", "v" : "\u{24b1}", "w" : "\u{24b2}", "x" : "\u{24b3}", "y" : "\u{24b4}", "z" : "\u{24b5}"]
        
        let emojiSeven = ["a" : "\u{0250}", "b" : "\u{0071}", "c" : "\u{0254}", "d" : "\u{0070}", "e" : "\u{01DD}", "f" : "\u{025F}", "g" : "\u{0183}", "h" : "\u{0265}", "i" : "\u{0131}", "j" : "\u{027E}", "k" : "\u{029E}", "l" : "\u{0283}", "m" : "\u{026F}", "n" : "\u{0075}", "o" : "\u{FF4F}", "p" : "\u{FF44}", "q" : "\u{FF42}", "r" : "\u{0279}", "s" : "\u{FF53}", "t" : "\u{0287}", "u" : "\u{FF4E}", "v" : "\u{028C}", "w" : "\u{028D}", "x" : "\u{FF58}", "y" : "\u{028E}", "z" : "\u{FF5A}"]
        
        let emojiEight = ["a" : "\u{10DB}", "b" : "\u{10A6}", "c" : "\u{10BA}", "d" : "\u{10BB}", "e" : "\u{10DE}", "f" : "\u{10F0}", "g" : "\u{10AB}", "h" : "\u{10B7}", "i" : "\u{10C1}", "j" : "\u{10B1}", "k" : "\u{10B0}", "l" : "\u{10A4}", "m" : "\u{10E3}", "n" : "\u{10D3}", "o" : "\u{10E2}", "p" : "\u{10C5}", "q" : "\u{10D6}", "r" : "\u{10BC}", "s" : "\u{10F7}", "t" : "\u{10B5}", "u" : "\u{10B6}", "v" : "\u{10E1}", "w" : "\u{10DA}", "x" : "\u{10EF}", "y" : "\u{10EF}", "z" : "\u{10BF}"]
        
        let emojiNine = ["a" : "\u{0B85}", "b" : "\u{0B86}", "c" : "\u{0B87}", "d" : "\u{0B88}", "e" : "\u{0B89}", "f" : "\u{0B8A}", "g" : "\u{0B8E}", "h" : "\u{0B8F}", "i" : "\u{0B90}", "j" : "\u{0B92}", "k" : "\u{0B94}", "l" : "\u{0B95}", "m" : "\u{0B99}", "n" : "\u{0B9A}", "o" : "\u{0B9C}", "p" : "\u{0B9E}", "q" : "\u{0B9F}", "r" : "\u{0BA3}", "s" : "\u{0BA4}", "t" : "\u{0BA8}", "u" : "\u{0BA9}", "v" : "\u{0BAA}", "w" : "\u{0BAF}", "x" : "\u{0BB0}", "y" : "\u{0BB1}", "z" : "\u{0BB2}"]
        
        let emojiTen = ["a" : "\u{0001F110}", "b" : "\u{0001F111}", "c" : "\u{0001F132}", "d" : "\u{0001F133}", "e" : "\u{0001F134}", "f" : "\u{0001F135}", "g" : "\u{0001F136}", "h" : "\u{0001F137}", "i" : "\u{0001F138}", "j" : "\u{0001F139}", "k" : "\u{0001F13A}", "l" : "\u{0001F13B}", "m" : "\u{0001F13C}", "n" : "\u{0001F13D}", "o" : "\u{0001F13E}", "p" : "\u{0001F13F}", "q" : "\u{0001F140}", "r" : "\u{0001F141}", "s" : "\u{0001F142}", "t" : "\u{0001F143}", "u" : "\u{0001F144}", "v" : "\u{0001F145}", "w" : "\u{0001F146}", "x" : "\u{0001F147}", "y" : "\u{0001F148}", "z" : "\u{0001F149}"]
        
        let emojiEleven = ["a" : "\u{3200}", "b" : "\u{3201}", "c" : "\u{3202}", "d" : "\u{3203}", "e" : "\u{3204}", "f" : "\u{3205}", "g" : "\u{3206}", "h" : "\u{3207}", "i" : "\u{3208}", "j" : "\u{3209}", "k" : "\u{320A}", "l" : "\u{320B}", "m" : "\u{320C}", "n" : "\u{320D}", "o" : "\u{320E}", "p" : "\u{320F}", "q" : "\u{3210}", "r" : "\u{3211}", "s" : "\u{3212}", "t" : "\u{3213}", "u" : "\u{3214}", "v" : "\u{3215}", "w" : "\u{3217}", "x" : "\u{3218}", "y" : "\u{3219}", "z" : "\u{321A}"]
        
        let emojiTwelve = ["a" : "\u{328A}", "b" : "\u{328B}", "c" : "\u{328C}", "d" : "\u{328D}", "e" : "\u{328E}", "f" : "\u{328F}", "g" : "\u{3290}", "h" : "\u{3291}", "i" : "\u{3292}", "j" : "\u{3293}", "k" : "\u{3294}", "l" : "\u{3295}", "m" : "\u{3296}", "n" : "\u{3297}", "o" : "\u{3298}", "p" : "\u{3299}", "q" : "\u{329A}", "r" : "\u{329B}", "s" : "\u{329C}", "t" : "\u{329D}", "u" : "\u{329E}", "v" : "\u{329F}", "w" : "\u{32A0}", "x" : "\u{32A1}", "y" : "\u{32A2}", "z" : "\u{32A3}"]
        
        let emojiThirteen = ["a" : "\u{0D85}", "b" : "\u{0D86}", "c" : "\u{0D87}", "d" : "\u{0D88}", "e" : "\u{0D89}", "f" : "\u{0D8A}", "g" : "\u{0D8B}", "h" : "\u{0D8C}", "i" : "\u{0D8D}", "j" : "\u{0D8E}", "k" : "\u{0D8F}", "l" : "\u{0D90}", "m" : "\u{0D91}", "n" : "\u{0D92}", "o" : "\u{0D93}", "p" : "\u{0D94}", "q" : "\u{0D95}", "r" : "\u{0D96}", "s" : "\u{0D9A}", "t" : "\u{0D9B}", "u" : "\u{0D9C}", "v" : "\u{0D9D}", "w" : "\u{0D9E}", "x" : "\u{0D9F}", "y" : "\u{0DA0}", "z" : "\u{0DA1}"]
        
        let emojiFourteen = ["a" : "\u{0E81}", "b" : "\u{0E81}", "c" : "\u{0E81}", "d" : "\u{0E87}", "e" : "\u{0E88}", "f" : "\u{0E8A}", "g" : "\u{0E8D}", "h" : "\u{0E94}", "i" : "\u{0E95}", "j" : "\u{0E96}", "k" : "\u{0E97}", "l" : "\u{0E99}", "m" : "\u{0E9A}", "n" : "\u{0E9B}", "o" : "\u{0E9C}", "p" : "\u{0E9D}", "q" : "\u{0E9E}", "r" : "\u{0E9F}", "s" : "\u{0EA1}", "t" : "\u{0EA2}", "u" : "\u{0EA3}", "v" : "\u{0EA5}", "w" : "\u{0EA7}", "x" : "\u{0EAA}", "y" : "\u{0EAB}", "z" : "\u{0EAD}"]
        
        let emojiFifteen = ["a" : "\u{0A05}", "b" : "\u{0A06}", "c" : "\u{0A07}", "d" : "\u{0A08}", "e" : "\u{0A09}", "f" : "\u{0A0A}", "g" : "\u{0A0F}", "h" : "\u{0A10}", "i" : "\u{0A13}", "j" : "\u{0A14}", "k" : "\u{0A15}", "l" : "\u{0A16}", "m" : "\u{0A17}", "n" : "\u{0A18}", "o" : "\u{0A19}", "p" : "\u{0A5E}", "q" : "\u{0A5C}", "r" : "\u{0A5B}", "s" : "\u{0A5A}", "t" : "\u{0A35}", "u" : "\u{0A33}", "v" : "\u{0A39}", "w" : "\u{0A38}", "x" : "\u{0A2F}", "y" : "\u{0A2E}", "z" : "\u{0A23}"]
        
        emojiDictionary["EmojiSetOne"] = emojiOne; emojiDictionary["emojiTwo"] = emojiTwo; emojiDictionary["emojiThree"] = emojiThree; emojiDictionary["emojiFour"] = emojiFour; emojiDictionary["emojiFive"] = emojiFive; emojiDictionary["emojiSix"] = emojiSix; emojiDictionary["emojiSeven"] = emojiSeven; emojiDictionary["emojiEight"] = emojiEight; emojiDictionary["emojiNine"] = emojiNine; emojiDictionary["emojiTen"] = emojiTen; emojiDictionary["emojiEleven"] = emojiEleven; emojiDictionary["emojiTwelve"] = emojiTwelve; emojiDictionary["emojiThirteen"] = emojiThirteen; emojiDictionary["emojiFourteen"] = emojiFourteen; emojiDictionary["emojiFifteen"] = emojiFifteen;
        
        emojiArrayKey = ["EmojiSetOne", "emojiTwo", "emojiThree", "emojiFour", "emojiFive", "emojiSix", "emojiSeven", "emojiEight", "emojiNine", "emojiTen", "emojiEleven", "emojiTwelve", "emojiThirteen", "emojiFourteen", "emojiFifteen"]
        
        //start parsing Emojis
        for oneSetOfEmojiKey in emojiArrayKey {
            var stringEmoji = String()
            
//            println("\(oneSetOfEmojiKey) \(emojiDictionary[oneSetOfEmojiKey])")
            for oneEmojiDictionary in emojiDictionary[oneSetOfEmojiKey]! {
                if stringEmoji.isEmpty == true {
                    stringEmoji = oneEmojiDictionary.1
//                    println(stringEmoji)
                }else{
                    stringEmoji = stringEmoji + oneEmojiDictionary.1
//                    println(stringEmoji)
                }
            }
//            println("Emojis String Set: \(stringEmoji)")
            emojiStringSetArray.append(stringEmoji)
        }
    }
    
    /**
    type 0 : emojiStringSetArray = [String]()
    type 1 : emojiArrayKey : [String]!
    */
    func getLeterTypeSetArray(type: Int) -> [String]! {
        if type == 0 {
            return emojiStringSetArray
        }else if type == 1 {
            return emojiArrayKey
        }
        
        return nil
    }
    
    /**
    type 2 : emojiDictionary = Dictionary<String, Dictionary<String, String>>()
    */
    func getLeterTypeSetDictionary(type : Int) -> Dictionary<String, Dictionary<String, String>>! {
        if type == 2 {
            return emojiDictionary
        }
        return nil
    }
    

    func gifDirectoryFinder() {
        
        var Baddies_25 = [String](), Entertainment_31 = [String](), Animal_39 = [String](), Funny_46 = [String](), Holidays_26 = [String](), Loving_71 = [String](), Mad_22 = [String](), Monsters_26 = [String](), Sad_26 = [String](), Very_Happy_57 = [String]()

        
        
        var getImagePath : [AnyObject] = NSBundle.mainBundle().pathsForResourcesOfType("gif", inDirectory: "Animal_39")
//        println("count: \(countElements(getImagePath))")
        for var index = 0; index < countElements(getImagePath); index++ {
            Animal_39.append(getImagePath[index] as String)
        }
        emojiCategoryTwo["Animal_39"] = Animal_39
        
        
        var Baddies_25Path : [AnyObject] = NSBundle.mainBundle().pathsForResourcesOfType("gif", inDirectory: "Baddies_25")
//        println("count: \(countElements(Baddies_25Path))")
        for var index = 0; index < countElements(Baddies_25Path); index++ {
            Baddies_25.append(Baddies_25Path[index] as String)
        }
        emojiCategoryTwo["Baddies_25"] = Baddies_25
        
        
        var Entertainment_31Path : [AnyObject] = NSBundle.mainBundle().pathsForResourcesOfType("gif", inDirectory: "Entertainment_31")
//        println("count: \(countElements(Entertainment_31Path))")
        for var index = 0; index < countElements(Entertainment_31Path); index++ {
            Entertainment_31.append(Entertainment_31Path[index] as String)
        }
        emojiCategoryTwo["Entertainment_31"] = Entertainment_31

        
        var Funny_46Path : [AnyObject] = NSBundle.mainBundle().pathsForResourcesOfType("gif", inDirectory: "Funny_46")
        for var index = 0; index < countElements(Funny_46Path); index++ {
            Funny_46.append(Funny_46Path[index] as String)
        }
        emojiCategoryTwo["Funny_46"] = Funny_46
        
        
        var Holidays_26Path : [AnyObject] = NSBundle.mainBundle().pathsForResourcesOfType("gif", inDirectory: "Holidays_26")
        for var index = 0; index < countElements(Holidays_26Path); index++ {
            Holidays_26.append(Holidays_26Path[index] as String)
        }
        emojiCategoryTwo["Holidays_26"] = Holidays_26

        
        var Loving_71Path : [AnyObject] = NSBundle.mainBundle().pathsForResourcesOfType("gif", inDirectory: "Loving_71")
        for var index = 0; index < countElements(Loving_71Path); index++ {
            Loving_71.append(Loving_71Path[index] as String)
        }
        emojiCategoryTwo["Loving_71"] = Loving_71
        
        
        var Mad_22Path : [AnyObject] = NSBundle.mainBundle().pathsForResourcesOfType("gif", inDirectory: "Mad_22")
        for var index = 0; index < countElements(Mad_22Path); index++ {
            Mad_22.append(Mad_22Path[index] as String)
        }
        emojiCategoryTwo["Mad_22"] = Mad_22
        
        
        var Monsters_26Path : [AnyObject] = NSBundle.mainBundle().pathsForResourcesOfType("gif", inDirectory: "Monsters_26")
        for var index = 0; index < countElements(Monsters_26Path); index++ {
            Monsters_26.append(Monsters_26Path[index] as String)
        }
        emojiCategoryTwo["Monsters_26"] = Monsters_26
        
        
        var Sad_26Path : [AnyObject] = NSBundle.mainBundle().pathsForResourcesOfType("gif", inDirectory: "Sad_26")
        for var index = 0; index < countElements(Sad_26Path); index++ {
            Sad_26.append(Sad_26Path[index] as String)
        }
        emojiCategoryTwo["Sad_26"] = Sad_26
        
        
        var Very_Happy_57Path : [AnyObject] = NSBundle.mainBundle().pathsForResourcesOfType("gif", inDirectory: "Very Happy_57")
        for var index = 0; index < countElements(Very_Happy_57Path); index++ {
            Very_Happy_57.append(Very_Happy_57Path[index] as String)
        }
        emojiCategoryTwo["Very_Happy_57"] = Very_Happy_57
        

        
        emojiSelector.append(emojiCategoryTwo)
        
//        println("Emojis: \n \(emojiSelector)")
        println("Loaded Emojis")        
    }

}