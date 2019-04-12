//
//  AdventureController.swift
//  Xplore
//
//  Created by Jack Knight on 2/7/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit
import FirebaseFirestore
import CoreLocation

class AdventureController {
    
    
    //   MARK: - Shared Instance
    static let shared = AdventureController()
    private init(){}
    
    var adventures: [Adventure] = []
    var allAdventures: [Adventure] = [] 
//        get {
//
//        }
//        set {
//
//        }
//    }
    
    //   MARK: - CRUD Functions
    
    //Create an adventure
    func createAnAdventure(adventureName: String, details: String, location: CLLocationCoordinate2D?, creatorID: String, photos: [UIImage] = [], completion: @escaping (Adventure?) -> Void) {
        guard let creatorID = AppUserController.shared.currentUser?.uuid else { return }
        let photoIds = photos.enumerated().compactMap{ "photo\($0.offset + 1)" }
        let newAdventure = Adventure(adventureName: adventureName, details: details, location: location, photoIDs: photoIds, createrID: creatorID)
        FirebaseManager.saveData(object: newAdventure) { (error) in
            if let error = error {
                print("There was an error creating event \(newAdventure). \(error.localizedDescription)")
                completion(nil)
                return
            } else {
                completion(newAdventure)
                self.adventures.append(newAdventure)
                self.allAdventures.append(newAdventure)
            }
        }
        PhotoController.shared.uploadPhotos(photos: photos, for: newAdventure) {
            completion(newAdventure)
        }
    }
    
    //Update an adventure
    func updateAnAdventure(adventure: Adventure, adventureName: String, details: String, completion: @escaping (Bool) -> Void) {
        
        adventure.adventureName = adventureName
        adventure.details = details
        
        FirebaseManager.updateData(object: adventure, dictionary: adventure.dictionary) { (error) in
            if let error = error {
                print("There was an error updating adventure \(adventure). \(error.localizedDescription)")
                completion(false)
                return
            } else {
                completion(true)
            }
        }
    }
    
    // Delete an Adventure
    func deleteAnAdventure(adventure: Adventure, completion: @escaping (Bool) -> Void) {
        FirebaseManager.deleteData(object: adventure) { (success) in
            if !success {
                print("There was an error deleting an adventure. \(adventure)")
                completion(false)
                return
            } else {
                guard let index = AdventureController.shared.adventures.firstIndex(of: adventure) else {completion(false) ; return}
                AdventureController.shared.adventures.remove(at: index)
                completion(true)
            }
        }
    }
    
    //Add photos to an adventure
    func addPhotos(photos: Photo, completion: @escaping (Bool) -> Void) {
        FirebaseManager.saveData(object: photos) { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    //Delete photos from an adventure
    
    func deletePhotos(photos: Photo, completion: @escaping (Bool) -> Void) {
        FirebaseManager.deleteData(object: photos) { (success) in
            if !success {
                print("There was an error deleting a photo \(photos)")
                completion(false)
                return
            } else {
                completion(true)
            }
        }
    }
    
    func fetchAllAdventures(currentUser: AppUser, completion: @escaping ([Adventure]) -> Void) {
        FirebaseManager.fetchAllinACollectionFromFirestore { (allAventures: [Adventure]?) in
            if let allAdventures = allAventures {
                if let blockedUserIDs = currentUser.blockedUserIDs {
                    let filteredAdventures = allAdventures.filter{ !blockedUserIDs.contains($0.createrID)  }
                   completion(filteredAdventures)
                    return
                }
                completion(allAdventures)
            }
        }
    }
    //Fetch for users events from firebase, maybe store locally
    func fetchAdventures(currentUser: AppUser, completion: @escaping ([Adventure]) -> Void) {
        FirebaseManager.fetchFireStoreWithFieldAndCriteria(for: "creatorID", criteria: currentUser.uuid, inArray: false) { (adventures: [Adventure]?) in
            if let adventures = adventures {
                AdventureController.shared.adventures = adventures
                if let blockedUserIDs = currentUser.blockedUserIDs {
                    let filteredAdventures = adventures.filter{ !blockedUserIDs.contains($0.createrID) }
                    completion(filteredAdventures)
                    return
                }
                completion(adventures)
            }
        }
    }
}
