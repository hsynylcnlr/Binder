//
//  kullanici.swift
//  Binder
//
//  Created by Macintosh HD on 21.03.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import UIKit
struct Kullanici : ProfilViewModelOlustur{
    var kullaniciAdi : String?
    var meslek : String?
    var yasi : Int?
    //let goruntuAdlari : [String]
    
     var goruntuURL1 : String?
     var goruntuURL2 : String?
     var goruntuURL3 : String?
    
    var kullaniciID : String
    var arananMinYas : Int?
    var arananMaksYas : Int?
    
    init(bilgiler :[String : Any]){
        self.kullaniciAdi = bilgiler["AdiSoyadi"] as? String ?? ""
        self.yasi = bilgiler["Yasi"] as? Int
        self.meslek = bilgiler["Meslek"] as? String
        
        self.goruntuURL1 = bilgiler["GoruntuURL"] as? String
        self.goruntuURL2 = bilgiler["GoruntuURL2"] as? String
        self.goruntuURL3 = bilgiler["GoruntuURL3"] as? String
        self.kullaniciID = bilgiler["kullaniciID"] as? String ?? ""
        
        self.arananMinYas = bilgiler["ArananMinYas"] as? Int
        self.arananMaksYas = bilgiler["ArananMaksYas"] as? Int
        
    }
    
    
    
    func kullaniciProfilViewModelOlustur() -> KullaniciProfilViewModel {
        
        let attrText = NSMutableAttributedString(string: kullaniciAdi ?? "", attributes: [.font : UIFont.systemFont(ofSize: 30 , weight: .heavy)])
        
        let yasStr = yasi != nil ? "\(yasi!)" : "**"
        
        
        attrText.append(NSAttributedString(string: " \(yasStr)", attributes: [.font : UIFont.systemFont(ofSize: 23 , weight: .regular)]))
        
        let meslekStr = meslek != nil ? "\(meslek!)" : "**"
        
        attrText.append(NSAttributedString(string: "\n\(meslekStr)", attributes: [.font : UIFont.systemFont(ofSize: 20 , weight: .regular)]))
        
        var goruntulerURL = [String]()
        //profildeki 3 fotografıda istedik boşdeğil ise bunları getir.
        if let url = goruntuURL1 ,  !url.isEmpty {goruntulerURL.append(url)}
        if let url = goruntuURL2 ,  !url.isEmpty {goruntulerURL.append(url)}
        if let url = goruntuURL3 ,  !url.isEmpty {goruntulerURL.append(url)}
        
        return KullaniciProfilViewModel(attrString: attrText, goruntuAdlari: goruntulerURL, bilgiKonumu: .left , kullaniciID: self.kullaniciID)
    }

}
