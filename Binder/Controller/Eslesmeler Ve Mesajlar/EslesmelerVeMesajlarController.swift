//
//  EslesmelerVeMesajlarController.swift
//  Binder
//
//  Created by Macintosh HD on 20.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation
import UIKit
import Firebase


struct SonMesaj {
    let mesaj : String
    let kullaniciID : String
    let kullaniciAdi : String
    let goruntuURL : String
    let timestamp : Timestamp
    
    //bu sözlük aracılığıyla son mesajdan yeni bir nesne türetebilicez.
    init(veri : [String : Any]) {
        
        mesaj = veri["Mesaj"] as? String ?? ""
        kullaniciID = veri["kullaniciID"] as? String ?? ""
        kullaniciAdi = veri["KullaniciAdi"] as? String ?? ""
        goruntuURL = veri["GoruntuURL"] as? String ?? ""
        timestamp = veri["Timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
    
}


class SonMesajCell: ListeCell<SonMesaj> {
    
    let imgProfilGoruntu = UIImageView(image: UIImage(imageLiteralResourceName: "kisi3"),contentMode: .scaleAspectFill)
    
    let lblKullaniciAdi = UILabel(text: "Sellim", font: .systemFont(ofSize: 19))
    
    let lblSonMesaj = UILabel(text: "Biz dar sokaklarında dinmeeyen yağmurunda kendimizi bulduk rengine tutulduk aşık olduk", font: .systemFont(ofSize: 16), textColor: .gray , numberOfLines : 2)
    
    
    override func viewleriOlustur() {
        super.viewleriOlustur()
        
        let goruntuBoyut : CGFloat = 100
        imgProfilGoruntu.layer.cornerRadius = goruntuBoyut / 2
        
        yatayStackViewOlustur(imgProfilGoruntu.boyutlandir(.init(width: goruntuBoyut, height: goruntuBoyut)) , stackViewOlustur(lblKullaniciAdi,lblSonMesaj, spacing : 4),spacing :20 , alignment : .center).padLeft(20).padRight(20)
        
        ayracEkle(leadingAnchor: lblKullaniciAdi.leadingAnchor)
        
    }

    override var veri: SonMesaj!{
        didSet {
            
            lblKullaniciAdi.text = veri.kullaniciAdi
            lblSonMesaj.text = veri.mesaj
            imgProfilGoruntu.sd_setImage(with: URL(string: veri.goruntuURL))
            
        }
    }
}



//bu generic tipler birbirlerinden türetilmiştir burdaki tip listeheadefooterakadar haberleşebilir
//bu generic tiplerin türetilme bakımından bağlantıları listecontroller lisstecelin T tipinden türetilmişi U tipide listecelin UIcolor tipi

class EslesmelerVeMesajlarController : ListeHeaderController<SonMesajCell,SonMesaj , EslesmeHeader> , UICollectionViewDelegateFlowLayout{
    //String key ifaadesi mesajlaşılan kişinin kullanıcıID değerini temsil etme
    //value degeri olan sonmesaj degeri ise o kişiyle aramızdaki son mesaj degerleri
    var sonMesajlarSozluk = [String : SonMesaj]()
    fileprivate func sonMesajlariGetir(){
        
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else {return}
        
        //addsnapshotlistener verileri anlık alıyor
        Firestore.firestore().collection("Eslesmeler_Mesajlar").document(gecerliKullaniciID).collection("Son_Mesajlar").addSnapshotListener { (querySnapshot, hata) in
            if let hata = hata {
                print("kullanıcıya ait son mesajlar getirilemedi",hata)
                return
            }
            querySnapshot?.documentChanges.forEach({ (degisiklik) in
                //yeni bir veri eklendiyse veya güncellediyse
                if degisiklik.type == .added || degisiklik.type == .modified{
                    let eklenenSonMesaj = degisiklik.document.data()
                    //self.veriler.append(.init(veri: eklenenSonMesaj))
                    let sonMesaj = SonMesaj(veri: eklenenSonMesaj)
                    self.sonMesajlarSozluk[sonMesaj.kullaniciID] = sonMesaj //eğer güncellenirse yeni veri eklenmeyecek, var olan veri güncellenecek
                
                }
                //bir mesaj kayıtı anlık olarak silinmesi içiin
                if degisiklik.type == .removed {
                    let mesajVerisi = degisiklik.document.data()
                    let silinicekMesaj = SonMesaj(veri: mesajVerisi)
                    self.sonMesajlarSozluk.removeValue(forKey: silinicekMesaj.kullaniciID)
                }
                
            })
            self.verileriSıfırla()
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {//yani bir satırı seçtiğimizde
        let sonMesaj = self.veriler[indexPath.row]
        
        let eslesmeVerisi = [ "kullaniciID" : sonMesaj.kullaniciID,
            "KullaniciAdi" : sonMesaj.kullaniciAdi,
            "ProfilGoruntuUrl" : sonMesaj.goruntuURL
        ]
        
        let eslesme = Eslesme(veri: eslesmeVerisi)
        let mesajController = MesajKayitController(eslesme: eslesme)
        navigationController?.pushViewController(mesajController, animated: true)
         
    }
    
    fileprivate func verileriSıfırla(){
        //veriler boyle yapınca anlık olarak guncellenebilcek.
        let sonMesajlarDizi = Array(sonMesajlarSozluk.values)
        //veriler = sonMesajlarDizi
        //bunu yaparak en son mesajı kim yazdıysa o en üstte görünecektir.
        veriler = sonMesajlarDizi.sorted(by: { (mesaj1, mesaj2) -> Bool in
            return mesaj1.timestamp.compare(mesaj2.timestamp) == .orderedDescending
        })
        collectionView.reloadData()
    }
    
    //hücreler arası boşluk
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //EslesmelerYatayController içerisindeki referans olarak EslesmelerVeMesajlarController atandı
    override func headerAyarla(_ header: EslesmeHeader) {
        
        header.eslesmelerYatayController.rootEslesmelerMesajlarController = self
    }
    //bu metod EslesmelerYatayController da referans aracılığılyla çağıralacak
    func headerEslesmeSecimi(eslesme : Eslesme) {
       // print("secilen esslesme :", eslesme.kullaniciAdi)
        let mesajKC = MesajKayitController(eslesme: eslesme)
        navigationController?.pushViewController(mesajKC, animated: true)
    }
    
    
    // üst tarafta uıview gibi header alanı olşturduk
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return .init(width: view.frame.width, height: 250)
        
    }
    
    
    let navBar = EslesmelerNavBar()
    //hücrenin Boyutunu ayarlar.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: view.frame.width, height: 155)
    }
    
    
    

    override func viewDidLoad() {
       super.viewDidLoad()

        sonMesajlariGetir()
       
        gorunumuOlustur()
    }
    
    func gorunumuOlustur() {
        navBar.btnGeri.addTarget(self, action: #selector(btnGeriPressed), for: .touchUpInside)
        
        collectionView.backgroundColor = .white
        view.addSubview(navBar)
        
        navBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, trailling: view.trailingAnchor, leading: view.leadingAnchor , padding: .init(top: 0, left: 0, bottom: 0, right: 0) , boyut: .init(width: 0, height: 150))
        
        collectionView.contentInset.top = 150
        collectionView.scrollIndicatorInsets.top = 150
        
        
        //ust kısmı kapatmak için
        let statusBarOrtu = UIView(arkaPlanRenk: .white)
        view.addSubview(statusBarOrtu)
        statusBarOrtu.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailling: view.trailingAnchor, leading: view.leadingAnchor)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    @objc fileprivate func btnGeriPressed() {
        //anacontrollerda btnmesaj a pushlandığı için pupla geri dönüş hiyerarşisinden yararlanıyoruz.
        navigationController?.popViewController(animated: true)
    }
    
    
}

