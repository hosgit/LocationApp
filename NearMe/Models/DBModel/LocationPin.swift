//
//  LocationPin.swift
//  NearMe
//
//  Created by Hos on 27/12/17.
//  Copyright © 2017 Hos. All rights reserved.
//

import UIKit
import CoreData
import  CoreLocation
class LocationPin: NSManagedObject
{
   static func loadDataToDB(context:NSManagedObjectContext)
    {
        if let path = Bundle.main.path(forResource:"LocationPinFile", ofType: "json")
        {
            
            do {
                let data = try Data(contentsOf:URL(fileURLWithPath: path) , options:.mappedIfSafe)
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonObj as? Array<Dictionary<String,AnyObject>>
                {
                    for dict in jsonResult
                    {
                        let pin = LocationPin(context: context)
                        pin.locationName = dict["address"] as? String
                        pin.title = dict["name"] as? String
                        var latitude = 0.0
                        var longitude = 0.0
                        if let lat = dict["lat"] as? String
                        {
                             latitude = Double(lat)!
                        }
                        if let long = dict["lng"] as? String
                        {
                            longitude = Double(long)!
                        }
                        pin.lat = latitude
                        pin.lon = longitude
                        try?context.save()
                    }
                }
            }
            catch let error
            {
                print(error)
            }
        }
    }
    
    static func getLocationPinsNear(latitude:Double,longitude:Double,context:NSManagedObjectContext)
    {
 
        let fetchRequest:NSFetchRequest<LocationPin> = LocationPin.fetchRequest()
        let data = try?context.fetch(fetchRequest)
        print(data ?? "no data")
    }
}
