//
//  KullaniciProfilViewModel.swift
//  Binder
//
//  Created by Macintosh HD on 22.03.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import UIKit


class KullaniciProfilViewModel {
    
    let kullaniciID : String
    let attrString : NSAttributedString
    let goruntuAdlari : [String]
    let bilgiKonumu : NSTextAlignment
 
    init(attrString : NSAttributedString, goruntuAdlari : [String] , bilgiKonumu : NSTextAlignment , kullaniciID : String ) {
        self.attrString = attrString
        self.goruntuAdlari = goruntuAdlari
        self.bilgiKonumu = bilgiKonumu
        self.kullaniciID = kullaniciID
    }
    
    fileprivate var goruntuIndex = 0 {
        didSet {
            let goruntuURL = goruntuAdlari[goruntuIndex]
          goruntuIndexGozlemci?(goruntuIndex , goruntuURL)
        }
        
    }

    var goruntuIndexGozlemci : ( (Int ,String?) -> () )?
    
    func sonrakiGoruntuyeGit() {
        //bir sonraki fotoya geçsin eger index goruntusayısından büyükse ilk elemana dönsün degilse bir arttırsın.
        goruntuIndex = goruntuIndex + 1 >= goruntuAdlari.count ? 0 : goruntuIndex + 1
    }
    func oncekiGoruntuyeGit() {
        //degilse bir önceki fotoya geç. eger önceki foto 0 ın altına gelirse elemanı en son elemana getir.
        goruntuIndex = goruntuIndex - 1 < 0 ? goruntuAdlari.count - 1 : goruntuIndex - 1
    }
    
}


protocol ProfilViewModelOlustur {
    func kullaniciProfilViewModelOlustur() -> KullaniciProfilViewModel 
    
    
}
