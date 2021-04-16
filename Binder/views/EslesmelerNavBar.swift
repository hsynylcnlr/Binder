//
//  EslesmelerNavBar.swift
//  Binder
//
//  Created by Macintosh HD on 20.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation
import UIKit

class EslesmelerNavBar : UIView {
    
    //UzantiUIbutton
    let btnGeri = UIButton(image: UIImage(named: "alev")!, tintColor: .lightGray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        //Uzanti+UIview+stackten olusan parametreli yapıyıçekme
        let imgIkon = UIImageView(image: UIImage(named: "mesaj")?.withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
        imgIkon.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        //UILabeluzanti
        let lblMesajlar = UILabel(text: "Mesajlar", font: .boldSystemFont(ofSize: 21), textColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), textAlignment: .center)
        let lblFeed = UILabel(text: "Feed", font: .boldSystemFont(ofSize: 21), textColor: .gray, textAlignment: .center)
        
        //UzatıUıviewUIstack
        stackViewOlustur(imgIkon.yukseklikAyarla(45),
                         yatayStackViewOlustur(lblMesajlar,lblFeed , distribution: .fillEqually)).padTop(10)
        
        //uzantigolgefonk.
      golgeEkle(opacity: 015, yaricap: 10, offset: .init(width: 0, height: 10), renk: .init(white: 0, alpha: 0.3))
        
       
        addSubview(btnGeri)
       
        btnGeri.anchor(top: safeAreaLayoutGuide.topAnchor, bottom: nil, trailling: nil, leading: leadingAnchor , padding: .init(top: 12, left: 12, bottom: 0, right: 0), boyut: .init(width: 35, height: 35))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
