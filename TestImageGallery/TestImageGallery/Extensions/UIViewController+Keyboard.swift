//
//  UIViewController+Keyboard.swift
//  TestImageGallery
//
//  Created by Alexandr on 5/21/18.
//  Copyright © 2018 Alexandr Zhuk. All rights reserved.
//

import UIKit

extension UIViewController {
    func prepareKeyboardHiding() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
