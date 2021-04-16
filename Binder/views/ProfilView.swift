//
//  ProfilView.swift
//  Binder
//
//  Created by Macintosh HD on 17.03.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import UIKit
import SDWebImage

class ProfilView: UIView {
    
    
    var sonrakiProfilView : ProfilView?
    var delegate : ProfilViewDelegate?
    
    var kullaniciViewModel : KullaniciProfilViewModel! {
        
        didSet{
            
            fotoGecisController.kullaniciViewModel = kullaniciViewModel
            
        
            lblKullaniciBilgileri.attributedText = kullaniciViewModel.attrString
            lblKullaniciBilgileri.textAlignment = kullaniciViewModel.bilgiKonumu
            
            //ne kadar goruntu varsa okadar da yukarıda küçük barlar gösterilir count kadar. gösterilen görüntü barları beyaz renkte gösterilmeyen gri renkte kalır.
            (0..<kullaniciViewModel.goruntuAdlari.count).forEach {(_) in
                let bView = UIView()
                
                bView.backgroundColor = seciliOlmayanRenk
                goruntuBarStackView.addArrangedSubview(bView)
            }
            
            goruntuBarStackView.arrangedSubviews.first?.backgroundColor = .white
            ayarlaGoruntuIndexGozlemci()

        }
    }
    fileprivate func  ayarlaGoruntuIndexGozlemci() {
        //kullaniciprofilviewmodel ile haberleşerek goruntu geçişlerini tabbara göre arttırma ve azaltma.
        kullaniciViewModel.goruntuIndexGozlemci = { (index , goruntuURL) in
            self.goruntuBarStackView.arrangedSubviews.forEach({ sVİew in
                sVİew.backgroundColor = self.seciliOlmayanRenk
            })
            self.goruntuBarStackView.arrangedSubviews[index].backgroundColor = .white
            
           
        }
    }
    
    //bu parmetreyi true yaptık çünkü true ise fotolar sağ tıkta ileri fotonun soluna tık geri diye hareket edecektir.
    fileprivate let fotoGecisController = FotoGecisController(kullaniciViewModelMi: true)
    
    //fileprivate let imgProfil = UIImageView(image: #imageLiteral(resourceName: "kisi1"))
    fileprivate let gradientLayer = CAGradientLayer()
    let lblKullaniciBilgileri = UILabel()
    fileprivate let sinirDegeri : CGFloat = 120
    
    fileprivate let seciliOlmayanRenk = UIColor(white: 0, alpha: 0.2)
    
    override init(frame: CGRect) {
        super.init(frame: frame )
        
      
      
        duzenleLayout()
        //görüntüyü yakalamak
        let panG = UIPanGestureRecognizer(target: self, action: #selector(profilPanYakala))
        addGestureRecognizer(panG)
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(yakalaTapGesture))
        addGestureRecognizer(tapG)
    }
    
    fileprivate let btnDetayliBilgi : UIButton = {

        let buton = UIButton(type: .system)
        buton.setImage(UIImage(named: "detayliBilgi")?.withRenderingMode(.alwaysOriginal), for: .normal)
        buton.addTarget(self, action: #selector(btnDetayliBilgiPressed), for: .touchUpInside)
        return buton
    }()
    
    @objc fileprivate func btnDetayliBilgiPressed(){
        print("Detay sayfasına gitmelisin.")
        
        delegate?.detayliBilgiPressed(kullaniciVM: kullaniciViewModel)
    }
    
    
    fileprivate func duzenleLayout() {
        
        layer.cornerRadius = 10 //görüntünün köşelrini oval yapmak istersek.
        clipsToBounds = true
        

        let fotoGecisView = fotoGecisController.view! //imgprofille değil fotoları foto geçiş ile alıcazki bug kalksın //40
        addSubview(fotoGecisView)
        fotoGecisView.doldurSuperView()
        
        //olusturBarStackView() fotogecisdekibarstack ile üstüste geldiği için kaldırdık.
        
        
        olusturGradientLayer()
        
        addSubview(lblKullaniciBilgileri)
        _ = lblKullaniciBilgileri.anchor(top: nil,
                                         bottom: bottomAnchor,
                                         trailling: trailingAnchor,
                                         leading: leadingAnchor ,
                                         padding: .init(top: 0, left: 15, bottom: 15, right: 15) )
        
        //lblKullaniciBilgileri.text = "Ahmet 25 inşaat mühendisi"
        lblKullaniciBilgileri.textColor = .white
        lblKullaniciBilgileri.font = UIFont.systemFont(ofSize: 27, weight: .heavy)
        lblKullaniciBilgileri.numberOfLines = 0
        
        addSubview(btnDetayliBilgi)
        _ = btnDetayliBilgi.anchor(top: nil, bottom: bottomAnchor, trailling: trailingAnchor, leading: nil , padding: .init(top: 0, left: 0, bottom: 20, right: 20), boyut: .init(width: 45, height: 45))
    }
    
    var goruntuIndex = 0
    //fotoğrafın tam ortasından sağa tıklanmışsa bir sonraki sola tıklanmışsa bir önceki fotoğrafa gelsin.
    @objc fileprivate func yakalaTapGesture(tapG : UITapGestureRecognizer){
        
        let konum = tapG.location(in: nil)
        
        let sonrakiGoruntuGecis = konum.x > frame.width / 2 ? true : false
        
        if sonrakiGoruntuGecis {
            kullaniciViewModel.sonrakiGoruntuyeGit()
        }
        else {
            kullaniciViewModel.oncekiGoruntuyeGit()
        }
        
        
    }
    
    fileprivate let goruntuBarStackView = UIStackView()
    
    fileprivate func olusturBarStackView() { // fotografın yukarısında küçük bar lar oluşturmak için boyutları
        
        addSubview(goruntuBarStackView)
        
        _ = goruntuBarStackView.anchor(top: topAnchor, bottom: nil, trailling: trailingAnchor, leading: leadingAnchor , padding: .init(top: 8, left: 8, bottom: 0, right: 8) , boyut: .init(width: 0, height: 4))
        
        goruntuBarStackView.spacing = 4
        goruntuBarStackView.distribution = .fillEqually
        
    }
    
  
    fileprivate func olusturGradientLayer() { //fotoğrafa alttan gölge efekti verme

        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        
        gradientLayer.locations = [0.4,1.2]
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
        
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
   
    
    @objc func profilPanYakala(panGesture : UIPanGestureRecognizer){

        switch panGesture.state {
            
        case .began :
            superview?.subviews.forEach({ (subView) in
                subView.layer.removeAllAnimations()
                
            })
            
        case .changed: degisiklikPanYakala(panGesture) //görüntü üzerinde ölçeklendrme yapmakiçin.sürükleme mantığı
            
        case .ended: bitisPanAnimasyon(panGesture)
            
        default:
            break
        }
        
    }
    
    fileprivate func bitisPanAnimasyon(_ panGesture : UIPanGestureRecognizer) {
        //eğer hiçbirşey yapılmıyorsa ve ya sona erdiyse eski haline getir.
        //fotoğraf sürüklendiğiinde sağdan veya soldan yok etmek içn yapılan transform.
        let translationYonu : CGFloat = panGesture.translation(in: nil).x > 0 ? 1 : -1 // bunun yönü 0 dan buyukse 1 eger negatif ise -1 olsun.
        
        let profilKaybet : Bool = abs(panGesture.translation(in: nil).x) > sinirDegeri // eger sürüklenen mutlak deger 120 den buyukse yok olsun olsun.
        
        if profilKaybet {
            guard let anaController = self.delegate as? AnaController else {return}
            
            if translationYonu == 1 {
                anaController.btnBegenPressed()
            } else{
                anaController.btnKapatPressed()
            }
        } else {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                self.transform = .identity //eski haline dönsün
            })
        }
        
        
        
        
//        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
//
//            if profilKaybet {
//
//                self.frame = CGRect(x: 1000 * translationYonu, y: 0, width: self.frame.width, height: self.frame.height)
//
//            }
//            else {
//                 self.transform = .identity //eski haline dönsün
//            }
//
//        }) { (_) in
//
//            self.transform = .identity //eski haline dönsün
//
//            if profilKaybet {
//                self.removeFromSuperview()
//                self.delegate?.profiliSiradanCikar(profil: self) //aynı zamanda begenibutonlarındada haberleşmeli gittimi kaldımı
//            }
//
//            // self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
//        }
    }
    
    fileprivate func degisiklikPanYakala(_ panGesture: UIPanGestureRecognizer) {
        //konum değişiyorsa
        //radyan cinsinden döndürme transformları
       let translation = panGesture.translation(in: nil)
        
        let derece : CGFloat = translation.x / 15
        let radyanAci = (derece * .pi) / 180
        
        let dondurmeTransform = CGAffineTransform(rotationAngle: radyanAci)
        self.transform = dondurmeTransform.translatedBy(x: translation.x, y: translation.y)
        
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been implement ")
    }
    
    
}


protocol ProfilViewDelegate { //AnaControlda
    func profiliSiradanCikar(profil : ProfilView)
    func detayliBilgiPressed(kullaniciVM : KullaniciProfilViewModel)
}
