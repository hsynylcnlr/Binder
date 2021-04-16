//
//  EslesmeHeader.swift
//  Binder
//
//  Created by Macintosh HD on 24.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation
import UIKit

class EslesmeHeader: UICollectionReusableView {
    
    let lblYeniEslesmeler = UILabel(text: "Yeni Eşleşmeler", font: .boldSystemFont(ofSize: 19), textColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
    let eslesmelerYatayController = EslesmelerYatayController() //yeni eşleşmeler ile mesajlar arasındaki viewcontrollerkısmı
    let lblMesajlar = UILabel(text: "Mesajlar", font: .boldSystemFont(ofSize: 19), textColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stackViewOlustur(stackViewOlustur(lblYeniEslesmeler).padLeft(22),eslesmelerYatayController.view,stackViewOlustur(lblMesajlar).padLeft(22), spacing : 22).withMargin(.init(top: 22, left: 0, bottom: 5, right: 0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

