//
//  ArtWork.swift
//  NearMe
//
//  Created by Hos on 18/12/17.
//  Copyright © 2017 Hos. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class ArtWork: NSObject,MKAnnotation
{
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let discipline:String
    let locationName:String
    
     init(title:String,locationName:String,discipline:String,coordinate:CLLocationCoordinate2D)
    {
        self.title = title
        self.discipline = discipline
        self.locationName = locationName
        self.coordinate = coordinate
        super.init()
    }

    var subtitle: String?
    {
        return locationName
    }
    
    func mapItem() -> MKMapItem
    {
        let addressDict = [CNPostalAddressStreetKey:subtitle!]
        let placeMark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = title
        return mapItem
    }
}
