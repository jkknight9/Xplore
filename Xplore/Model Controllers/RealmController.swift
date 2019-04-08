//
//  RealmController.swift
//  Xplore
//
//  Created by Jack Knight on 3/19/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import Foundation
import RealmSwift

class RealmController {
    
    //Shared Instance
    static let shared = RealmController()
    
    var currentUser = AppUserController.shared.currentUser
    
    let realm = try! Realm()
    
    
    public func sync() {
        guard let currentUser = currentUser else {return}
        AdventureController.shared.fetchAdventures(currentUser: currentUser) {_ in
            let adventures = AdventureController.shared.adventures
            let realmAdventures = self.realm.objects(AdventureRealm.self)
            if realmAdventures.count == 0 {
                self.add(AdventuresToAdd: adventures)
                return
            }
        }
    }
    
    private func compare() {
        
    }
    
    private func add(AdventuresToAdd: [Adventure]) {
        for adventure in AdventuresToAdd {
            let realmAdventure = AdventureRealm(adventure: adventure)
            do {
                try realm.write {
                    realm.add(realmAdventure)
                }
            } catch let error {
                    print("💩There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                }
            }
        }
    
private func delete() {
    
}

private func update() {
    
}


}
