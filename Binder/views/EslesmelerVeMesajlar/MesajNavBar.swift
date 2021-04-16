//
//  MesajNavBar.swift
//  Binder
//
//  Created by Macintosh HD on 21.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation
import UIKit


class MesajNavBar: UIView {
    
    let imgKullaniciProfil = DaireselImageView(genislik: 50, image: #imageLiteral(resourceName: "nathan-anderson-FHiJWoBodrs-unsplash"))
    let lblKullaniciAdi = UILabel(text: "yusf11", font: .systemFont(ofSize: 17))
    
    let btnGeri = UIButton(image:#imageLiteral(resourceName: "geri"), tintColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
    let btnBayrak = UIButton(image: #imageLiteral(resourceName: "bayrak"), tintColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
    
    fileprivate let eslesme : Eslesme //eşleşilen ppler gelsin.
    init(eslesme : Eslesme) {
        self.eslesme = eslesme
        lblKullaniciAdi.text = eslesme.kullaniciAdi
        imgKullaniciProfil.sd_setImage(with: URL(string: eslesme.profilGoruntuUrl))
        super.init(frame: .zero)
        
        backgroundColor = .white
        golgeEkle(opacity: 0.3, yaricap: 10, offset: .init(width: 0, height: 10), renk: .init(white: 0, alpha: 0.5))
        
        let ortaSV = yatayStackViewOlustur(stackViewOlustur(imgKullaniciProfil , lblKullaniciAdi ,spacing: 9 , alignment : .center) ,alignment:.center)
        
        yatayStackViewOlustur(btnGeri , ortaSV , btnBayrak).withMargin(.init(top: 0, left: 15, bottom: 0, right: 15))
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
