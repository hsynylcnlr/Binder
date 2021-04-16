//
//  YasAralikCell.swift
//  Binder
//
//  Created by Macintosh HD on 9.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import UIKit

class YasAralikCell: UITableViewCell {
    
    let minSlider : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 90
        return slider
    }()
    
    let maxSlider : UISlider = {
        
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 90
        return slider
    }()
    
    
    //clojer yapısı
    let lblMin : UILabel = {
       
        let lbl = YasAralikLabel()
        lbl.text = "Min 18"
        return lbl
        
    }()
    
    let lblMax : UILabel = {
        
        let lbl = YasAralikLabel()
        lbl.text = "Maks 18"
        return lbl
    }()
    //Label ile text  arası boşluk
    class YasAralikLabel : UILabel {
        override var intrinsicContentSize: CGSize {
            return .init(width: 80, height: 0)
        }
    }
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let genelStackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [lblMin , minSlider]),
            UIStackView(arrangedSubviews: [lblMax , maxSlider])
            ])
        
        genelStackView.axis = .vertical
        genelStackView.spacing = 16
        
        addSubview(genelStackView)
        _ = genelStackView.anchor(top: topAnchor, bottom: bottomAnchor, trailling: trailingAnchor, leading: leadingAnchor , padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}
