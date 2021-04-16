//
//  EslesmeCell.swift
//  Binder
//
//  Created by Macintosh HD on 24.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation
import UIKit


//<buradakitip belirtmektir> Listecellde T tipinde bir veriyi , veri değişkenine atamıştık o veri tipinide burda color olarak atamış olduk generic
class EslesmeCell: ListeCell<Eslesme> {
    
    let imgProfil = UIImageView(image: UIImage(named: "kisi3"),contentMode: .scaleAspectFill)
    let lblKullaniciAdi = UILabel(text: "rıza12", font: .systemFont(ofSize: 15, weight: .bold), textColor: .darkGray, textAlignment: .center, numberOfLines: 2)
    
    
    override var veri: Eslesme! {
        
        didSet{
            lblKullaniciAdi.text = veri.kullaniciAdi
            imgProfil.sd_setImage(with: URL(string: veri.profilGoruntuUrl))
        }
    }
    
    override func viewleriOlustur() {
        super.viewleriOlustur()
        
        imgProfil.clipsToBounds = true
        imgProfil.boyutlandir(.init(width: 80, height: 80))
        imgProfil.layer.cornerRadius = 40
        stackViewOlustur(stackViewOlustur(imgProfil,alignment: .center) , lblKullaniciAdi)
    }
    
}

