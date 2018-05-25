//
//  AddImageViewController.swift
//  TestImageGallery
//
//  Created by Alexandr on 5/22/18.
//  Copyright © 2018 Alexandr Zhuk. All rights reserved.
//

import UIKit
import Foundation
import KRProgressHUD
import Photos

class AddImageViewController: BaseViewController {

    @IBOutlet weak var addedImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var tagTextField: UITextField!

    var addedImage: UIImage?
    var addedImageCoordinate: CLLocationCoordinate2D?
    var pickerManager:ImagePickerManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descTextField.delegate = self
        self.tagTextField.delegate = self
        self.addDoneButton()
        self.addBackButton()
        self.pickerManager = ImagePickerManager(containerViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppLocationManager.sharedManager.ascPermision()
    }

    func doSave() {
        guard self.addedImage != nil else {
            self.showError(msg: "Please select an image")
            return
        }
        var params: [String : String] = ["latitude": String(self.addedImageCoordinate?.latitude ?? 0.0), "longitude": String(self.addedImageCoordinate?.longitude ?? 0.0)]
        if self.descTextField.text?.count != 0 {
            params["description"] = self.descTextField.text
        }
        if self.tagTextField.text?.count != 0 {
            params["hashtag"] = self.tagTextField.text
        }
        KRProgressHUD.show()
        APIManager.sharedManager.addImage(params: params, image: self.addedImage!, completion: { [weak self] (results: Any?, error: NSError?) in
            KRProgressHUD.dismiss()
            if error != nil {
                self?.showError(msg: error?.localizedDescription)
                return
            }
            self?.navigationController?.popViewController(animated: true)
        })
    }

    func showSelectImageActionsAlert() {
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

    override func doneTapped(_ sender: UIButton) {
        self.doSave()
    }

    @IBAction func addImageTapped(_ sender: Any) {
        self.showSelectImageActionsAlert()
    }
}

extension AddImageViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.descTextField {
            self.tagTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true;
    }
}

extension AddImageViewController: ImagePickerManagerDelegate {
    func didSelectImage(image: UIImage, with coordinate: CLLocationCoordinate2D?) {
        self.addedImageView.image = image
        self.addedImage = image
        self.addedImageCoordinate = coordinate

        if self.addedImageCoordinate == nil {
            if let location = AppLocationManager.sharedManager.currentLocation() {
                self.addedImageCoordinate = location.coordinate
            }
        }
        if self.addedImageCoordinate == nil {
            self.addedImageCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
    }
}
