//
//  Uzanti+UITextView.swift
//  Binder
//
//  Created by Macintosh HD on 19.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation
import UIKit


extension UITextView {
    
    convenience init(text : String? , font : UIFont? = UIFont.systemFont(ofSize: 15) , textColor : UIColor = UIColor.black , textAlignment : NSTextAlignment = .left ) {
        
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment

    }

}
