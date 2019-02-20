//
//  Photos.swift
//  Xplore
//
//  Created by Jack Knight on 2/6/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class Photo: FirestoreFetchable, FirebaseStorage, Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    static var CollectionName: String = "adventurePhotos"
    
    var image: UIImage?
    let uuid: String
    let adventureID: String?
    let creatorID: String
    var imageURL: String?
    var data: Data {
        guard let image = self.image,
        let data = image.jpegData(compressionQuality: 0.30)
            else { return Data() }
        return data
    }
    
    var isSelected = true
    
    init(image: UIImage?, uuid: String = UUID().uuidString, creatorID: String, adventureID: String) {
        self.image = image
        self.uuid = uuid
        self.creatorID = creatorID
        self.adventureID = adventureID
        self.imageURL = nil
    }
    
    required init?(with dictionary: [String : Any], id: String) {
        guard let imageURL = dictionary["imageURL"] as? String,
        let uuid = dictionary["uuid"] as? String,
        let creatorID = dictionary["creatorID"] as? String,
        let adventureID = dictionary["adventureID"] as? String
            else {return nil}
       
        self.image = nil
        self.imageURL = imageURL
        self.uuid = uuid
        self.creatorID = creatorID
        self.adventureID = adventureID
        
    }
}

extension Photo {
    var dictionary: [String : Any] {
        return [
            "uuid" : uuid,
            "imageURL" : imageURL,
            "creatorID" : creatorID,
            "adventureID" : adventureID
        ]
    }
}
