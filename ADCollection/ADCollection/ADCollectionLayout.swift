//
//  ADCollectionLayout.swift
//  ADCollection
//
//  Created by max205 on 2016/5/24.
//  Copyright © 2016年 max205. All rights reserved.
//

import UIKit

protocol ADCollectionLayoutDelegate {
    
    func numberOfSections() -> Int;
    func collectionViewLayout(layout: UICollectionViewLayout, numberOfRowsInSection section: Int) -> Int;
    
    func collectionLayout(layout: UICollectionViewLayout, itemSizeOfSection section: Int) -> CGSize;
    func collectionLayout(layout: UICollectionViewLayout, itemZoomOfIndexPath index: NSIndexPath) -> CGSize;
    
}



class ADCollectionLayout: UICollectionViewLayout {
    
    
    var delegate: ADCollectionLayoutDelegate?;
    
    
    var contentSize: CGSize = CGSizeZero;
    var controller: CollectionViewController?;
    
    var itemSpace: CGFloat = 10;
    var lineSpace: CGFloat = 10;
    var grid = [[Bool]]();
    var maxW: Int!;
    
    override func prepareLayout() {
        
        self.grid.append([Bool]());
        super.prepareLayout();
        
    }
    
    override func collectionViewContentSize() -> CGSize {
        print("collectionViewContentSize");
        return self.contentSize == CGSizeZero ? self.collectionView!.frame.size : self.contentSize;
        
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath);
        
        return attributes;
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print("layoutAttributesForElementsInRect");
        var attributes = [UICollectionViewLayoutAttributes]();
        
        if let sections = self.delegate?.numberOfSections() {
            for i in 0..<sections {
                
                //抓取每個Section的Base Size, 且定義Grid的最大寬度.
                let itemSize = self.delegate!.collectionLayout(self, itemSizeOfSection: i);
                self.maxW = Int(self.collectionView!.frame.width / (itemSize.width + self.itemSpace));
                
                //抓取cell定義的zoom值，且計算frame.origin的位置.
                let rows = self.delegate!.collectionViewLayout(self, numberOfRowsInSection: i)
                for j in 0..<rows {
                    let index = NSIndexPath(forRow: j, inSection: i);
                    let zoom = self.delegate!.collectionLayout(self, itemZoomOfIndexPath: index);
                    self.calculatePoint(itemSize, zoom: zoom);
                }
            }
        }
        
        
        return attributes;
        
    }
    
    
    func calculatePoint(itemSize: CGSize, zoom: CGSize) -> CGPoint {
        var point = CGPoint(x: 0, y: 0);
        
        //雙迴圈， 掃過所有的grid
        for i in 0..<grid.count {
            
        }
        
        
        
        return point;
    }
    
    
    
    
}
















