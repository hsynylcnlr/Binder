//
//  MesajGonderButonu.swift
//  Binder
//
//  Created by Macintosh HD on 16.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import UIKit

class MesajGonderButonu : UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
        let gLayer = CAGradientLayer()
        let baslangicRenk = #colorLiteral(red: 0.9490196078, green: 0.1529411765, blue: 0.462745098, alpha: 1)
        let bitisRenk = #colorLiteral(red: 0.9960784314, green: 0.462745098, blue: 0.3294117647, alpha: 1)
        gLayer.colors = [baslangicRenk.cgColor , bitisRenk.cgColor]
        
        gLayer.startPoint = CGPoint(x: 0, y: 0.5) //boyanacak yerin başlangıç yeri.
        gLayer.endPoint = CGPoint(x: 1, y: 0.5)
        //self.layer.addSublayer(gLayer)
        self.layer.insertSublayer(gLayer, at: 0) //şimdi  yazı gözükecektir.
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
        gLayer.frame = rect
    }
    
    
}
