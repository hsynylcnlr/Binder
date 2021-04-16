//
//  EslesmeView.swift
//  Binder
//
//  Created by Macintosh HD on 15.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import UIKit
import Firebase

class EslesmeView : UIView {
    
    var gecerliKullanici : Kullanici! //değer atanmak zorunda !
    var profilID : String! {
        
        didSet{
            
            let sorgu = Firestore.firestore().collection("Kullanicilar")
            sorgu.document(profilID).getDocument { (snapshot, hata) in
                
                if let hata = hata {
                    print("Eşleşmesi yapılan profilin bilgilerini getirilemedi : \(hata.localizedDescription)")
                    return
                }
                
                guard let profilVerisi = snapshot?.data() else {return}
                let kullanici = Kullanici(bilgiler: profilVerisi) //karşıdakinin profil.
                
                //karşıdakinin beğenilenin
                guard let url = URL(string: kullanici.goruntuURL1 ?? "") else {return}
                self.imgKarsiProfil.sd_setImage(with: url)
                
                //kayıtlı kullanıcın profili
                guard let gecerliKullaniciGoruntuURL = URL(string: self.gecerliKullanici.goruntuURL1 ?? "") else {return}
                self.imgGecerliKullanici.sd_setImage(with: gecerliKullaniciGoruntuURL, completed: { (_, _, _, _) in
                    
                    self.animasyonlariOlustur() // bütün profil çekme işlemleri tamamlanınca animasyonlar çalışsın
                })
                
                self.lblAciklama.text = "Sen ve \(kullanici.kullaniciAdi ?? "Misafir") karşılıklı\nolarak birbirinizi beğendiiniz." 
                
            }
 
        }
   
    }

    fileprivate let btnGezinmeyiSurdur : UIButton = {
       let btn = GezinmeyiSurdurButonu()
        btn.setTitle(" GEZİNMEYİ SÜRDÜR", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
        
        
    }()

    fileprivate let btnMesajGonder : UIButton = {
        let btn = MesajGonderButonu()
        btn.setTitle("MESAJ GÖNDER", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    fileprivate let imgEslesme : UIImageView = {
       
        let img = UIImageView(image: #imageLiteral(resourceName: "eslesme"))
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    fileprivate let lblAciklama : UILabel = {
       
        let lbl = UILabel()
        lbl.text = "Sen ve karşındaki \n birbirinizi beğendiiniz."
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 21)
        return lbl
    }()
   
    fileprivate let imgGecerliKullanici : UIImageView = {
        
        let img = UIImageView(image: #imageLiteral(resourceName: "nathan-anderson-FHiJWoBodrs-unsplash"))
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.borderWidth = 2
        return img
    }()
    
    
    fileprivate let imgKarsiProfil : UIImageView = {
        
        let img = UIImageView(image: #imageLiteral(resourceName: "seth-doyle-b5ul8TBY0S8-unsplash"))
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.borderWidth = 2
        img.alpha = 0
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        blurEfektEkle()
        duzenleLayout()
        
    }
    
    
    fileprivate func animasyonlariOlustur() {
        
        views.forEach({ $0.alpha = 1})
        
        let aci = 25 * CGFloat.pi / 180
        //burada translation transformu konumu karşıda başlatıcak rotation ile de eğik bir acı verecektir.
        imgGecerliKullanici.transform = CGAffineTransform(rotationAngle: -aci).concatenating(CGAffineTransform(translationX: 220, y: 0))
        
        imgKarsiProfil.transform = CGAffineTransform(rotationAngle: aci).concatenating(CGAffineTransform(translationX: -220, y: 0))
        
        //ekkranın sol ve sağ dışında görünmesin
        btnMesajGonder.transform = CGAffineTransform(translationX: -450, y: 0)
        btnGezinmeyiSurdur.transform = CGAffineTransform(translationX: 450, y: 0)
        
        
        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {
            
            //Animasyon 1 - nesnelerin orjinal konumlarına eğik açıyla  dönmesi.
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                
                self.imgGecerliKullanici.transform = CGAffineTransform(rotationAngle: -aci)
                self.imgKarsiProfil.transform = CGAffineTransform(rotationAngle: aci)
            })
            
            //animasyon 2 orjinal konuma gelince eğik açının düz halini alması
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
                
                self.imgGecerliKullanici.transform = .identity
                self.imgKarsiProfil.transform = .identity
                
            })
            
            
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.9, delay: 0.8, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
            //eski konumuna dön animasyonlu
            
            self.btnMesajGonder.transform = .identity
            self.btnGezinmeyiSurdur.transform = .identity
            
        }) { (_) in
            
        }
      
    }
    
    //bu şekilde yaptık ki işler bittiğinde animasyon çalışması için bug girmesin diye
    
    lazy var views = [
        
        imgEslesme,
        lblAciklama,
        imgGecerliKullanici,
        imgKarsiProfil,
        btnMesajGonder,
        btnGezinmeyiSurdur
    ]
    
    
    fileprivate func duzenleLayout(){
        let goruntuBoyut : CGFloat = 135
        
        views.forEach ({ (v) in
            addSubview(v)
            v.alpha = 0
        })
        
           _ = imgKarsiProfil.anchor(top: nil, bottom: nil, trailling: nil, leading: centerXAnchor , padding: .init(top: 0, left: 15, bottom: 0, right: 0) , boyut: .init(width: goruntuBoyut, height: goruntuBoyut))
        imgKarsiProfil.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imgKarsiProfil.layer.cornerRadius = goruntuBoyut / 2
        
        
        _ = imgGecerliKullanici.anchor(top: nil, bottom: nil, trailling: centerXAnchor, leading: nil , padding: .init(top: 0, left: 0, bottom: 0, right: 15) , boyut: .init(width: goruntuBoyut, height: goruntuBoyut))
        imgGecerliKullanici.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imgGecerliKullanici.layer.cornerRadius = goruntuBoyut / 2
        
        _ = imgEslesme.anchor(top: nil, bottom: lblAciklama.topAnchor, trailling: nil, leading: nil , padding: .init(top: 0, left: 0, bottom: 15, right: 0),boyut: .init(width: 290, height: 80))
            imgEslesme.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        _ = lblAciklama.anchor(top: nil, bottom: imgGecerliKullanici.topAnchor, trailling: trailingAnchor, leading: leadingAnchor , padding: .init(top: 0, left: 0, bottom: 35, right: 0) ,boyut: .init(width: 0, height: 60))
        
        _ = btnMesajGonder.anchor(top: imgGecerliKullanici.bottomAnchor, bottom: nil, trailling: trailingAnchor, leading: leadingAnchor , padding: .init(top: 30, left: 45, bottom: 0, right: 45) ,  boyut: .init(width: 0, height: 60))
        
        _ = btnGezinmeyiSurdur.anchor(top: btnMesajGonder.bottomAnchor, bottom: nil, trailling: btnMesajGonder.trailingAnchor, leading: btnMesajGonder.leadingAnchor , padding: .init(top: 15, left: 0, bottom: 0, right: 0), boyut: .init(width: 0, height: 60))   
    }
    
    
     let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    fileprivate func blurEfektEkle() {
        
        
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureEslesme)))
        addSubview(visualEffectView)
        visualEffectView.doldurSuperView()
        
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
          self.visualEffectView.alpha = 1
        }) { (_) in
            
        }
    }
    
    
    @objc fileprivate func tapGestureEslesme() { //bulanık ekrana tıkladığında ekran kalksın.
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 0 // bunu visualsuz yaparak bulanıklığın ordaki fotoların da yavas yavas yok olmasını sağladık.
        }) { (_) in
              self.removeFromSuperview()
        }
    
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
