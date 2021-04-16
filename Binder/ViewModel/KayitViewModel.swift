//
//  KayitViewModel.swift
//  Binder
//
//  Created by Macintosh HD on 1.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import UIKit
import Firebase

class KayitViewModel {
    
    var bindableKayitOluyor = Bindable<Bool>()
    var bindableKayitVerileriGecerli = Bindable<Bool>() //bundibleda otomatik observer yapısı kullanılarak sade halde oluşturudk.
    var bindableImg = Bindable<UIImage>()
    
    var emailAdresi : String?{
        didSet{
            veriGecerliKontrol()
        }
    }
    
    var adiSoyadi : String?{
        didSet{
            veriGecerliKontrol()
        }
    }
    var parola : String?{
        didSet{
            veriGecerliKontrol()
        }
    }
    
  func veriGecerliKontrol() {//boş değilse kayıtolgeçerli
        let gecerli = emailAdresi?.isEmpty == false && adiSoyadi?.isEmpty == false && parola?.isEmpty == false && bindableImg.deger != nil
        bindableKayitVerileriGecerli.deger = gecerli
    }
    
    func kullaniciKayitGerceklestir(completion : @escaping (Error?) -> ()) {
        
        guard let emailAdresi = emailAdresi , let parola = parola else {return}
        bindableKayitOluyor.deger = true
        
        Auth.auth().createUser(withEmail: emailAdresi, password: parola) { (sonuc, hata) in
            
            if let hata = hata {
                print("Kullanıcı kayıt olurken hata meydana geldi : \(hata.localizedDescription)")
                completion(hata)
                return
            }
            
            print("Kullanıcı kaydı başarılı kullanıcı ıd : \(sonuc?.user.uid ?? "Bulunamadı")")
            
            self.goruntuFirebaseKaydet(completion: completion)
            
            
        }
        
    }
  
    fileprivate func goruntuFirebaseKaydet(completion : @escaping (Error?) -> ()){
        //profil goruntuyu firestorea dosya şeklinde kaydetmek
        let goruntuAdi = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/Goruntuler/\(goruntuAdi)")
        let goruntuData = self.bindableImg.deger?.jpegData(compressionQuality: 0.8) ?? Data()
        ref.putData(goruntuData, metadata: nil) { (_, hata) in
            
            if let hata = hata {
                completion(hata)
                return
            }
            print("Görüntü başarıyla upload edildi.")
            
            ref.downloadURL {(url , hata) in
                if let hata = hata {
                    completion(hata)
                    return
                }
                
                self.bindableKayitOluyor.deger = false
                print("Görüntü Url : \(url?.absoluteString ?? "")")
                
                let goruntuURL = url?.absoluteString ?? ""
                self.kullaniciBilgileriniFireStoreKaydet(goruntuURL: goruntuURL, completion: completion)
                
            }
        }
    }
    
    fileprivate func kullaniciBilgileriniFireStoreKaydet(goruntuURL : String , completion : @escaping (Error?) -> ()) {
        //firesbasede database e verileri kaydetme.
        let kullaniciID = Auth.auth().currentUser?.uid ?? ""
        
        let eklenecekVeri = ["AdiSoyadi" : adiSoyadi ?? "",
                             "GoruntuURL" : goruntuURL,
                             "kullaniciID" : kullaniciID ,
                             "Yas"      : 18 ,
                            "ArananMinYas" : AyarlarController.varsayilanArananMinYas,
                            "ArananMaksYas" : AyarlarController.varsayilanArananMaksYas
            ] as [String : Any]
        
        Firestore.firestore().collection("Kullanicilar").document(kullaniciID).setData(eklenecekVeri) { (hata) in
            
            if let hata = hata {
                completion(hata)
                return
            }
            completion(nil)
        }
    }
    
}
