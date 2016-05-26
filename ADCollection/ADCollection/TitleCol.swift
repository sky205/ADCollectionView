//
//  TitleCol.swift
//  ADCollection
//
//  Created by max205 on 2016/5/26.
//  Copyright © 2016年 max205. All rights reserved.
//

import UIKit

class TitleCol: BaseCol {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func setContent(info: AnyObject) {
        if let data = info as? String {
            self.titleLabel.text = data;
        }
    }
    
    
}



