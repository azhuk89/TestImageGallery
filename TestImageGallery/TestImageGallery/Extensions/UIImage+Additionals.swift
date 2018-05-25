//
//  UIImage+Additionals.swift
//  TestImageGallery
//
//  Created by Alexandr on 5/22/18.
//  Copyright © 2018 Alexandr Zhuk. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func makeRounded() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.masksToBounds = true
    }
}
