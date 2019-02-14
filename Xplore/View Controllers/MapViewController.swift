//
//  MapViewController.swift
//  Xplore
//
//  Created by Jack Knight on 2/12/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locateUserButton: UIButton!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        locateUserButton.layer.cornerRadius = locateUserButton.frame.height / 4
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AdventureController.shared.adventures.forEach { (adventure) in
            
            DispatchQueue.main.async {
                guard let adventureLocation = adventure.location else {return}
                self.addPinFor(location: adventureLocation, name: adventure.adventureName, details: adventure.details)
            }
        }
    }
    
    func addPinFor(location: CLLocationCoordinate2D, name: String, details: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = name
        annotation.subtitle = details
        mapView.addAnnotation(annotation)
    }
    
    func requestLocationAccess() {
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
        case .denied, .restricted:
            print("location access denied")
        default:
            locationManager.requestWhenInUseAuthorization()
            
        }
    }
    
    
    
    @IBAction func locateUserButtonTapped(_ sender: Any) {
        self.mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.markerTintColor = UIColor.xploreGreen
//        pinView?.canShowCallout = true
//        pinView?.inputAccessoryView
        return pinView
    }
}
