//
//  Uzantı+UIButton.swift
//  Binder
//
//  Created by Macintosh HD on 19.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    
    convenience init(baslik : String , baslikRenk : UIColor , baslikFont : UIFont = UIFont.systemFont(ofSize: 15) , arkaPlanRenk : UIColor = UIColor.clear, target : Any? = nil , action: Selector? = nil) {
        
        self.init(type : .system)
        
        setTitle(baslik, for:.normal)
        setTitleColor(baslikRenk, for: .normal)
        
        titleLabel?.font = baslikFont
        backgroundColor = arkaPlanRenk
        
        if let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
        
    }
    
    convenience init(image : UIImage , tintColor : UIColor? = nil , target : Any? = nil , action : Selector? = nil) {
        self.init(type : .system)
        
        if tintColor == nil {
            setImage(image, for: .normal)
            
        }else{
            setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
            self.tintColor = tintColor
        }
        
        if let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
        
    }
    
    
    
    
    
    
    
    
    
}
