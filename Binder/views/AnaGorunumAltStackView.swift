//
//  AnaGorunumAltStackView.swift
//  Binder
//
//  Created by Macintosh HD on 13.03.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import UIKit

class AnaGorunumAltStackView: UIStackView {

    static func butonOlustur(image: UIImage) -> UIButton {
        
        let btn = UIButton(type: .system)
        btn.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        return btn
    }
   
    let btnYenile = butonOlustur(image: #imageLiteral(resourceName: "yenile"))
    let btnKapat = butonOlustur(image: #imageLiteral(resourceName: "kapat"))
    let btnSuperLike = butonOlustur(image: #imageLiteral(resourceName: "superLike"))
    let btnBegen = butonOlustur(image: #imageLiteral(resourceName: "like"))
    let btnBoost = butonOlustur(image: #imageLiteral(resourceName: "boost"))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    
        [btnYenile,btnKapat,btnSuperLike,btnBegen,btnBoost].forEach { (buton) in
            self.addArrangedSubview(buton)
        }
        
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder) eklenmedi")
    }
    

}
