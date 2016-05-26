//
//  ViewController.swift
//  ADCollection
//
//  Created by max205 on 2016/5/23.
//  Copyright © 2016年 max205. All rights reserved.
//

import UIKit

class ViewController: CollectionViewController, ADCollectionLayoutDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNib("ImageCol", identify: "imgCol");
        self.registerNib("TtileCol", identify: "titleCol");
        
        let images = [
            "test1.png",
            "test2.jpg",
            "test3.png",
            "test4.png",
            "test5.png"
        ];
        
        
        self.addSection();
        self.addCellDataOfSection(CellData(identify: "titleCol", data: "test2"), section: 0);
        
        
        
        self.addSection();
        for i in 0..<images.count {
            let img = UIImage(named: images[i])!;
            let height: CGFloat = i % 2 == 0 ? 200 : 100;
            let data = CellData(identify: "imgCol", data: ImageColData(image: img), height: height, width: (self.view.frame.width-16) / 2);
            self.addCellDataOfSection(data, section: 1);
        }
        
        
        self.addSection()
        self.addCellDataOfSection(CellData(identify: "titleCol", data: "test2"), section: 2);
        
        self.addSection();
        for i in (0..<images.count).reverse() {
            let img = UIImage(named: images[i])!;
            let height: CGFloat = i % 2 == 0 ? 200 : 100;
            let data = CellData(identify: "imgCol", data: ImageColData(image: img), height: height, width: (self.view.frame.width-16) / 2);
            self.addCellDataOfSection(data, section: 3);
        }
        
        
        
        
        let layout = ADCollectionLayout();
        layout.delegate = self;
        
        self.collectionView.collectionViewLayout = layout;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        self.collectionView.reloadData();
        
    }
    
    
    //MARK: ADCollectionLayoutDelegate
    func collectionLayout(layout: UICollectionViewLayout, spaceOfSection section: Int) -> CollectionSpace {
        switch(section) {
        case 0, 2:
            return CollectionSpace(itemSpace: 0, lineSpace: 8);
            
        case 1:
            return CollectionSpace(itemSpace: 8, lineSpace: 8);
            
        case 2:
            return CollectionSpace(itemSpace: 0, lineSpace: 8);
            
        default:
            return CollectionSpace(itemSpace: 0, lineSpace: 8);
        }
    }
    
    func collectionLayout(layout: UICollectionViewLayout, itemSizeOfSection section: Int) -> CGSize {
        switch(section) {
        case 0, 2:
            return CGSize(width: self.collectionView.frame.width, height: 30);
            
        case 1:
            return CGSize(width: (self.collectionView.frame.width-16) / 2  , height: 100);
            
        case 3:
            return CGSize(width: self.collectionView.frame.width, height: 100);
        
        default:
            return CGSizeZero;
        }
        
    }
    
    func collectionLayout(layout: UICollectionViewLayout, itemZoomOfIndexPath index: NSIndexPath) -> CGSize {
        
        switch(index.section) {
        case 1:
            return CGSize(width: 1, height: (index.row+3) % 3 == 0 ? 2 : 1 );
            
            
        default:
            return CGSize(width: 1, height: 1);
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    

}

class CellData {
    
    var identify: String;
    var data: AnyObject;
    var height: CGFloat = 0;
    var width: CGFloat = 0;
    
    init(identify: String, data: AnyObject) {
        self.identify = identify;
        self.data = data;
    }
    
    init(identify: String, data: AnyObject, height: CGFloat, width: CGFloat) {
        self.identify = identify;
        self.data = data;
        self.height = height;
        self.width = width;
    }
    
}