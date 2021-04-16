//
//  UIStackView.swift
//  Binder
//
//  Created by Macintosh HD on 19.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    
    @discardableResult // yani alttaki fonk kullanabilirimde kullanmayabilirimde bir hata mesaj söz konusu değil
    func withMargin(_ margin : UIEdgeInsets) -> UIStackView {//tüm kenarlardan verebilecek boşlukları tutabilecek özellik
        
        layoutMargins = margin
        isLayoutMarginsRelativeArrangement = true
        return self
    }
    
    @discardableResult
    func padTop(_ top : CGFloat) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.top = top
        return self
    }
    
    @discardableResult
    func padBottom(_ bottom : CGFloat) -> UIStackView {
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.bottom = bottom
        return self
    }
    
    
    @discardableResult
    func padRight(_ right : CGFloat) -> UIStackView {
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.right = right
        return self
    }
    
    @discardableResult
    func padLeft(_ left : CGFloat) -> UIStackView {
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.left = left
        return self
    }
    

    
}
