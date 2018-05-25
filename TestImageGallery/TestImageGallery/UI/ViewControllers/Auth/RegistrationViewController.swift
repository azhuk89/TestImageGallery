//
//  RegistrationViewController.swift
//  TestImageGallery
//
//  Created by Alexandr on 5/21/18.
//  Copyright © 2018 Alexandr Zhuk. All rights reserved.
//

import UIKit
import KRProgressHUD
import CoreLocation

class RegistrationViewController: BaseViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var selectAvatarButton: UIButton!

    var selectedAvatarImage:UIImage?
    var pickerManager:ImagePickerManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.avatarImageView.makeRounded()
        self.addBackButton()
        self.pickerManager = ImagePickerManager(containerViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func doSignUp() {
        guard self.emailTextField.text != nil && self.passwordTextField.text != nil && self.selectedAvatarImage != nil else {
            self.showError(msg: "Please select an avatar and enter email and password")
            return
        }
        var params: [String : String] = ["email": self.emailTextField.text!, "password": self.passwordTextField.text!]
        if self.usernameTextField.text?.count != 0 {
            params["username"] = self.usernameTextField.text
        }
        KRProgressHUD.show()
        APIManager.sharedManager.createUser(params: params, image: self.selectedAvatarImage!, completion: { [weak self] (results: Any?, error: NSError?) in
            KRProgressHUD.dismiss()
            if error != nil {
                self?.showError(msg: error?.localizedDescription)
                return
            }
            AppDelegate.sharedDelegate.switchAppToState(state: .main)
        })
    }

    func showAvatarActionsAlert() {
        let alertVC = UIAlertController(title: "Select avatar", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        let albumsAction = UIAlertAction(title: "Take from albums", style: UIAlertActionStyle.default) { (action) in
            self.showImagePicker(mode: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Capture from camera", style: UIAlertActionStyle.default) { (action) in
            self.showImagePicker(mode: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        alertVC.addAction(albumsAction)
        alertVC.addAction(cameraAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true)
    }

    func showImagePicker(mode: UIImagePickerControllerSourceType) {
        self.pickerManager.delegate = self
        self.pickerManager.showWithMode(mode: mode)
    }

    @IBAction func signUpTapped(_ sender: Any) {
        self.doSignUp()
    }
    
    @IBAction func selectAvatarTapped(_ sender: Any) {
        self.showAvatarActionsAlert()
    }
}

extension RegistrationViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.usernameTextField {
            self.emailTextField.becomeFirstResponder()
        } else if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            self.doSignUp()
        }
        return true;
    }
}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.avatarImageView.image = image
        self.selectedAvatarImage = image
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension RegistrationViewController: ImagePickerManagerDelegate {
    func didSelectImage(image: UIImage, with coordinate: CLLocationCoordinate2D?) {
        self.avatarImageView.image = image
        self.selectedAvatarImage = image
    }
}
