//
//  GalleryItemModel.swift
//  TestImageGallery
//
//  Created by Alexandr on 5/23/18.
//  Copyright © 2018 Alexandr Zhuk. All rights reserved.
//

import UIKit
import SwiftyJSON

class GalleryItemModel: NSObject {
    var itemId: Int?
    var created: Date?
    var smallImageUrl: String?
    var bigImageUrl: String?
    var weather: String?
    var address: String?
    var latitude: Float?
    var longitude: Float?

    init(json: JSON) {
        super.init()
        self.itemId = json["id"].int
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        if let stringDate = json["created"].string {
            self.created = formatter.date(from: stringDate)
        }
        self.smallImageUrl = json["smallImagePath"].string
        self.bigImageUrl = json["bigImagePath"].string
        self.weather = json["parameters"]["weather"].string
        self.address = json["parameters"]["address"].string
        self.latitude = json["parameters"]["latitude"].float
        self.longitude = json["parameters"]["longitude"].float
    }

    static func models(json: JSON) -> [GalleryItemModel] {
        var results: [GalleryItemModel] = []
        if let items = json["images"].array {
            for item in items {
                let model = GalleryItemModel(json: item)
                results.append(model)
            }
        }
        return results
    }
}
