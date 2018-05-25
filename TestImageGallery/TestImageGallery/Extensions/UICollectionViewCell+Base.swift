//
//  UICollectionViewCell+Base.swift
//  TestImageGallery
//
//  Created by Alexandr on 5/23/18.
//  Copyright © 2018 Alexandr Zhuk. All rights reserved.
//

import UIKit

extension UICollectionViewCell {

    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
