//
//  KullaniciDetaylariController.swift
//  Binder
//
//  Created by Macintosh HD on 11.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import UIKit

class KullaniciDetaylariController: UIViewController {

    
    var kullaniciViewModel : KullaniciProfilViewModel! { //kesinlikle bir değer alması gerekiyor
        
        didSet{ //detaylar sayfasına bulunan kullanıcı profilindeki fotoğraf ve bilgiler aktarılma işlemi
            lblBilgi.attributedText =  kullaniciViewModel.attrString
            
            //fotogeciste oluşturduğumuz kllancıviewmodel //kullanıcıprofilviewden bilgileri çeken
            fotoGecisController.kullaniciViewModel = kullaniciViewModel
        }
        
    }
    
    lazy var scrollView : UIScrollView = {
       
        let sv = UIScrollView()
       
        sv.alwaysBounceVertical = true //dikeyde git gelsr
        sv.contentInsetAdjustmentBehavior = .never //asla fotonun hiçbirşeyi bozulmasın
        
        sv.delegate = self
        
        return sv
    }()
    
    //foto geçişte fotolar sağ ve sola kaydırılarak geçilmektedir. //fotocontrollera bağlanarak  zaten false trueda is tıklanarak geçilmektedir.
    let fotoGecisController = FotoGecisController()
    
    
//    let imgProfil : UIImageView = {
//
//        let img = UIImageView(image: #imageLiteral(resourceName: "kobe4"))
//        img.contentMode = .scaleAspectFill
//        img.clipsToBounds = true
//        return img
//    }()
    
    let lblBilgi : UILabel = {
        
        let lbl = UILabel()
        
        lbl.text = "Kobe Bryant 40 \nProfesyonel Basketbolcu\n"
        lbl.numberOfLines = 0
        return lbl
        
    }()
    
    let btnDetayKapat : UIButton = {
        
        let buton = UIButton(type: .system)
        buton.setImage(UIImage(named: "profilKapat")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        buton.addTarget(self, action: #selector(tapGestureKapat), for: .touchUpInside)
        
        return buton
    }()
    
    //sınırlar ve constraintler değişmeden önce çalışır burada sınırlar deeğiştiği için bu fonksiyon tetikleniyor.
    //sınırlar fotogeçiccontrollerdan aldığımız fotolar buradaki sınırları değiştirmiştir.
    fileprivate let ekYukseklik : CGFloat = 90
    override func viewWillLayoutSubviews() {
        
        let fotoGecisView = fotoGecisController.view!
        fotoGecisView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + ekYukseklik)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

      view.backgroundColor = .white
        
        layoutDuzenle()
        blurEfektOlustur()
        altButonlarKonumAyarla()
    }
    
    fileprivate func butonOlustur(image :UIImage, selector : Selector) -> UIButton {
        let buton = UIButton(type: .system)
        
        buton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        buton.addTarget(self, action: selector, for: .touchUpInside)
        buton.imageView?.contentMode = .scaleAspectFill
        
        return buton
    }
    
    lazy var btnDislike = self.butonOlustur(image: UIImage(named: "kapat")!, selector: #selector(btnDislikePressed))
    
    lazy var btnSuperlike = self.butonOlustur(image: UIImage(named: "superLike")!, selector: #selector(btnSuperlikePressed))
    
    lazy var btnlike = self.butonOlustur(image: UIImage(named: "like")!, selector: #selector(btnlikePressed))
    
    @objc fileprivate func btnDislikePressed() {
        
    }
    
    @objc fileprivate func btnSuperlikePressed() {
        
    }
    
    @objc fileprivate func btnlikePressed() {
        
    }
    
    
    fileprivate func altButonlarKonumAyarla() {
        
        let sv = UIStackView(arrangedSubviews: [btnDislike ,btnSuperlike , btnlike ])
        sv.distribution = .fillEqually
        
        view.addSubview(sv)
        
        _ = sv.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailling: nil, leading: nil , padding: .init(top: 0, left: 0, bottom: 0, right: 0 ), boyut: .init(width: 310, height: 85))
        
        sv.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    
    
    fileprivate func blurEfektOlustur() { //image in en üstünde safearea kısmını bulanık yapma
        
        let blurEffect = UIBlurEffect(style: .regular)
        let effecktView = UIVisualEffectView(effect: blurEffect)
        
        view.addSubview(effecktView)
        _ = effecktView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailling: view.trailingAnchor, leading: view.leadingAnchor)
        
    }
    
    fileprivate func layoutDuzenle() {
        view.addSubview(scrollView)
        scrollView.doldurSuperView()
        
        let fotoGecisView = fotoGecisController.view!
        scrollView.addSubview(fotoGecisView)
        fotoGecisView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        
        scrollView.addSubview(lblBilgi)
        
        _ = lblBilgi.anchor(top: fotoGecisView.bottomAnchor, bottom: nil, trailling: scrollView.trailingAnchor
            , leading: scrollView.leadingAnchor , padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        scrollView.addSubview(btnDetayKapat)
        
        _ = btnDetayKapat.anchor(top: fotoGecisView.bottomAnchor, bottom: nil, trailling: view.trailingAnchor, leading: nil , padding: .init(top: -25, left: 0, bottom: 0, right: 20) , boyut: .init(width: 50, height: 50))
    }
    
    
    @objc fileprivate func tapGestureKapat(){
        
        self.dismiss(animated: true)
    }

    

}

extension KullaniciDetaylariController : UIScrollViewDelegate {
    //detaylar sayfasındaki imgnin aşağı ve yukarı hareketlerindeki değişim
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yFark  = scrollView.contentOffset.y
        print("Y  Fark",yFark)
        
        var width = view.frame.width - 2*yFark
        width = max(view.frame.width, width)
        
        let fotoGecisView = fotoGecisController.view!
        fotoGecisView.frame = CGRect(x: min(0,yFark), y: min(0,yFark), width: width, height: width + ekYukseklik)
        
    }
    
    
}
