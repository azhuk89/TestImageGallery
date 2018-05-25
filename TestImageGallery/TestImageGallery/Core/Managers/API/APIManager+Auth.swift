//
//  APIManager+Auth.swift
//  TestImageGallery
//
//  Created by Alexandr on 5/23/18.
//  Copyright © 2018 Alexandr Zhuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension APIManager {

    func login(params: [String: String], completion:CompletionBlock?) {
        let apiPath = "\(self.SERVER_URL)/login"
        let tag = REQUEST_TAG.login.rawValue
        self.sendRequest(urlString: apiPath, params: params, completion: { (json, error) in
            if json == nil {
                completion!(nil, error)
                return
            }
            let jsonResult = json as! JSON
            self.token = jsonResult["token"].stringValue
            if self.token?.count != 0 {
                UserStorageManager.setToken(value: self.token!)
            }
            completion!(nil, error)
        }, method: HTTP_METHOD_NAME.post.rawValue, urlEncoding: JSONEncoding.default, requestTag: tag)
    }

    func createUser(params: [String: String], image: UIImage, completion:CompletionBlock?) {
        let apiPath = "\(self.SERVER_URL)/create"
        let tag = REQUEST_TAG.create.rawValue
        self.sendUploadRequest(urlString: apiPath, params: params, image: image, completion: { (json, error) in
            if json == nil {
                completion!(nil, error)
                return
            }
            let jsonResult = json as! JSON
            self.token = jsonResult["token"].stringValue
            if self.token?.count != 0 {
                UserStorageManager.setToken(value: self.token!)
            }
            completion!(nil, error)
        }, requestTag: tag)
    }
}
