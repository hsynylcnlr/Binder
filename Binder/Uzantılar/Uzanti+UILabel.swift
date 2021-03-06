//
//  Uzanti+UILabel.swift
//  Binder
//
//  Created by Macintosh HD on 19.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    convenience init(text : String? = nil, font : UIFont? = UIFont.systemFont(ofSize: 15) , textColor : UIColor = .black , textAlignment : NSTextAlignment = .left , numberOfLines : Int = 1) {
        
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        
    }

    
}


