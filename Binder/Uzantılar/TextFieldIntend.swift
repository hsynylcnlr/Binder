//
//  TextFieldIntend.swift
//  Binder
//
//  Created by Macintosh HD on 19.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation
import UIKit

class TextFieldIntend : UITextField {
    
    let padding : CGFloat
    
    public init(placeholder : String? = nil, padding : CGFloat = 0, cornerRadius : CGFloat = 0, keyboardType : UIKeyboardType = .default , backgroundColor : UIColor = UIColor.clear , isSecureTextEntry : Bool = false ) {
        
        self.padding = padding
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        layer.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecureTextEntry
        
    }
    
    //texte girmeden önce girdiktensonraki içerden boşlukatamaları
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.insetBy(dx: padding , dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding , dy: 0)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
