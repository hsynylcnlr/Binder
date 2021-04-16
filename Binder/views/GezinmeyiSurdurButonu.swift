//
//  GezinmeyiSurdurButonu.swift
//  Binder
//
//  Created by Macintosh HD on 16.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import UIKit

class GezinmeyiSurdurButonu: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
        let gLayer = CAGradientLayer()
        let baslangicRenk = #colorLiteral(red: 0.9490196078, green: 0.1529411765, blue: 0.462745098, alpha: 1)
        let bitisRenk = #colorLiteral(red: 0.9960784314, green: 0.462745098, blue: 0.3294117647, alpha: 1)
        gLayer.colors = [baslangicRenk.cgColor , bitisRenk.cgColor]
        
        gLayer.startPoint = CGPoint(x: 0, y: 0.5) //boyanacak yerin başlangıç yeri.
        gLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let  cornerRad = rect.height / 2
        
        let maskLayer = CAShapeLayer()
        let maskPath = CGMutablePath()
        
        maskPath.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRad).cgPath)
        maskPath.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 3, dy: 3), cornerRadius: cornerRad).cgPath)
        
        maskLayer.fillRule = .evenOdd
        maskLayer.path = maskPath
        
        gLayer.mask = maskLayer
        
        //self.layer.addSublayer(gLayer)
        self.layer.insertSublayer(gLayer, at: 0) //şimdi  yazı gözükecektir.
        layer.cornerRadius = cornerRad
        clipsToBounds = true
        gLayer.frame = rect
    }
    
}
