//
//  DeviceLocation.swift
//  Autobrain
//
//  Created by Kyle Smith on 10/16/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

import UIKit
import CoreLocation

class DeviceLocation: NSObject, CLLocationManagerDelegate {
    
    public static var shared = DeviceLocation()
    
    var locationManager: CLLocationManager!
    
    override init() {
        super.init()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func getDeviceLocation() -> CLLocationCoordinate2D? {
        return locationManager.location?.coordinate
    }
}
