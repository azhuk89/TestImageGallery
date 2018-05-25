//
//  UIViewController+Navigation.swift
//  TestImageGallery
//
//  Created by Alexandr on 5/22/18.
//  Copyright © 2018 Alexandr Zhuk. All rights reserved.
//

import UIKit

extension UIViewController {

    func createPlayButton() -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon-play"), for: .normal)
        button.addTarget(self, action:#selector(playTapped(_:)), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        return UIBarButtonItem(customView: button)
    }

    func createAddButton() -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon-add"), for: .normal)
        button.addTarget(self, action:#selector(addTapped(_:)), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        return UIBarButtonItem(customView: button)
    }

    func createLogoutButton() -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon-logout"), for: .normal)
        button.addTarget(self, action:#selector(logoutTapped(_:)), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        return UIBarButtonItem(customView: button)
    }

    func addRightBarButtons(buttons: [UIBarButtonItem]) {
        self.navigationItem.rightBarButtonItems = buttons
    }

    func addDoneButton() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon-done"), for: .normal)
        button.addTarget(self, action:#selector(doneTapped(_:)), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }

    func addBackButton() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon-back"), for: .normal)
        button.addTarget(self, action:#selector(backTapped(_:)), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }

    @objc func playTapped(_ sender: UIButton) {

    }

    @objc func addTapped(_ sender: UIButton) {

    }

    @objc func logoutTapped(_ sender: UIButton) {

    }

    @objc func doneTapped(_ sender: UIButton) {

    }

    @objc func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
