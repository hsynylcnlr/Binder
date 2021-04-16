//
//  Bindable.swift
//  Binder
//
//  Created by Macintosh HD on 3.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation

class Bindable<K> {//observerlarımızı bunun içinde oluşturarak daha sade hale getirmeye çalıştık.
    
    var deger : K?{
        didSet{
            gozlemci?(deger)
        }
    }
    
    var gozlemci : ((K?) -> ())?
    
    func degerAta(gozlemci : @escaping (K?) -> ()){
        self.gozlemci = gozlemci
    }
}
