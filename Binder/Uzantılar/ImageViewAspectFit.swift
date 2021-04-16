//
//  ImageViewAspectFit.swift
//  Binder
//
//  Created by Macintosh HD on 19.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ImageViewAspectFit: UIImageView {
    
    convenience init(image : UIImage? = nil , cornerRadius : CGFloat = 0) {
        self.init(image : image)
        self.layer.cornerRadius = cornerRadius
    }
    
    convenience init() {
        self.init(image : nil)
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        contentMode = .scaleAspectFit
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
