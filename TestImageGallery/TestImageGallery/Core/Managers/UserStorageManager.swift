//
//  UserStorageManager.swift
//  TestImageGallery
//
//  Created by Alexandr on 5/24/18.
//  Copyright © 2018 Alexandr Zhuk. All rights reserved.
//

import UIKit

class UserStorageManager: NSObject {

    static func setToken(value: String?) {
        let defaults:UserDefaults = UserDefaults.standard
        defaults.set(value, forKey: "Token")
        defaults.synchronize()
    }

    static func getToken() -> String? {
        let defaults:UserDefaults = UserDefaults.standard
        return defaults.string(forKey: "Token")
    }
}
