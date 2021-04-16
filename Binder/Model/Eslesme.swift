//
//  Eslesme.swift
//  Binder
//
//  Created by Macintosh HD on 24.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation
import UIKit


struct Eslesme {
    let kullaniciAdi : String
    let profilGoruntuUrl : String
    let kullaniciID : String
    
    init(veri : [String : Any]) {
        self.kullaniciAdi = veri["KullaniciAdi"] as? String ?? ""
        self.profilGoruntuUrl = veri["ProfilGoruntuUrl"]  as? String ?? ""
        self.kullaniciID = veri["kullaniciID"] as? String ?? ""
    }
}
