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
    
    
    var cells = [Int: Int]();
    
    var contentSize: CGSize = CGSizeZero;
    var controller: CollectionViewController?;
    
    var itemSize: CGSize = CGSizeZero;
    var itemSpace: CGFloat = 10;
    var lineSpace: CGFloat = 10;
    var grid = [[Bool]]();
    var maxW: Int!;
    
    var nowOriginY: CGFloat = 0;
    
    
    override func prepareLayout() {
        super.prepareLayout();
        
        let sections = self.collectionView!.numberOfSections();
        for i in 0..<sections {
            self.cells[i] = self.collectionView!.numberOfItemsInSection(i);
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        print("collectionViewContentSize");
        return self.contentSize == CGSizeZero ? self.collectionView!.frame.size : self.contentSize;
        
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath);
        let itemZoom = self.delegate!.collectionLayout(self, itemZoomOfIndexPath: indexPath);
        let rect = self.calculatePoint(itemSize, zoom: itemZoom);
        attributes.frame = rect;
        
        return attributes;
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print("layoutAttributesForElementsInRect");
        var attributes = [UICollectionViewLayoutAttributes]();
        
        for i in 0..<self.cells.count {
            
            //initial
            self.lastRow = 0;
            self.itemSize = self.delegate!.collectionLayout(self, itemSizeOfSection: i);
            self.maxW = Int(self.collectionView!.frame.width / (itemSize.width + self.itemSpace));
            self.grid.removeAll(keepCapacity: false);
            self.createFullRow(withMaxWidth: self.maxW);
            
            for j in 0..<self.cells[i]! {
                
                let attribute = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forRow: j, inSection: i))!;
                attributes.append(attribute);
            }
            
            print(grid);
            
        }
        
        
        
        return attributes;
        
    }
    
    
    var lastRow = 0;
    func calculatePoint(itemSize: CGSize, zoom: CGSize) -> CGRect {
        //雙迴圈， 掃過所有的grid
        
        let zoomWith: Int = Int(zoom.width);
        let zoomHeight: Int = Int(zoom.height);
        
        for i in lastRow..<grid.count { //列
            for j in 0..<grid[i].count {
                
                if grid[i][j] == false && (grid[i].count-(j) >= zoomWith) {
                    
                    //創造不足的高度空間
                    self.createHeightSpaceIfNeeded(i, zoomH: zoomHeight);
                    
                    //將Grid空間更改為true, 代表此位已滿.
                    let fillPoint = CGPoint(x: j, y: i);
                    self.fillGridSpaceWithItem(fillPoint, zoom: zoom)
                    let rect = self.calculateRect(fillPoint, itemSize: itemSize, zoom: zoom);
                    return rect;
                    
                }
            }
        }
        
        self.createFullRow(withMaxWidth: self.maxW);
        let fillPoint = CGPoint(x: 0, y: self.grid.count-1);
        self.createHeightSpaceIfNeeded(self.grid.count-1, zoomH: zoomHeight);
        self.fillGridSpaceWithItem(fillPoint, zoom: zoom)
        self.lastRow += 1;
        
        let rect = self.calculateRect(fillPoint, itemSize: itemSize, zoom: zoom);
        return rect;
        
        
    }
    
    
    func createHeightSpaceIfNeeded(pointY: Int, zoomH: Int){
        
        let lastH = self.grid.count-pointY
        if zoomH > lastH {
            let needH = zoomH - lastH;
            for _ in 0..<needH {
                self.createFullRow(withMaxWidth: self.maxW);
            }
            print("create height space to:\(self.grid.count)");
        }
        
    }
    
    func fillGridSpaceWithItem(point: CGPoint, zoom: CGSize) {
        
        let pointX = Int(point.x);
        let pointY = Int(point.y);
        let height = Int(zoom.height);
        let width = Int(zoom.width);
        
        for i in pointY..<pointY+height {
            for j in pointX..<pointX+width {
                self.grid[i][j] = true;
            }
        }
        
    }
    
    
    func calculateRect(point: CGPoint, itemSize: CGSize, zoom: CGSize) -> CGRect {
        
        print("item point:(x:\(point.x), y:\(point.y))");
        
        let width = ((itemSize.width+self.itemSpace) * zoom.width) - self.itemSpace;
        let height = ((itemSize.height+self.lineSpace) * zoom.height) - self.lineSpace;
        
        let originX = ((itemSize.width+itemSpace) * point.x);
        let originY = ((itemSize.height+lineSpace) * point.y);
        
        let rect = CGRectMake(originX, originY, width, height);
        return rect;
    }
    
    
    
    func createFullRow(withMaxWidth maxW: Int) {
        var row = [Bool]();
        for _ in 0..<maxW {
            row.append(false);
        }
        self.grid.append(row);
    }
    
    
    
    
}
















