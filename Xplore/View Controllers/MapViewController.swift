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
    @IBOutlet weak var locateButtonVIew: UIView!
    
    var locationManager = CLLocationManager()
    var currentUser: AppUser? {
        return AppUserController.shared.currentUser
    }
    static let allAdventuresReceived = Notification.Name(rawValue: "allAdventuresReceived")
    var wasZoomed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        locateButtonVIew.layer.cornerRadius = locateButtonVIew.frame.height / 2
        mapView.delegate = self
        locateButtonVIew.layer.shadowOffset = CGSize(width: 5, height: 5)
        locateButtonVIew.layer.shadowOpacity = 0.5
        fetchAllAdventures()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchAllAdventures), name: FirebaseManager.UserUpdateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchAllAdventures), name: FirebaseManager.AdventureUpdateNotification, object: nil)
      
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func fetchAllAdventures() {
            NotificationCenter.default.post(name: MapViewController.allAdventuresReceived, object: nil)
            DispatchQueue.main.async {
                AdventureController.shared.allAdventures.forEach({ (adventure) in
                    self.addPinFor(adventure)
                })
            }
    }
    
    func addPinFor(_ adventure: Adventure) {
        let annotation = CustomPointAnnotation()
        annotation.adventure = adventure
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
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var markerView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        markerView?.markerTintColor = UIColor.xploreGreen
        let button = UIButton(type: .detailDisclosure)
        markerView?.rightCalloutAccessoryView = button
        markerView?.canShowCallout = true
        return markerView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! CustomPointAnnotation
        guard let adventure = annotation.adventure else { return }
        
        let adventureDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "adventureDetailVC") as! AdventureDetailViewController
        
        adventureDetailVC.adventure = adventure
        self.navigationController?.pushViewController(adventureDetailVC, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !wasZoomed {
            let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
            let coordinateRegion = MKCoordinateRegion(center: userLocation.coordinate, span: coordinateSpan)
            mapView.setRegion(coordinateRegion, animated: true)
            wasZoomed = true
        }
    }
}

