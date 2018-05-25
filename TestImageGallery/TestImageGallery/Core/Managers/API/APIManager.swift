//
//  APIManager.swift
//  TestImageGallery
//
//  Created by Alexandr on 5/23/18.
//  Copyright © 2018 Alexandr Zhuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class APIManager: NSObject {

    enum REQUEST_TAG: Int {
        case login = 1, create, imageList, addImage, loadGIF
    }

    enum HTTP_METHOD_NAME: String {
        case get = "GET"
        case post = "POST"
    }

    static let sharedManager = APIManager()
    typealias CompletionBlock = (_ results: Any?, _ error: NSError?) -> Void

    let SERVER_URL = "http://api.doitserver.in.ua"

    var token: String?

    func sendUploadRequest(urlString: String!,
                           params: [String : String]?,
                           image: UIImage,
                           completion: CompletionBlock?,
                           requestTag: Int)
    {
        var logString = "============= Upload Data Request ===========\n"
        logString = logString.appending("URL: \(urlString)\n")

        let headers = self.headers()
        let imageData = UIImageJPEGRepresentation(image, 0.8)

        logString = logString.appending("Headers :\n")
        for (key, value) in headers {
            logString = logString.appending("\(key): \(value)\n")
        }
        logString = logString.appending("\n")
        print("bytes: \(imageData?.count ?? 0)")

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            var fileKey = ""
            if (requestTag == REQUEST_TAG.create.rawValue) {
                fileKey = "avatar"
            } else {
                fileKey = "image"
            }
            multipartFormData.append(imageData!, withName: fileKey, fileName: "\(fileKey).jpg", mimeType: "image/jpg")
            for (key, value) in params! {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                logString = logString.appending("Content-Disposition: form-data; name=\(key)\n")
                logString = logString.appending("\(value)\n")
                logString = logString.appending("\(multipartFormData.boundary)\n")
            }
            logString = logString.appending("\n")
            print(logString)
        }, to:urlString,
           method: .post,
           headers: headers)
        { [weak self] result in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in

                })
                upload.validate()
                upload.responseJSON { response in
                    if (response.response != nil) {
                        self?.logResponse(response.response!, response.data)
                    } else {
                        print(response.result.error?.localizedDescription ?? "")
                    }
                    self?.handleResponse(response: response, completion: completion, requestTag: requestTag, urlString: urlString, method: HTTP_METHOD_NAME.post.rawValue, urlEncoding: JSONEncoding.default, params: nil)
                }
            case .failure(let encodingError):
                print(encodingError)
                completion!(nil, encodingError as NSError)
            }
        }
    }


    func sendRequest(urlString: String!, params: [String : String]?, completion: CompletionBlock?, method: String, urlEncoding:Alamofire.ParameterEncoding, requestTag: Int) {
        let httpMethod = HTTPMethod(rawValue: method)!
        let dataRequest: DataRequest = Alamofire.request(urlString, method: httpMethod, parameters: params, encoding: urlEncoding, headers: self.headers()).validate(statusCode: 200..<300).validate(contentType: ["application/json"]).responseJSON { [weak self] response in
                if (response.response != nil) {
                    self?.logResponse(response.response!, response.data)
                }
                self?.handleResponse(response: response, completion: completion, requestTag: requestTag, urlString: urlString, method: method, urlEncoding: urlEncoding, params: params)
        }
        self.logRequest(dataRequest.request!, params: params)
    }

    func handleResponse(response: DataResponse<Any>, completion: CompletionBlock?, requestTag: Int, urlString: String!, method: String, urlEncoding:Alamofire.ParameterEncoding, params: [String : Any]?) {
        if response.response == nil {
            if self.isNoInternetConnection(response: response) {
                completion!(nil, self.error("No internet connection", code: -1009))
                return
            }
            completion!(nil, self.error("Uknown server error: 500", code: 500))
            return
        }

        let statusCode = response.response?.statusCode
        if statusCode == nil {
            completion!(nil, self.error("Uknown server error", code: 500))
            return
        }

        if statusCode == 200 || statusCode == 201 {
            let json = try? JSON(data: response.data!)
            completion!(json, nil)
            return
        }

        if statusCode == 403 && requestTag != REQUEST_TAG.login.rawValue && requestTag != REQUEST_TAG.create.rawValue {
            self.logout()
            let error = self.error("Invalid access token. Please relogin", code: 403)
            completion!(nil, error)
            return
        }

        let error = self.validateResponseOnError(response.data)
        if error != nil {
            completion!(nil, error)
            return
        }

        if statusCode == 204 {
            let headers = response.response?.allHeaderFields
            completion!(headers, nil)
        } else if statusCode == 404 {
            completion!(nil, self.error("Ups.. Server is temporary unavailable. Please try later", code: 404))
        } else if statusCode == 400 {
            completion!(nil, self.error("Server error: 400 bad request", code: 400))
        } else if statusCode == 422 {
            completion!(nil, self.error("Server error: 400 bad request", code: 400))
        } else if statusCode == 401 {
            self.cancelAllRequests()
        } else if statusCode == 502 {
            completion!(nil, self.error("Ups.. Server is temporary unavailable. Please try later", code: 502))
        } else {
            completion!(nil, self.error("Uknown server error: 500", code: 500))
        }
    }

    func isNoInternetConnection(response: DataResponse<Any>) -> Bool {
        var isConnected = false
        switch response.result {
        case .failure(let error):
            let respError = error as NSError
            let code = respError.code
            if code == -1009 {
                isConnected = true
            }
        default:
            break
        }
        return isConnected
    }

    func cancelRequest(requestPath: String) {
        let cancelationUrl: URL? = URL(string: requestPath)
        if cancelationUrl != nil {
            let lastPath = cancelationUrl?.lastPathComponent
            Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
                tasks.forEach({task in
                    if task.currentRequest?.url?.lastPathComponent == lastPath {
                        task.cancel()
                    }
                })
            }
        }
    }

    func cancelAllRequests() {
        Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
            tasks.forEach({$0.cancel()})
        }
    }

    func headers() -> [String : String] {
        var _headers = [String : String]()
        _headers["Cache-Control"] = "no-cache"
        _headers["Content-Type"] = "application/json;charset=UTF-8"
        if let _token = self.token {
            _headers["token"] = _token
        }
        return _headers
    }

    func validateResponseOnError(_ data: Data?) -> NSError? {
        do {
            let errorObj = try JSONSerialization.jsonObject(with: data!, options: [])
            if let jsonEror: NSDictionary = (errorObj as? NSDictionary) {
                if let errorMsg = jsonEror["error"] as? String {
                    return self.error(errorMsg, code: 400)
                } else if let errorMsgObj: NSDictionary = jsonEror["children"] as? NSDictionary {
                    if let errDict = errorMsgObj["username"] as? NSDictionary, errDict.count != 0  {
                        return self.getErrorFromChildrenDictionary(errDict: errDict, errPrefix: "Username")
                    } else if let errDict = errorMsgObj["email"] as? NSDictionary, errDict.count != 0 {
                        return self.getErrorFromChildrenDictionary(errDict: errDict, errPrefix: "Email")
                    } else if let errDict = errorMsgObj["password"] as? NSDictionary, errDict.count != 0 {
                        return self.getErrorFromChildrenDictionary(errDict: errDict, errPrefix: "Password")
                    } else if let errDict = errorMsgObj["avatar"] as? NSDictionary, errDict.count != 0 {
                        return self.getErrorFromChildrenDictionary(errDict: errDict, errPrefix: "Avatar")
                    } else if let errDict = errorMsgObj["hashtag"] as? NSDictionary, errDict.count != 0 {
                        return self.getErrorFromChildrenDictionary(errDict: errDict, errPrefix: "Hashtag")
                    } else if let errDict = errorMsgObj["latitude"] as? NSDictionary, errDict.count != 0 {
                        return self.getErrorFromChildrenDictionary(errDict: errDict, errPrefix: "Latitude")
                    } else if let errDict = errorMsgObj["image"] as? NSDictionary, errDict.count != 0 {
                        return self.getErrorFromChildrenDictionary(errDict: errDict, errPrefix: "Image")
                    } else if let errDict = errorMsgObj["description"] as? NSDictionary, errDict.count != 0 {
                        return self.getErrorFromChildrenDictionary(errDict: errDict, errPrefix: "Description")
                    } else if let errDict = errorMsgObj["longitude"] as? NSDictionary, errDict.count != 0 {
                        return self.getErrorFromChildrenDictionary(errDict: errDict, errPrefix: "Longitude")
                    }
                }
            }
            return nil
        } catch {
            print("json error: \(error)")
            if let errorData = data {
                let errorString = NSString(data: errorData, encoding: String.Encoding.utf8.rawValue)
                print(errorString ?? "")
            }
            return nil
        }
    }

    func error(_ errorMsg: String, code: Int) -> NSError {
        let userInfo: [AnyHashable: Any] = [NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: errorMsg, comment: ""), NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: errorMsg, comment: "")]
        let err = NSError(domain: "Domain", code: code, userInfo: userInfo as? [String : Any])
        return err
    }

    func getErrorFromChildrenDictionary(errDict: NSDictionary, errPrefix: String) -> NSError? {
        if let msgArr: NSArray = errDict["errors"] as? NSArray {
            if let msg = msgArr.firstObject as? String {
                let resultMsg = "\(errPrefix): \(msg)"
                return self.error(resultMsg, code: 400)
            }
        }
        return nil
    }

    func logRequest(_ request: URLRequest, params: [String : Any]?) {
        let method = request.httpMethod
        let urlString = request.url?.absoluteString
        print("\(method!) \(urlString!)")
        let headers = request.allHTTPHeaderFields
        self.logHeaders(headers!)

        if let postParams = params {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: postParams, options: JSONSerialization.WritingOptions.prettyPrinted)
                let datastring = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
                print("Post body : \n \(datastring!)")
            } catch let error as NSError {
                print(error)
            }
        }
    }

    func logResponse(_ response: URLResponse, _ data: Data?) {
        if let url = response.url?.absoluteString {
            print("\n Response: \(url)")
        }
        if let httpResponse = response as? HTTPURLResponse {
            let localisedStatus = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode).capitalized
            print("Status: \(httpResponse.statusCode) - \(localisedStatus)")
        }

        if let headers = (response as? HTTPURLResponse)?.allHeaderFields as? [String: AnyObject] {
            self.logHeaders(headers)
        }

        if (data?.count)! > 0 {
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                let pretty = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                if let string = NSString(data: pretty, encoding: String.Encoding.utf8.rawValue) {
                    print("JSON: \(string)")
                }
            } catch {
                if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                    print("Data: \(string)")
                }
            }
        }
    }

    func logHeaders(_ headers: [String: Any]) {
        print("Headers: [")
        for (key, value) in headers {
            print("  \(key) : \(value)")
        }
        print("]")
    }

    func logout() {
        self.token = nil
        UserStorageManager.setToken(value: self.token)
        AppDelegate.sharedDelegate.switchAppToState(state: .auth)
        self.cancelAllRequests()
    }
}
