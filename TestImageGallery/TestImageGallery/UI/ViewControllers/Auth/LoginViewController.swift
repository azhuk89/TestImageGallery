//
//  LoginViewController.swift
//  TestImageGallery
//
//  Created by Alexandr on 5/21/18.
//  Copyright © 2018 Alexandr Zhuk. All rights reserved.
//

import UIKit
import KRProgressHUD

class LoginViewController: BaseViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!

    let kRegistrationSegue = "RegistrationSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginTapped(_ sender: Any) {
        self.doLogin()
    }

    @IBAction func registrationTapped(_ sender: Any) {
        self.doRegistration()
    }

    func doLogin() {
        guard !(self.emailTextField.text?.isEmpty)! && !(self.passwordTextField.text?.isEmpty)!  else {
            self.showError(msg: "Please enter email and password")
            return
        }
        let params: [String : String] = ["email": self.emailTextField.text!, "password": self.passwordTextField.text!]
        KRProgressHUD.show()
        APIManager.sharedManager.login(params: params, completion: { [weak self] (results: Any?, error: NSError?) in
            KRProgressHUD.dismiss()
            if error != nil {
                self?.showError(msg: error?.localizedDescription)
                return
            }
            AppDelegate.sharedDelegate.switchAppToState(state: .main)
        })
    }

    func doRegistration() {
        self.performSegue(withIdentifier: kRegistrationSegue, sender: self)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            self.doLogin()
        }
        return true;
    }
}
