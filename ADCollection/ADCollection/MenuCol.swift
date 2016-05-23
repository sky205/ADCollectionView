//
//  TableCol.swift
//  ADCollection
//
//  Created by max205 on 2016/5/23.
//  Copyright © 2016年 max205. All rights reserved.
//

import UIKit

class TableCol: BaseCol, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var data: MenuColData!;
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setContent(info: AnyObject) {
        
        if let data = info as? MenuColData {
            self.data = data;
            for (nibName, idnetify) in data.identifys {
                self.collectionView.registerNib(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: idnetify);
            }
            
            self.collectionView.delegate = self;
            self.collectionView.dataSource = self;
            self.collectionView.reloadData();
        
        }
        
        
    }
    

    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.cells.count;
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellData = self.data.cells[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellData.identify, forIndexPath: indexPath);
        if let col = cell as? BaseCol {
            col.setContent(cellData.data);
        }
        
        return cell;
    }
    
    
    
}


class MenuColData {
    
    var identifys: [String: String];
    var cells: [CellData];
    var height: CGFloat;
    
    init(identifys: [String: String], cells: [CellData], height: CGFloat) {
        self.identifys = identifys;
        self.cells = cells;
        self.height = height;
    }
    
}