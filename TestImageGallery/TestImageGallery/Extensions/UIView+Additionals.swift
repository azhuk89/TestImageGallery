//
//  UIView+Additionals.swift
//  TestImageGallery
//
//  Created by Alexandr on 5/23/18.
//  Copyright © 2018 Alexandr Zhuk. All rights reserved.
//

import UIKit

extension UIView {
    func addBorder() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.darkGray.cgColor
    }
}
