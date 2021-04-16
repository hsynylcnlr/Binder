//
//  OturumViewModel.swift
//  Binder
//
//  Created by Macintosh HD on 10.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation
import Firebase

class OturumViewModel {
    
    var oturumAciliyor = Bindable<Bool>()
    var formGecerli = Bindable<Bool>()
    
    
    var emailAdresi : String? { //didsete bir değer atandığında çalışacak boş olup olmadıgı konusunda
        
        didSet {
            formGecerliKontrol()
        }
        
    }
    
    var parola : String? {
        
        didSet {
            formGecerliKontrol()
        }
        
    }
    
    //eger email ve parolada boş ise form geçerlliiği degeri false olcaktır.
    fileprivate func formGecerliKontrol() {
        let gecerli = emailAdresi?.isEmpty == false && parola?.isEmpty == false
        formGecerli.deger = gecerli
        
    }
    
    func oturumAc(completion : @escaping (Error?) -> ()) {
        //girilmiş bulunmaktaysa oturumaçılma işlemi başlasın.
        guard let emailAdresi = emailAdresi , let parola = parola else {return}
        
        oturumAciliyor.deger = true
        Auth.auth().signIn(withEmail: emailAdresi, password: parola) {(sonuc , hata) in
            completion(hata)
        }
        
    }
    
}
