//
//  AdventureRealm.swift
//  Xplore
//
//  Created by Jack Knight on 3/19/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit
import RealmSwift

class AdventureRealm: Object {
    
    @objc dynamic var uuid: String? = nil
    @objc dynamic var adventureName: String?
    @objc dynamic var details: String?
    let photoIDs = List<String>()
    @objc dynamic var createrID: String?

    
    convenience init(adventure: Adventure) {
        self.init()
        self.uuid = adventure.uuid
        self.adventureName = adventure.adventureName
        self.details = adventure.details
        self.photoIDs.append(objectsIn: adventure.photoIDs)
        self.createrID = adventure.createrID
        
    }
}





