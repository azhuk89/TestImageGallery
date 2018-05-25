//
//  AppLocationManager.swift
//  TestImageGallery
//
//  Created by Alexandr on 5/24/18.
//  Copyright © 2018 Alexandr Zhuk. All rights reserved.
//

import UIKit
import CoreLocation

class AppLocationManager: NSObject {

    static let sharedManager = AppLocationManager()

    let locationManager: CLLocationManager = CLLocationManager()

    func ascPermision() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    func currentLocation() -> CLLocation? {
        return self.locationManager.location
    }
}
