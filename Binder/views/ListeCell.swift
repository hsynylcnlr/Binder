//
//  ListeCell.swift
//  Binder
//
//  Created by Macintosh HD on 19.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation
import UIKit

//public gibidir erişilebilri.
open class ListeCell<T> : UICollectionViewCell {
    
    var veri : T!
    
    var eklenecekController : UIViewController?
    
    public let ayracView = UIView(arkaPlanRenk: UIColor(white: 0.65, alpha: 0.55)) //uzantıdakiUIView
    
    func ayracEkle(solBosluk : CGFloat = 0 ) {
        
        addSubview(ayracView)
        
        ayracView.anchor(top: nil, bottom: bottomAnchor, trailling: trailingAnchor, leading: leadingAnchor , padding: .init(top: 0, left: solBosluk, bottom: 0, right: 0), boyut: .init(width: 0, height: 0.5))
        
    }
    
    //buda farklı bir ayraç ekle metodu dursun.
    func ayracEkle(leadingAnchor : NSLayoutXAxisAnchor) {
        
        addSubview(ayracView)
        ayracView.anchor(top: nil, bottom: bottomAnchor, trailling: trailingAnchor, leading: leadingAnchor , boyut: .init(width: 0, height: 0.5))
        
    }
    
    public override init(frame : CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        //listecontrollerda oluşturulanher bir listecell(eslesmecell) oluşturulduğunda viewleri oluştur metodu çağırılacak.
         viewleriOlustur()
    }
    
    open func viewleriOlustur(){
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
