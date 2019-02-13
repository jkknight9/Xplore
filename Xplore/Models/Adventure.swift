//
//  Adventure.swift
//  Xplore
//
//  Created by Jack Knight on 2/6/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class Adventure: FirestoreFetchable {
    
    static let CollectionName: String = "adventures"
    
    let uuid: String
    var adventureName: String
    var details: String
    var location: CLLocationCoordinate2D?
    var photoIDs: [String]
    var createrID: String
    
    init(uuid: String = UUID().uuidString, adventureName: String, details: String, location: CLLocationCoordinate2D?, photoIDs: [String], createrID: String) {
        
        self.uuid = uuid
        self.adventureName = adventureName
        self.details = details
        self.location = location
        self.photoIDs = photoIDs
        self.createrID = createrID
    }
    
    required init?(with dictionary: [String : Any], id: String) {
        guard let adventureName = dictionary["adventureName"] as? String,
            let geoPoint = dictionary["location"] as? GeoPoint,
            let createrID = dictionary["creatorID"] as? String,
            let details = dictionary["details"] as? String,
            let photosIDs = dictionary["photoIDs"] as? [String]
            else { return nil }
        
        self.uuid = id
        self.adventureName = adventureName
        self.location = CLLocationCoordinate2D(geoPoint: geoPoint)
        self.createrID = createrID
        self.details = details
        self.photoIDs = photosIDs
        }
}

extension Adventure {
    var dictionary: [String : Any] {
        var dict: [String : Any] = [
            "uuid" : uuid,
            "adventureName" : adventureName,
            "details" : details,
            "creatorID" : createrID,
            "photoIDs" : photoIDs
        ]
        if let location = location {
            dict["location"] = GeoPoint(coordinates: location)
        }
        return dict
    }
}

extension CLLocationCoordinate2D {
    init(geoPoint: GeoPoint) {
        self.init(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
    }
}

extension GeoPoint {
    convenience init(coordinates: CLLocationCoordinate2D) {
        self.init(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
}
