//
//  EslesmelerYatayController.swift
//  Binder
//
//  Created by Macintosh HD on 24.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation
import UIKit
import Firebase

//EslesmelerYatayController da temel amacımız eşleştiiğimiz profillerin listelenmesi
class EslesmelerYatayController: ListeController<EslesmeCell,Eslesme> ,UICollectionViewDelegateFlowLayout {
    
    //Hiyerarşide olan root controllerın referansını tutalım
    var rootEslesmelerMesajlarController : EslesmelerVeMesajlarController?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let eslesme = veriler[indexPath.row]
        rootEslesmelerMesajlarController?.headerEslesmeSecimi(eslesme: eslesme)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets { //yataydaki profillere sağdan soldan boşluk
        return.init(top: 0, left: 5, bottom: 0, right: 15)
    }
    
    
    //listecontrollerdaki eşleşme profillerini boyutlandırrır yamuk gelyordu.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: view.frame.height)
        
    }
    
    fileprivate func eslesmeleriGetir(){
        //oturum açan kullanıcının
        guard let gecerliKullaniciId = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("Eslesmeler_Mesajlar").document(gecerliKullaniciId).collection("Eslesmeler").getDocuments { (snapshot, hata) in
            if let hata = hata {
                print("Eşleşme verileri getirilmedi : ",hata)
            }
            print("Kullanicinin Eslesme Verileri Getirildi:")
            
            var eslesmeler = [Eslesme]()
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let veri = documentSnapshot.data()
                eslesmeler.append(.init(veri: veri))
            })
            self.veriler = eslesmeler
            self.collectionView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //yeni eşleşenleri dikey değilde yatayda scroollu bir şekilde getirmek için.
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        eslesmeleriGetir()//liste controllera cekilen eşleşmeler görüntülenir
      
    }
    
}
