//
//  ImagePickerManager.swift
//  TestImageGallery
//
//  Created by Alexandr on 5/25/18.
//  Copyright © 2018 Alexandr Zhuk. All rights reserved.
//

import UIKit
import CoreLocation
import Photos

protocol ImagePickerManagerDelegate: class {
    func didSelectImage(image: UIImage, with coordinate: CLLocationCoordinate2D?)
}

class ImagePickerManager: NSObject {

    var containerViewController: UIViewController!

    weak var delegate: ImagePickerManagerDelegate?

    init(containerViewController: UIViewController) {
        super.init()
        self.containerViewController = containerViewController
    }

    func showWithMode(mode: UIImagePickerControllerSourceType) {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = mode
        picker.allowsEditing = true
        picker.delegate = self
        self.containerViewController.present(picker, animated: true)
    }
}

extension ImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        var coordinate: CLLocationCoordinate2D?
        if picker.sourceType == .photoLibrary {
            let imageUrl: NSURL = info[UIImagePickerControllerReferenceURL] as! NSURL
            let fetchedImage = PHAsset.fetchAssets(withALAssetURLs: [imageUrl as URL], options: nil)
            if fetchedImage.count != 0 {
                let imageMetadata: PHAsset = fetchedImage.object(at: 0)
                if let imageLocation = imageMetadata.location {
                    coordinate = imageLocation.coordinate;
                }
            }
        }
        self.delegate?.didSelectImage(image: image, with: coordinate)
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
