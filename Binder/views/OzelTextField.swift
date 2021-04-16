//
//  OzelTextField.swift
//  Binder
//
//  Created by Macintosh HD on 30.03.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import UIKit

    class OzelTextField : UITextField  { //yapılan herhangi değişiklikleri hepsi için bir class oluşturduk ve bu classın diğerleri ile haberleştirdik.
        
        let padding : CGFloat
        let yukseklik : CGFloat
        init(padding : CGFloat , yukseklik : CGFloat){
            self.padding = padding
            self.yukseklik = yukseklik
            super.init(frame: .zero)
            layer.cornerRadius = 25
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: padding, dy: 0) //text e içerden boşluk verme
        }
        override func editingRect(forBounds bounds: CGRect) -> CGRect { //kullanıcı veri girerken  de boşluk bırakmasını sağlayacak.
            return bounds.insetBy(dx: padding, dy: 0)
        }
        
        override var  intrinsicContentSize: CGSize {//textfield larda genişlik yükseklik.
            return .init(width: 0, height: yukseklik)
        }
        
    }


