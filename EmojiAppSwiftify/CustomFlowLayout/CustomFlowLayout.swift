
//
//  File.swift
//  EmojiAppSwiftify
//
//  Created by Guy Van Looveren on 7/26/14.
//  Copyright (c) 2014 Pro Sellers World. All rights reserved.
//

import Foundation

class CustomFlowLayout : UICollectionViewFlowLayout {
    var itemsInOneRow: Int!
    var frames = Array<Array<String>>()
    
    var lineSpacing: CGFloat!
    var interitemSpacing: CGFloat!
    var pageSize: CGSize!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(itemsInOneRow : Int!) {
        self.itemsInOneRow = itemsInOneRow
        super.init()
    }
    
    func calculateLayoutProperties() {
        self.pageSize = self.collectionView?.bounds.size
        
        let itemWidth: CGFloat = self.pageSize.width / CGFloat(self.itemsInOneRow + 1)
        let itemHeight: CGFloat = self.pageSize.height / CGFloat(self.itemsInOneRow + 1)
        
        self.itemSize = CGSizeMake(itemWidth, itemHeight);
        
        self.lineSpacing = (self.pageSize.width - (CGFloat(itemsInOneRow) * self.itemSize.width)) / CGFloat(self.itemsInOneRow + 1);
        self.interitemSpacing = (self.pageSize.height - (CGFloat(itemsInOneRow) * self.itemSize.height)) / CGFloat(self.itemsInOneRow + 1);
        
    }
    
    func pagesInSection(sectionz: NSInteger) -> Int{
        var items = self.collectionView?.numberOfItemsInSection(sectionz)
        return (items! - 1) / (self.itemsInOneRow * self.itemsInOneRow) + 1
    }
    
    override func collectionViewContentSize() -> CGSize {
        var sections: NSInteger = 1
        if (self.collectionView?.respondsToSelector(Selector("numberOfSections")) != nil) {
            sections = self.collectionView!.numberOfSections()
        }
        var pages: Int = 0
        for var section = 0; section < sections; section++ {
            pages = pages + self.pagesInSection(section)
        }
        
        return CGSizeMake(CGFloat(pages) * self.pageSize.width, self.pageSize.height)
    }
    
    override func prepareLayout() {
        var token : dispatch_once_t = 0
        dispatch_once(&token, {
            self.calculateLayoutProperties()
        })
        
        frames.removeAll()
        var sections : NSInteger = 1
        if (self.collectionView?.respondsToSelector(Selector("numberOfSections")) != nil) {
            sections = self.collectionView!.numberOfSections()
        }
        
        var pagesOffset : Int = 0
        var itemsInPage : Int  = itemsInOneRow * itemsInOneRow
        for var nsection = 0; nsection < sections; nsection++ {
            var framesInSection = Array<String>()
            var pagesInSection : Int = self.pagesInSection(nsection)
            var itemsInSection : Int = self.collectionView!.numberOfItemsInSection(nsection)
            for var page = 0; page < pagesInSection; page++ {
                var itemsToAddToArray : Int = itemsInSection - framesInSection.count
                var itemsInCurrentPage = itemsInPage
                if itemsToAddToArray < itemsInPage {
                    itemsInCurrentPage = itemsToAddToArray
                }
                
                for var itemInPage = 0; itemInPage < itemsInCurrentPage; itemInPage++ {
                    var originX = CGFloat(pagesOffset + Int(page)) * self.pageSize.width + self.lineSpacing + CGFloat(itemInPage % self.itemsInOneRow) * (self.itemSize.width + self.lineSpacing)
                    var originY = self.interitemSpacing + CGFloat(Int(itemInPage) / self.itemsInOneRow) * (self.itemSize.height + self.interitemSpacing)
                    var itemFrame: CGRect = CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height)
                    
                    framesInSection.append(NSStringFromCGRect(itemFrame))
                }
            }
            self.frames.append(framesInSection)
            pagesOffset += pagesInSection
        }
        
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject] {
        var attributes = Array<UICollectionViewLayoutAttributes>()
        
        var sections : NSInteger = 1
        if (self.collectionView?.respondsToSelector(Selector("numberOfSections")) != nil) {
            sections = self.collectionView!.numberOfSections()
        }
        
        var pagesOffset : Int = 0
        var itemsInPage : Int  = itemsInOneRow * itemsInOneRow

        for var nsection = 0; nsection < sections; nsection++ {
            var pagesInSection : Int = self.pagesInSection(nsection)
            var itemsInSection : Int = self.collectionView!.numberOfItemsInSection(nsection)
            for var page = 0; page < pagesInSection; page++ {
                var pageFrame : CGRect = CGRectMake(CGFloat(pagesOffset + Int(page)) * self.pageSize.width, 0, self.pageSize.width, self.pageSize.height)
                
                if CGRectIntersectsRect(rect, pageFrame) {
                    var startItemIndex : Int = Int(page) * itemsInPage
                    var itemsInCurrentPage : Int = itemsInPage
                    if itemsInSection - startItemIndex < itemsInPage {
                        itemsInCurrentPage = itemsInSection - startItemIndex
                    }
                    
                    for var itemInPage = 0; itemInPage < itemsInCurrentPage; itemInPage++ {
                        var itemAttributes : UICollectionViewLayoutAttributes = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: startItemIndex + itemInPage, inSection: nsection))
                        if CGRectIntersectsRect(itemAttributes.frame, rect) {
                            attributes.append(itemAttributes)
                        }
                    }
                }
            }
            pagesOffset += pagesInSection
        }
        return attributes
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        var attributes : UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.frame = CGRectFromString(self.frames[indexPath.section][indexPath.item])
        return attributes
    }
}
