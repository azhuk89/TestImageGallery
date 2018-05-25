//
//  APIManager+Gallery.swift
//  TestImageGallery
//
//  Created by Alexandr on 5/24/18.
//  Copyright © 2018 Alexandr Zhuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension APIManager {

    func loadImages(completion:CompletionBlock?) {
        let apiPath = "\(self.SERVER_URL)/all"
        let tag = REQUEST_TAG.imageList.rawValue
        self.sendRequest(urlString: apiPath, params: nil, completion: { (json, error) in
            if json == nil {
                completion!(nil, error)
                return
            }
            let jsonResult = json as! JSON
            let images = GalleryItemModel.models(json: jsonResult)
            completion!(images, error)
        }, method: HTTP_METHOD_NAME.get.rawValue, urlEncoding: JSONEncoding.default, requestTag: tag)
    }

    func addImage(params: [String: String]?, image: UIImage, completion:CompletionBlock?) {
        let apiPath = "\(self.SERVER_URL)/image"
        let tag = REQUEST_TAG.addImage.rawValue
        self.sendUploadRequest(urlString: apiPath, params: params, image: image, completion: { (json, error) in
            if json == nil {
                completion!(nil, error)
                return
            }
            completion!(nil, error)
        }, requestTag: tag)
    }

    func loadGIF(params: [String: String]?, completion:CompletionBlock?) {
        let apiPath = "\(self.SERVER_URL)/gif"
        let tag = REQUEST_TAG.loadGIF.rawValue
        self.sendRequest(urlString: apiPath, params: nil, completion: { (json, error) in
            if json == nil {
                completion!(nil, error)
                return
            }
            let jsonResult = json as! JSON
            let gifUrl = jsonResult["gif"].string
            completion!(gifUrl, error)
        }, method: HTTP_METHOD_NAME.get.rawValue, urlEncoding: JSONEncoding.default, requestTag: tag)
    }
}
