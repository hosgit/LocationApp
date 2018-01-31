//
//  LocationFinderViewController.swift
//  NearMe
//
//  Created by Hos on 16/12/17.
//  Copyright © 2017 Hos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class LocationFinderViewController: UIViewController
{
    var overlayView:UIView?
    var pulseLayer:CAShapeLayer?
    var trackLayer:CAShapeLayer?
    var selectedCatagory:LocationType?
    var matchingItems = [MKMapItem]()
    var downloadStatusLabel:UILabel? =
    {
       let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    let downloadUrlString = "https://firebasestorage.googleapis.com"
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addOverlayView()
        configureMap()
        MyLocationManager.shared.startLocationUpdate()
        MyLocationManager.shared.delegate = self
        
    }
    
    private func configureMap()
    {
       // mapView.delegate = self
        mapView.showsTraffic = true
        mapView.showsBuildings = true
        mapView.showsCompass = true
        mapView.showsUserLocation = true
    }
    
    private func myCurrentLocation() -> CLLocation?
    {
        guard let location =  MyLocationManager.shared.myCurrentLocation  else {
            return nil
        }
        return location
    }
    
    private func updateUserLocationOnMap()
    {
        let distance:CLLocationDistance = 5000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance((myCurrentLocation()?.coordinate)!,distance , distance)
        mapView.setRegion(coordinateRegion, animated: true)
        performSearch()
    }
    
     func addMarkerOnMap()
    {
        let artwork = ArtWork(title: "King David Kalakaua",
                              locationName: "Waikiki Gateway Park",
                              discipline: "Sculpture",
                              coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        mapView.addAnnotation(artwork)
    }
    
    
    
    // search local
    
    
    private func getSearchText()->String
    {
        switch selectedCatagory!
        {
        case .garbage:
            return "garbage"
        case .indraCanteen:
            return "Indra Canteen"
        case .washroom:
            return "Public Toilet"
        }
    }
    
    private func performSearch()
    {
        
        LocationPin.getLocationPinsNear(latitude:(myCurrentLocation()?.coordinate.latitude)! , longitude:(myCurrentLocation()?.coordinate.longitude)! , context:CoreDataManager.context() )
        
    }
        
}


extension LocationFinderViewController:MyLocationMangerDelegate
{
    func didUpdateLatestLocation()
    {
       updateUserLocationOnMap()
    }
}

//extension LocationFinderViewController:MKMapViewDelegate
//{
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
//    {
//        guard let annotation = annotation as? ArtWork else{return nil}
//        let identifier = "marker"
//        let view :MKAnnotationView
//
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier:identifier)
//        {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        }
//        else
//        {
//            if #available(iOS 11.0, *) {
//                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            }
//            else
//            {
//                // Fallback on earlier versions
//                return nil
//            }
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: 0.5, y: 0.5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        return view
//    }
//
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
//    {
//        let desitnationLocation =  view.annotation as! ArtWork
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
//        desitnationLocation.mapItem().openInMaps(launchOptions: launchOptions)
//    }
//}

