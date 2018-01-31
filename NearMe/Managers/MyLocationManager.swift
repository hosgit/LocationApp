//
//  MyLocationManager.swift
//  NearMe
//
//  Created by Hos on 24/12/17.
//  Copyright © 2017 Hos. All rights reserved.
//

import Foundation
import  CoreLocation

protocol MyLocationMangerDelegate
{
    func didUpdateLatestLocation()
}

class MyLocationManager:NSObject,CLLocationManagerDelegate
{
    private let locationManager = CLLocationManager()
    private var authorizationCopletion: ((Bool)->())?
    static let shared = MyLocationManager()
    private(set) var myCurrentLocation:CLLocation?
    var delegate:MyLocationMangerDelegate?
    
    private override init()
    {
        super.init()
        locationManager.delegate = self
    }
    
    func requestForAccess(completion:@escaping (Bool)->())
    {
      authorizationCopletion = completion
      locationManager.requestWhenInUseAuthorization()
    }
    
    func  startLocationUpdate()
    {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
        }
    }
    
    //Delegate CLlocaiton manager
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        authorizationCopletion?(status == .authorizedWhenInUse)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        print("updating location")
        myCurrentLocation = locations.first
        delegate?.didUpdateLatestLocation()
    }
    
}



