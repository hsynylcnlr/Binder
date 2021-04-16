//
//  Uzantı+Firestore.swift
//  Binder
//
//  Created by Macintosh HD on 9.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation
import Firebase

extension Firestore {
    
    func gecerliKullaniciyiGetir(completion : @escaping (Kullanici? , Error?) -> ()) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("Kullanicilar").document(uid).getDocument { (snapshot, hata) in
            
            if let hata = hata {
                completion(nil,hata)
                return
            }
            
            guard let bilgiler = snapshot?.data()
                else{
                //kullanıcı yoksa ciddi bir hata mesajı
                let hata = NSError(domain: "com.loodos.Binder", code: 450, userInfo: [NSLocalizedDescriptionKey : "Kullanıcı Bulunamadı"])
                completion(nil,hata)
                return
            }
            let kullanici = Kullanici(bilgiler: bilgiler)
            completion(kullanici,nil)
            
        }
        
    }
    
}
