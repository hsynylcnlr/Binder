//
//  MesajKayitController.swift
//  Binder
//
//  Created by Macintosh HD on 21.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class MesajKayitController: ListeController<MesajCell,Mesaj> {
    
    fileprivate let navBarYukseklik : CGFloat = 125
    fileprivate lazy var navBar = MesajNavBar(eslesme: eslesme) //lazy yaptım alttaki ile aynı hiyerarşide olduğu için mesajnavbarviewvinkini istedim
    fileprivate let eslesme : Eslesme
    
    init(eslesme : Eslesme) {
        self.eslesme = eslesme
        super.init()
    }
    
    class KlavyeView : UIView { //mesaj kısmında klavye etkileşimi text yeri ve gonder butonu
        let txtMesaj = UITextView()
        let btnGonder = UIButton(baslik: "Gönder", baslikRenk: .black, baslikFont: .boldSystemFont(ofSize: 17))
        let lblPlaceHolder = UILabel(text: "Mesajınızı Giriniz...", font: .systemFont(ofSize: 16), textColor: .lightGray )

        override var intrinsicContentSize: CGSize {  //autolayoutmantığı klavyenin constraintlerini ona göre ayarlıyor.s
            return .zero
        }
        override init(frame: CGRect) { //mesaj kısmında klavye etkileşimi text yeri ve gonder butonu
            super.init(frame: frame)
           
            backgroundColor = .white
            golgeEkle(opacity: 0.1, yaricap: 8, offset: .init(width: 0, height: -9), renk: .lightGray)
            autoresizingMask = .flexibleHeight //otomatik olarak alttrafa gerekli yükseklik atamasını yapar.
           
            txtMesaj.isScrollEnabled = false //center dediğim zaman scrol yok olsun textgözüksüns
            txtMesaj.text = ""
            txtMesaj.font = .systemFont(ofSize: 17)
           //gözlemci mantığı bir nesnenin olayını değiştirme yada takip placeholder için yapıoz suan yok olsun text girince
            NotificationCenter.default.addObserver(self, selector: #selector(txtMesajDegisiklik), name: UITextView.textDidChangeNotification, object: nil)
            
            
            btnGonder.boyutlandir(.init(width: 65, height: 65))
            yatayStackViewOlustur(txtMesaj, btnGonder.boyutlandir(.init(width: 65, height: 65 )), alignment: .center).withMargin(.init(top: 0, left: 15, bottom: 0, right: 15))
            
            addSubview(lblPlaceHolder)
            lblPlaceHolder.anchor(top: nil, bottom: nil, trailling: btnGonder.leadingAnchor, leading: leadingAnchor , padding: .init(top: 0, left: 16, bottom: 0, right: 0))
            lblPlaceHolder.centerYAnchor.constraint(equalTo: btnGonder.centerYAnchor).isActive = true
            
        }
        
        deinit {//işlemi tamamladıktan sonra hafızada yer kaplamaması için mutlaka silmemiz gerekiyor observeri
            NotificationCenter.default.removeObserver(self)
        }
        
        @objc fileprivate func txtMesajDegisiklik(){ //placholder değer varsa yok olsun değer yoksa gözüksün
            if txtMesaj.text.count == 0 {
                lblPlaceHolder.isHidden = false
            }
            else {
                lblPlaceHolder.isHidden = true
            }
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    }

    
    lazy var mesajGirisView : KlavyeView = {
        let mesajGirisView = KlavyeView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        
        mesajGirisView.btnGonder.addTarget(self, action: #selector(btnGonderPressed), for: .touchUpInside)
        
        return mesajGirisView
        
    }()
    
    @objc fileprivate func btnGonderPressed(){
        mesajlariKaydetFS()
        sonMesajOlarakKaydetFS()
    }
    
    fileprivate func sonMesajOlarakKaydetFS(){
        
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else { return }
        //oturumu açmış olan kullanıcı için eklenecek son mesaj verisi
        let sonMesajVerisi = [
            "Mesaj" : mesajGirisView.txtMesaj.text ?? "",
            "KullaniciAdi" : eslesme.kullaniciAdi,
            "kullaniciID" : eslesme.kullaniciID,
            "GoruntuURL" : eslesme.profilGoruntuUrl] as [String : Any]
        
        
        Firestore.firestore().collection("Eslesmeler_Mesajlar").document(gecerliKullaniciID).collection("Son_Mesajlar").document(eslesme.kullaniciID).setData(sonMesajVerisi) { (hata) in
            
            if let hata = hata {
                print("Hata! Gönderilen mesaj, son mesaj olarak eklenemedi : ",hata)
                return
            }
            print("Gönderilen mesaj, son mesaj olarak kaydedildi")
        }
        
        //son mesaj verisini mesajlaştığımız karşıdaki kişi için de eklenmesi
        
        guard let gecerliKullanici = self.gecerliKullanici else { return }
        let karsiSonMesajVerisi = [
            "Mesaj" : mesajGirisView.txtMesaj.text ?? "",
            "kullaniciID" : gecerliKullanici.kullaniciID ?? "",
            "KullaniciAdi" : gecerliKullanici.kullaniciAdi ?? "",
            "GoruntuURL" : gecerliKullanici.goruntuURL1 ?? ""
        ]
        
        Firestore.firestore().collection("Eslesmeler_Mesajlar").document(eslesme.kullaniciID).collection("Son_Mesajlar").document(gecerliKullaniciID).setData(karsiSonMesajVerisi) { (hata) in
            
            if let hata = hata {
                print("HATA! Gönderilen mesaj karşıdaki kullanıcı için \"SON MESAJ\" olarak kaydedilemedi : ",hata)
                return
            }
            print("Gönderilen mesaj karşıdaki kullanıcı için \"SON MESAJ\" olarak kaydedildi")
        }
        
    }
    fileprivate func mesajlariKaydetFS() {
        //gonderilen mesajı eşleşilen kullanıcıya gönderme firesotreda tutma
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else {return}
        //1.kişi gibi
        let collection = Firestore.firestore().collection("Eslesmeler_Mesajlar").document(gecerliKullaniciID).collection(eslesme.kullaniciID)
        
        let eklenecekVeri = ["Mesaj" : mesajGirisView.txtMesaj.text ?? "",
                             "GondericiID" : gecerliKullaniciID,
                             "AliciID" : eslesme.kullaniciID,
                             "Timestamp" : Timestamp(date: Date())] as [String : Any]
        
        collection.addDocument(data: eklenecekVeri) { (hata) in
            if let hata = hata {
                print("Mesaj Gonderilirken hata oluştu" ,hata)
                return
            }
            print("Mesaj Başarıyla Firestorea kaydedildi.")
            self.mesajGirisView.txtMesaj.text = nil
            self.mesajGirisView.lblPlaceHolder.isHidden = false
        }
        //2.kişi gibi
        let collection2 = Firestore.firestore().collection("Eslesmeler_Mesajlar").document(eslesme.kullaniciID).collection(gecerliKullaniciID)
        
        collection2.addDocument(data: eklenecekVeri) { (hata) in
            if let hata = hata {
                print("Mesajlar kaydedilirken hata meydana geldi : ",hata)
                return
            }
            
            print("Mesaj Başarıyla Firestorea kaydedildi.")
            self.mesajGirisView.txtMesaj.text = nil
            self.mesajGirisView.lblPlaceHolder.isHidden = false
            
        }
    }
    
    //ilk giriş için tetiklenen view bu view klavyeden veri girilince tetikleniyor mesaj kısmı
    override var inputAccessoryView: UIView? {
        get {
            return mesajGirisView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    var gecerliKullanici : Kullanici?
    fileprivate func gecerliKullaniciyiGetir() {
        
        let gecerliKullaniciId = Auth.auth().currentUser?.uid ?? ""
        
        Firestore.firestore().collection("Kullanicilar").document(gecerliKullaniciId).getDocument { (snapshot, hata) in
            if let hata = hata {
                print("Geçerli kullanıcının bilgileri getirilemedi : ",hata)
                return
            }
            
            let kullaniciVerisi = snapshot?.data() ?? [:]
            self.gecerliKullanici = Kullanici(bilgiler: kullaniciVerisi)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gecerliKullaniciyiGetir()
        //mesajı gönderirken klavye üstte kalıyor gönderilen mesaj görünmüyor
        NotificationCenter.default.addObserver(self, selector: #selector(klavyeGosteriminiAyarla), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        //scroll ile klavye bir etkileşimle çalışıcak scroll aşağı indikçe klavyede ona göre inick
        collectionView.keyboardDismissMode = .interactive
        navBar.btnGeri.addTarget(self, action: #selector(btnGeriPressed), for: .touchUpInside)
        
        mesajlariGetir()

        gorunumuOlustur()
    }
    
    @objc fileprivate func klavyeGosteriminiAyarla(){
        //klavyeyi enson gönderilen mesajın altına konumlandırıcaz.
        self.collectionView.scrollToItem(at: [0,veriler.count-1], at: .bottom, animated: true)
        
        
    }
    
    fileprivate func mesajlariGetir(){//firestoredan mesajları getirmemz gerekşyor
        print("Mesajlar Getiriliyor.")
        
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else {return}
        let sorgu =
            Firestore.firestore().collection("Eslesmeler_Mesajlar").document(gecerliKullaniciID).collection(eslesme.kullaniciID).order(by: "Timestamp")
        
        //veritababnını anlık sürekli dinlemek ve verileri firestoredan anlık görüntülücez
        
        sorgu.addSnapshotListener { (snapshot, hata) in
            if let hata = hata {
                print("Mesajlar Getirilemedi : ", hata)
                return
            }
            snapshot?.documentChanges.forEach({ (degisiklik) in
                
                if degisiklik.type == .added {
                    //değişikliğe uğramış kaydın verisini aldık.
                    let mesajVerisi = degisiklik.document.data()
                    self.veriler.append(.init(mesajVerisi: mesajVerisi))
                }
                
            })
            //veriler dizisine tüm elemanlar kaydedltikten sonra bbunu cağırmalıyız
            self.collectionView.reloadData()
            //anlık olarak son getirilen mesajın altında konumlanacaktır klavye
            self.collectionView.scrollToItem(at: [0,self.veriler.count-1], at: .bottom, animated: true)
        }
        
        
    }
    
 
    fileprivate func gorunumuOlustur() {
        
        view.addSubview(navBar)
        navBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, trailling: view.trailingAnchor, leading: view.leadingAnchor , boyut : .init(width: 0, height: navBarYukseklik))
        
        //collectionview hucrelerini belirtilen boşluktan itibaren oluşturmaya başlar.
        collectionView.contentInset.top = navBarYukseklik
        
        //mesajlar aşağı indikçe üstbaarın arkasından mesajlar görünüyor hoş değil bir beyazviewekleyerek çözeriz.
        let statusBar = UIView(arkaPlanRenk: .white)
        view.addSubview(statusBar)
        statusBar.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailling: view.trailingAnchor, leading: view.leadingAnchor)
        
        //scroll barın başlangıç değerini ayarlayarak görünür yerden başlatma
        collectionView.scrollIndicatorInsets.top = navBarYukseklik
    }
    
    
    @objc fileprivate func btnGeriPressed(){
        
        navigationController?.popViewController(animated: true)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



extension MesajKayitController : UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let tahminiHucre = MesajCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        
        //mesaj içeriğini hücreye aktardık.
        tahminiHucre.veri = self.veriler[indexPath.item]
        
        tahminiHucre.layoutIfNeeded()
        //mesaja göre hücreninin boy ve genişliğini ayarlama
        let tahminiBoyut = tahminiHucre.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        
        return .init(width: view.frame.width, height: tahminiBoyut.height)
    }
    
    //cellerin boşlukatamaaları
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
}

