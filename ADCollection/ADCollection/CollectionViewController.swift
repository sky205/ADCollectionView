//
//  CollectionViewController.swift
//  ADCollection
//
//  Created by max205 on 2016/5/23.
//  Copyright © 2016年 max205. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var cells = [[CellData]]();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: CellData Process
    func addCellDataOfSection(data: CellData, section index: Int) {
        if self.cells.count > index {
            self.cells[index].append(data);
        }
    }
    
    func addSection() -> Int {
        
        self.cells.append([CellData]());
        
        return self.cells.count-1;
        
    }
    
    
    func getCellData(index: NSIndexPath) -> CellData? {
        if self.cells.count > index.section && self.cells[index.section].count > index.row {
            return self.cells[index.section][index.row];
        }
        return nil;
    }
    
    func getCellData(row: Int, section: Int) -> CellData? {
        return self.getCellData(NSIndexPath(forRow: row, inSection: section));
    }
    
    func registerNib(nibName: String, identify: String?) {
        let identifier = identify ?? nibName;
        collectionView.registerNib(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: identifier);
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.cells.count
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.cells[section].count;
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellData = self.getCellData(indexPath)!;
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellData.identify, forIndexPath: indexPath)
        if let col = cell as? BaseCol {
            col.setContent(cellData.data);
        }
    
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if let cellData = self.getCellData(indexPath) {
            let size = CGSize(width: cellData.width, height: cellData.height);
            return size;
        }
        return CGSizeZero;
    }
    
    
    
    
    
    
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
