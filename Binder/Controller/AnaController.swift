//
//  ViewController.swift
//  Binder
//
//  Created by Macintosh HD on 12.03.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class AnaController: UIViewController {
    
    
    let ustStackView = AnaGorunumUstStackView()
    let profilDiziniView = UIView()
     let altButonlarStackView = AnaGorunumAltStackView()
    
    var kullanicilarProfilViewModel = [KullaniciProfilViewModel]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.navigationBar.isHidden = true //üstekibarıyoketme tek ekran gözüksün
        ustStackView.btnMesaj.addTarget(self, action: #selector(btnMesajlarPressed), for: .touchUpInside)
        ustStackView.btnAyarlar.addTarget(self, action: #selector(btnAyarlarPressed), for: .touchUpInside)
        altButonlarStackView.btnYenile.addTarget(self, action: #selector(btnYenilePressed), for: .touchUpInside)
        altButonlarStackView.btnBegen.addTarget(self, action: #selector(btnBegenPressed), for: .touchUpInside)
        altButonlarStackView.btnKapat.addTarget(self, action: #selector(btnKapatPressed), for: .touchUpInside)
        
        layoutDuzenle()
  
       gecerliKullaniciyiGetir()
    }
    
    @objc fileprivate func btnMesajlarPressed() {
            let viewController = EslesmelerVeMesajlarController()
            navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    //didappear işlem bittikten sonraki hamledir.
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
    
        if Auth.auth().currentUser == nil { //eger kullanıcı yoksa KAyit sayfasına gitsin
           
            let kayitController = KayitController()
            kayitController.delegate = self
            
            let navController = UINavigationController(rootViewController: kayitController)
            navController.modalPresentationStyle = .fullScreen
            
            present(navController , animated: true)
        }
        
        
    }
    
    
    fileprivate var gecerliKullanici : Kullanici?
    
    fileprivate func gecerliKullaniciyiGetir() {
        
        // yas aralıkları kaydedildikten sonra profiller üstüste bindiğinden profilleri temizler.
        profilDiziniView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        //UzantiFirebase
        Firestore.firestore().gecerliKullaniciyiGetir { (kullanici, hata) in
            if let hata = hata {
              print("Oturum açan kullanıcıların bilgileri getirilirken hata meydana geldi : \(hata)")
                  return
            }
            self.gecerliKullanici = kullanici
            //self.kullanicilariGetirFS()
            self.gecisleriGetir()    //oturum acan kullanıcının eşleşilen kullanıcılar getirilmesinde diğer kullanıcılar gelsin
        }
        
    }
    
    var gecisVerileri = [String : Int]()
    fileprivate func gecisleriGetir(){
        
        guard let kullaniciID = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("Gecisler").document(kullaniciID).getDocument { (snapshot, hata) in
            if let hata = hata {
                print("oturum açmış kullanıcının geçişverileri getirilirken hata oluştu : \(hata.localizedDescription)")
                return
            }
            print("Geçiş Verisi:\n",snapshot?.data() ?? "")
            
            guard let gecisVerisi = snapshot?.data() as? [String : Int] else {
                //kullanıcı verilerinin içindeki veriler profiller silindiğinde boş ekran olarak buraya düşüyor.
                //oyüzden eşleşmelerin hepsi silindiği zaman profillerin yeniden getirilmesi gerekiyor
                self.gecisVerileri.removeAll() //eğer firebasedan falan veri kalmışsa onlarda silinsin.
                self.kullanicilariGetirFS()
                return}
            self.gecisVerileri = gecisVerisi
            self.kullanicilariGetirFS()
            
        }
    }
    
    
    var sonGetirilenKullanici : Kullanici?
    
    fileprivate func kullanicilariGetirFS() { //firestoredaki kullanıcıları bilgilerini getir.
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Profiller Getiriliyor"
        hud.show(in: view)
    
        let arananMinYas = gecerliKullanici?.arananMinYas ?? AyarlarController.varsayilanArananMinYas
        let arananMaksYas = gecerliKullanici?.arananMaksYas ?? AyarlarController.varsayilanArananMaksYas
        
        //kaydet butonuyla profiller gelmiyordu bu bagı yaş aralığını seçtikten sonra boş diye getirdik zaten yenilede boşsa hepsini geetiriyordu.
        gorunenEnUstProfilView = nil
        
        
        let sorgu = Firestore.firestore().collection("Kullanicilar")
        
            .whereField("Yasi", isGreaterThanOrEqualTo: arananMinYas)
            .whereField("Yasi", isLessThanOrEqualTo: arananMaksYas)
        
        
        sorgu.getDocuments { (snapshot, hata) in
           
            hud.dismiss()
            
            if let hata = hata {
                print("Kullanıcılar getirilirken hata meydana geldi : \(hata)")
                return
            }
            
            var oncekiProfilView : ProfilView? //linkedlistmantığı
            
            snapshot?.documents.forEach({ (dSnapshot) in
                let kullaniciVeri = dSnapshot.data() //firestoredaki datalar
                let kullanici = Kullanici(bilgiler: kullaniciVeri)
                
                //oluşturduğumuz sözlüğe tüm kullanıcıları atıyor
                self.kullanicilar[kullanici.kullaniciID ?? ""] = kullanici
                
                let gecerliKullaniciMi = kullanici.kullaniciID == Auth.auth().currentUser?.uid //gecerli kullanici oturumu açan kullanıcıya eşitmi
                
             //   let gecisVerisiVarMİ = self.gecisVerileri[kullanici.kullaniciID] != nil //oluşturduğumuz veri bu sözlük içerisinde var
                
               let gecisVerisiVarMİ = false
                
                if !gecerliKullaniciMi && !gecisVerisiVarMİ { //eğer bu veriler true ise false ollmasını oturum açılırken karşıma gelmelerini istemiyorum.
                    
                    let pView = self.kullanicidanProfilOluştur(kullanici: kullanici)
                    
                    if self.gorunenEnUstProfilView == nil { //eger gorunenparametresine deger gelmemisse onu ilk oluşturulan profile ata
                        self.gorunenEnUstProfilView = pView
                    }
                    
                    oncekiProfilView?.sonrakiProfilView = pView //bağlılistemantığı
                    oncekiProfilView = pView
                    
                }
                
               
               
            })
            //self.kullaniciProfilleriAyarlaFireStore()
            
        }
        
    }
    fileprivate func kullanicidanProfilOluştur(kullanici :  Kullanici) -> ProfilView {

        let pView = ProfilView(frame: .zero)
        
        pView.delegate = self
        pView.kullaniciViewModel = kullanici.kullaniciProfilViewModelOlustur()

        profilDiziniView.addSubview(pView)
        profilDiziniView.sendSubviewToBack(pView)//ilk eklenenden sonraki getir sonraki getir devam etsin butonlara basıldığında
        pView.doldurSuperView()
        return pView
    }
    
    
    @objc func btnYenilePressed() { // boş ise getir boş değilse yenileye basıldığında getirme baştan boş olana kadar devam
        profilDiziniView.subviews.forEach  ({ $0.removeFromSuperview()})
         gecerliKullaniciyiGetir() //bunu çalıştırmalıyız eşleştiğimiz kişinin profili gelmemesi için yada dislike
       
    }
    
    @objc func btnAyarlarPressed(){
        
        let ayarlarController = AyarlarController()
        ayarlarController.delegate = self
        let navController = UINavigationController(rootViewController: ayarlarController)
       
        navController.modalPresentationStyle = .fullScreen
        present(navController , animated: true)
   
    }
    
    @objc  func btnKapatPressed() {
        gecisleriKaydetFirestore(begeniDurumu: -1)
        profilGecisAnimasyonu(translation: -800, angle: -18)
        
       
        
    }
    
    fileprivate func gecisleriKaydetFirestore(begeniDurumu : Int) {//beğeni ve dislike firestore
        
        guard let kullaniciID = Auth.auth().currentUser?.uid else {return} //şuanki kullanıcının id si
       
        //kimin profilindeysem karşıdaki kişinin kullanıcı idsi
        guard let profilID = gorunenEnUstProfilView?.kullaniciViewModel.kullaniciID else {return}
        
        let eklenecekVeri = [profilID : begeniDurumu]
        //verinin ekli olup olmadığını nasıl anlarız.
        Firestore.firestore().collection("Gecisler").document(kullaniciID).getDocument { (snapshot, hata) in
            
            if let hata = hata {
                print("Geçiş Verisi Alınamadı  : \(hata.localizedDescription)")
                return
            }
            if snapshot?.exists == true {
                //veri zaten vardır. güncelleyebiliriz.
                
                //ekli ise veri update çalışmalı ekli değilse setdata
                Firestore.firestore().collection("Gecisler").document(kullaniciID).updateData(eklenecekVeri) { (hata) in
                    if let hata = hata {
                        print("Geçiş Verisi Güncellemesi Başarısız : \(hata.localizedDescription)")
                    }
                    print("profil beğeni Güncellendi ")
                    if begeniDurumu == 1 {
                        self.eslesmeKontrol(profilID: profilID)
                    }
                }
            }
            else {
                //böyle bir veri yok veriyi eklemelisin.
                
                //firebasede beğenivedislike geçişleri için geçişler oluşturduk.
                //setdata bir veriyi getirirken ikinci veri gelince öncekini siliyor bunun içinupdate kullanmak gerekir.
                Firestore.firestore().collection("Gecisler").document(kullaniciID).setData(eklenecekVeri) { (hata) in
                    
                    if let hata = hata {
                        print("Geçiş Verisi Kaydı Başarısız : \(hata.localizedDescription)")
                    }
                    print("profil beğeni kaydedildi")
                    if begeniDurumu == 1 {
                        self.eslesmeKontrol(profilID: profilID)
                    }
                }
                
            }
            
        }
        
        
    }
    
    fileprivate func eslesmeKontrol(profilID : String) {
        //eğer iki  kullanıcı birbirlerini beğendi anda eşleştiniz mesajı çıkacaktır.
        print("eşleşme kontrol ediliyor.")
        
        Firestore.firestore().collection("Gecisler").document(profilID).getDocument { (snapshot, hata) in
            
            if let hata = hata {
                print("Beğenilen profilin beğeni bilgileri getirilmedi. \(hata.localizedDescription)")
                return
            }
            
            guard let veri = snapshot?.data() else {return}
            print(veri) //beğenilen kullanıcının beğeni bilgileri
            
            guard let kullaniciID = Auth.auth().currentUser?.uid else {return}
            let eslesmeVarmi = veri[kullaniciID] as? Int == 1
            if eslesmeVarmi{
                print("eslesme var.")
                //eşleşme olunca buraya düşüyor.
                self.getirEslesmeView(profilID: profilID)
                
                //eşleşme varsa eşleşme verileri Firestore a kaydet //mesajlariçin
                //oturum açan kullanıcı için eşleşme verisinin eklenmesi
                guard let eslesilenKullanici = self.kullanicilar[profilID] else {return}
                
                let eklenecekVeri = [   "KullaniciAdi" : eslesilenKullanici.kullaniciAdi ?? "" ,
                                        "ProfilGoruntuUrl": eslesilenKullanici.goruntuURL1 ?? "" ,
                                        "kullaniciID" : profilID,
                                        "Timestamp"  : Timestamp(date: Date())] as [String : Any]
                
                Firestore.firestore().collection("Eslesmeler_Mesajlar").document(kullaniciID).collection("Eslesmeler").document(profilID).setData(eklenecekVeri){(hata) in
                    
                    if let hata = hata {
                        print("Eşleşme Verileri Kaydedilirken Hata Oluştu",hata)
                    }
                }
                
                //Eşleşilen kullanıcı için eşleşme verisinin eklenmesi
                guard let gecerliKullanici = self.gecerliKullanici else {return}
                
                let eklenecekVeri2 = [  "KullaniciAdi" : gecerliKullanici.kullaniciAdi ?? "" ,
                                        "ProfilGoruntuUrl": gecerliKullanici.goruntuURL1 ?? "" ,
                                        "kullaniciID" : gecerliKullanici.kullaniciID,
                                        "Timestamp"  : Timestamp(date: Date())] as [String : Any]
                
                Firestore.firestore().collection("Eslesmeler_Mesajlar").document(profilID).collection("Eslesmeler").document(kullaniciID).setData(eklenecekVeri2) { (hata) in
                    
                    if let hata = hata {
                        print("Eşleşilen Kullanıcının Eşleşme Verisi Kaydedilemedi",hata)
                    }
                }
                
            }
        }
   
    }
    
    fileprivate func getirEslesmeView(profilID : String) {
        
        let eslesmeView = EslesmeView()
        eslesmeView.profilID = profilID
        eslesmeView.gecerliKullanici = gecerliKullanici
        
        view.addSubview(eslesmeView)
        eslesmeView.doldurSuperView()
    }
    
    
    
    var kullanicilar = [String : Kullanici]()
    var gorunenEnUstProfilView : ProfilView? //en üstteki profili tutmamız gereek. linkedlistmantığı
    @objc  func btnBegenPressed() {
       
        gecisleriKaydetFirestore(begeniDurumu: 1)
       profilGecisAnimasyonu(translation: 800, angle: 18)
        
        
        //Bug olduğu için başka animasyon tercih ettik
        // print("sonraki fotoğrafa geç ve profili sıradan çıkar")
        
        //animasyonlu geçiş
//        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
//
//            self.gorunenEnUstProfilView?.frame = CGRect(x: 600, y: 0, width: self.gorunenEnUstProfilView!.frame.width, height: self.gorunenEnUstProfilView!.frame.height)
//
//            //begeni butonuyla fotonun yana doğru açıyla kaybolması
//            let aci = CGFloat.pi * 20 / 180
//            self.gorunenEnUstProfilView?.transform = CGAffineTransform(rotationAngle: aci)
//
//        }) { (_) in
//
//
//            self.gorunenEnUstProfilView?.removeFromSuperview()
//            //bağlı liste mantığı gorunengittiktensonragorunenınbirsonrakiyenigorunen
//            self.gorunenEnUstProfilView = self.gorunenEnUstProfilView?.sonrakiProfilView
//        }
//

    }
    
    fileprivate func profilGecisAnimasyonu(translation : CGFloat , angle : CGFloat) {
        
        let basicAnimation = CABasicAnimation(keyPath: "position.x")
        basicAnimation.toValue = translation
        basicAnimation.duration = 1
        basicAnimation.fillMode = .forwards
        basicAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut) //hızlandırıcı geçiş
        basicAnimation.isRemovedOnCompletion = false
        
        let dondurmeAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        dondurmeAnimation.toValue = CGFloat.pi * angle / 180
        dondurmeAnimation.duration = 1
        
        let ustPView = gorunenEnUstProfilView
        gorunenEnUstProfilView = ustPView?.sonrakiProfilView
        
        CATransaction.setCompletionBlock {
            ustPView?.removeFromSuperview()
            
        }
        
        ustPView?.layer.add(basicAnimation, forKey: "animasyon")
        ustPView?.layer.add(dondurmeAnimation, forKey: "dondurme")
        
        CATransaction.commit()
        
        
    }
    
    
    
    //MARK:- LAYOUT DUZENLEYEN FONKSİYON
    func layoutDuzenle(){
        
        view.backgroundColor = .white
        let genelStackView = UIStackView(arrangedSubviews: [ustStackView,profilDiziniView, altButonlarStackView]) //viewleri sıralamak için
        //stackView.distribution = .fillEqually //viewler esşit biçimde dağılsın.
        genelStackView.axis = .vertical // yanyana değilde viewler alt alta gelicektir.
        
        view.addSubview(genelStackView)
        // stackView.frame = .init(x: 0, y: 0, width: 400, height: 500)
        
        _ = genelStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailling: view.trailingAnchor, leading: view.leadingAnchor)
        genelStackView.isLayoutMarginsRelativeArrangement = true
        genelStackView.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10) //ortadaki gornume sagdan ve soldan boşluklar eklendi.
        
        genelStackView.bringSubviewToFront(profilDiziniView) //hangi view daha önde gözüksün butonların üstünde gözükmesi için fotoların.
    }

    
    func kullaniciProfilleriAyarlaFireStore(){
        
        kullanicilarProfilViewModel.forEach {(kullaniciVM) in
        
            let profilView = ProfilView(frame: .zero)
            
            profilView.kullaniciViewModel = kullaniciVM
            
            profilDiziniView.addSubview(profilView)
            profilView.doldurSuperView()
        }
    }
}
//protocol ile bağlantı bilgilere erişim
extension AnaController : AyarlarControllerDelegate {

    func ayarlarKaydedildi() {
        gecerliKullaniciyiGetir()
    }
}

//protocol
extension AnaController : OturumControllerDelegate {
    
    func oturumAcmaBitis() {
        gecerliKullaniciyiGetir()
    }
    
}

extension AnaController : ProfilViewDelegate {
    
    
    func profiliSiradanCikar(profil: ProfilView) {
        self.gorunenEnUstProfilView?.removeFromSuperview() //profilviewde panbitisle aynı
        self.gorunenEnUstProfilView = self.gorunenEnUstProfilView?.sonrakiProfilView
    }
    
    func detayliBilgiPressed(kullaniciVM: KullaniciProfilViewModel) {
        
        let kullaniciDetaylarController = KullaniciDetaylariController()
        kullaniciDetaylarController.modalPresentationStyle = .fullScreen
        
        kullaniciDetaylarController.kullaniciViewModel = kullaniciVM
        present(kullaniciDetaylarController,animated: true)
    
    
    }

}
