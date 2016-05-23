//
//  ImageCol.swift
//  ADCollection
//
//  Created by max205 on 2016/5/23.
//  Copyright © 2016年 max205. All rights reserved.
//

import UIKit

class ImageCol: BaseCol {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setContent(info: AnyObject) {
        
        if let data = info as? ImageColData {
            self.imageView.image = data.image;
        }
    }
    
    
}


class ImageColData {
    
    var image: UIImage?
    var imagePath: String?;
    
    init(image: UIImage?) {
        self.image = image;
    }
    
}
