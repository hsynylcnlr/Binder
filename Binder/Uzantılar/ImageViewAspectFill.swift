//
//  ImageViewAspectFill.swift
//  Binder
//
//  Created by Macintosh HD on 19.04.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import Foundation
import UIKit

class ImageViewAspectFill: UIImageView {
    convenience init() {
        self.init(image : nil)
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
}
