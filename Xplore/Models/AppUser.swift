//
//  AppUser.swift
//  Xplore
//
//  Created by Jack Knight on 2/5/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit
import RealmSwift

class AppUser: FirestoreFetchable {
    
  
    static var CollectionName: String = "users"
    
    let uuid: String
    var name: String
    var username: String
    var emailAddress: String
    var adventureIDs: [String]?
    var profilePic: UIImage?
    var profilePicURL: String?    
    init(uuid: String = UUID().uuidString, name: String, username: String, emailAddress: String, adventureIDs: [String]? = nil, profilePicURL: String? = nil) {
        
        self.uuid = uuid
        self.name = name
        self.username = username
        self.emailAddress = emailAddress
        self.adventureIDs = adventureIDs
        self.profilePicURL = profilePicURL
    }
    
   
    required init?(with dictionary: [String : Any], id: String) {
       
        guard let name = dictionary["name"] as? String,
        let username = dictionary["username"] as? String,
            let emailAddress = dictionary["emailAddress"] as? String else {return nil}
        
        self.uuid = id
        self.name = name
        self.username = username
        self.emailAddress = emailAddress
        
        if let adventureIDs = dictionary["adventureIDs"] as? [String] {
            self.adventureIDs = adventureIDs
        }
        
        if let profilePicURL = dictionary["profilePicURL"] as? String? {
            self.profilePicURL = profilePicURL
        }
    }
}
    extension AppUser {
        
        var dictionary: [String : Any] {
            return [
                "uuid" : uuid,
                "name" : name,
                "username" : username,
                "emailAddress" : emailAddress,
                "adventureIDs" : adventureIDs,
                "profilePicURL" : profilePicURL
            ]
        }
    }
    
    

