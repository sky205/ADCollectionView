//
//  ADCollectionLayout.swift
//  ADCollection
//
//  Created by max205 on 2016/5/24.
//  Copyright © 2016年 max205. All rights reserved.
//

import UIKit

protocol ADCollectionLayoutDelegate {
    
    func collectionLayout(layout: UICollectionViewLayout, spaceOfSection section: Int) -> CollectionSpace;
    func collectionLayout(layout: UICollectionViewLayout, itemSizeOfSection section: Int) -> CGSize;
    func collectionLayout(layout: UICollectionViewLayout, itemZoomOfIndexPath index: NSIndexPath) -> CGSize;
    
}


class CollectionSpace {
    
    let itemSpace, lineSpace: CGFloat;
    init(itemSpace: CGFloat, lineSpace: CGFloat) {
        self.itemSpace = itemSpace;
        self.lineSpace = lineSpace;
    }
    
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
    var maxOriginY: CGFloat = 0;
    
    
    var cacheData = [NSIndexPath: UICollectionViewLayoutAttributes]();
    
    
    override func prepareLayout() {
        super.prepareLayout();
        
        print("prepareLayout");
        
        self.maxOriginY = 0;
        self.nowOriginY = 0;
        self.cacheData.removeAll(keepCapacity: false);
        
        let sections = self.collectionView!.numberOfSections();
        for i in 0..<sections {
            self.cells[i] = self.collectionView!.numberOfItemsInSection(i);
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        //print("collectionViewContentSize");
        return self.contentSize == CGSizeZero ? self.collectionView!.frame.size : self.contentSize;
        
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        if let attribute = self.cacheData[indexPath]  {
            return attribute;
        }
        
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath);
        let itemZoom = self.delegate!.collectionLayout(self, itemZoomOfIndexPath: indexPath);
        let rect = self.calculatePoint(itemSize, zoom: itemZoom);
        attributes.frame = rect;
        
        self.cacheData[indexPath] = attributes;
        
        return attributes;
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //print("layoutAttributesForElementsInRect");
        var attributes = [UICollectionViewLayoutAttributes]();
        
        
        
        
        for section in 0..<self.cells.count {
            
            
            
            // value setting
            self.setItemSize(withSection: section);
            self.setSpaceOfItem(withSection: section);
            self.setMaxW(withSection: section);
            
            //initial
            self.lastRow = 0;
            self.grid.removeAll(keepCapacity: false);
            self.createFullRow(withMaxWidth: self.maxW);
            
            
            for row in 0..<self.cells[section]! {
                let attribute = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forRow: row, inSection: section))!;
                attributes.append(attribute);
                
                //計算最低點.
                let maxY = attribute.frame.origin.y + attribute.frame.height;
                self.maxOriginY = self.maxOriginY > maxY ? self.maxOriginY : maxY;
                
            }
            
            self.nowOriginY = self.maxOriginY;
            ////print(grid);
            
        }
        
        
        self.contentSize.height = self.nowOriginY;
        
        
        return attributes;
        
    }
    
    
    func setItemSize(withSection section: Int) {
        self.itemSize = self.delegate!.collectionLayout(self, itemSizeOfSection: section);
    }
    
    func setSpaceOfItem(withSection section: Int) {
        let space = self.delegate!.collectionLayout(self, spaceOfSection: section);
        self.itemSpace = space.itemSpace;
        self.lineSpace = space.lineSpace;
    }
    
    func setMaxW(withSection section: Int){
        self.maxW = Int(self.collectionView!.frame.width / (itemSize.width + self.itemSpace));
        self.maxW = self.maxW > 0 ? self.maxW : 1;
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
        
        //如果寬超出邊界， 幫他建立額外範圍.
        self.createSpaceIfNeeded(self.grid.count-1, zoom: zoom);
        self.fillGridSpaceWithItem(fillPoint, zoom: zoom);
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
            //print("create height space to:\(self.grid.count)");
        }
        
    }
    
    func createSpaceIfNeeded(pointY: Int, zoom: CGSize){
        let zHeight = Int(zoom.height);
        let zWidth = Int(zoom.width);
        let needW = zWidth - self.maxW;
        
        self.createHeightSpaceIfNeeded(pointY, zoomH: zHeight);
        
        if needW > 0 {
            for i in pointY..<pointY+zHeight {
                for _ in 0..<needW {
                    self.grid[i].append(false);
                }
            }
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
        
        
        
        let width = ((itemSize.width+self.itemSpace) * zoom.width) - self.itemSpace;
        let height = ((itemSize.height+self.lineSpace) * zoom.height) - self.lineSpace;
        
        let originX = ((itemSize.width+itemSpace) * point.x);
        let originY = ((itemSize.height+lineSpace) * point.y) + self.nowOriginY;
        
        let rect = CGRectMake(originX, originY, width, height);
        
        //print("item point:(x:\(point.x), y:\(point.y)), origin y:\(originY)");
        
        //計算最低點位置. 用於section之間的區隔
        
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
















