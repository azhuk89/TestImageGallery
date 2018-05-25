//
//  BaseViewController.swift
//  TestImageGallery
//
//  Created by Alexandr on 5/21/18.
//  Copyright © 2018 Alexandr Zhuk. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareKeyboardHiding()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    func showError(msg: String?) {
        self.showAlert(title: "Error", msg: msg!)
    }
}
