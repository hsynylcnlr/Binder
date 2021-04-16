//
//  MesajCell.swift
//  Binder
//
//  Created by Macintosh HD on 24.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation
import UIKit

class MesajCell: ListeCell<Mesaj> {
    
    
    let mesajContainer = UIView(arkaPlanRenk: #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1))
    //gönderilen veya alınan mesajı tutar - gösterir
    let txtMesaj : UITextView = {
        
        let txt = UITextView()
        txt.backgroundColor = .clear
        txt.font = .systemFont(ofSize : 20)
        txt.isScrollEnabled = false
        txt.isEditable = false //scrooll ve düzenleme mesaj içeriğinde aktif olmasın
        return txt
        
    }()
    override var veri: Mesaj! {
        didSet{
            
            txtMesaj.text = veri.mesaj
            
            //mesaj benimse sağ tarafta gözükücek
            
            if veri.benimMesajim {
                mesajConstraint.trailling?.isActive = true
                mesajConstraint.leading?.isActive = false
                mesajContainer.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                txtMesaj.textColor = .white
            }else {
                mesajConstraint.trailling?.isActive = false
                mesajConstraint.leading?.isActive = true
                mesajContainer.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
                txtMesaj.textColor = .black
            }
            
        }
    }
    var mesajConstraint : AnchorConstraint!
    override func viewleriOlustur() {
        super.viewleriOlustur()
        
        addSubview(mesajContainer)
        mesajContainer.layer.cornerRadius = 15
        mesajConstraint = mesajContainer.anchor(top: topAnchor, bottom: bottomAnchor, trailling: trailingAnchor, leading: leadingAnchor)
        mesajConstraint.leading?.constant = 20
        mesajConstraint.trailling?.isActive = false
        
        //sağ tarafta mesaj kutucukların görüntüsü
        mesajConstraint.trailling?.constant = -20
        
        
        //maksimum 260 genişliğinde ol ama hücre texti kısaysa da kısalabilirsin.
        mesajContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 260).isActive = true
        //mesajın olduğu kısım kadar hücreyi o renge doldur
        mesajContainer.addSubview(txtMesaj)
        txtMesaj.doldurSuperView(padding: .init(top: 5, left: 13, bottom: 5, right: 13))
    }
}
