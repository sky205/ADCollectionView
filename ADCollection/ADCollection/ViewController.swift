//
//  ViewController.swift
//  ADCollection
//
//  Created by max205 on 2016/5/23.
//  Copyright © 2016年 max205. All rights reserved.
//

import UIKit

class ViewController: CollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNib("ImageCol", identify: "imgCol");
        
        let images = [
            "test1.png",
            "test2.jpg",
            "test3.png",
            "test4.png",
            "test5.png"
        ];
        
        
        self.addSection();
        
        for i in 0..<images.count {
            let img = UIImage(named: images[i])!;
            let height: CGFloat = i % 2 == 0 ? 200 : 100;
            let data = CellData(identify: "imgCol", data: ImageColData(image: img), height: height, width: (self.view.frame.width-16) / 2);
            self.addCellDataOfSection(data, section: 0);
        }
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        self.collectionView.reloadData();
        
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