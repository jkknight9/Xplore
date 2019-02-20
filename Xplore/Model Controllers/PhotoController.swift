//
//  PhotoController.swift
//  Xplore
//
//  Created by Jack Knight on 2/7/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit
import Firebase

class PhotoController {
    
    // Shared Instance(singleton)
    
    static let shared = PhotoController()
    
    //Fetch photos from firebase
    func fetchPhotos(for adventure: Adventure, completion: @escaping ([UIImage]?) -> Void) {
        let dispatchGroup = DispatchGroup()
        var photos: [UIImage] = []
        for photoID in adventure.photoIDs {
            dispatchGroup.enter()
            Storage.storage().reference(withPath: "adventurePhotos/\(adventure.uuid)/\(photoID)").getData(maxSize: 999999999) { (data, error) in
                if let error = error {
                    print("💩There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                    dispatchGroup.leave()
                    return
                }
                guard let data = data,
                    let photo = UIImage(data: data) else { return }
                photos.append(photo)
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(photos)
        }
    }
    
    // upload photos
    
    func uploadPhotos(photos: [UIImage], for adventure: Adventure, completion: @escaping () -> Void) {
        let baseStorageRef = Storage.storage().reference(withPath: "adventurePhotos/\(adventure.uuid)")
        let dispatchGroup = DispatchGroup()
        for (index, photo) in photos.enumerated() {
            dispatchGroup.enter()
            let photoId = adventure.photoIDs[index]
            let storageRef = baseStorageRef.child(photoId)
            if let data = photo.jpegData(compressionQuality: 0.5) {
                storageRef.putData(data, metadata: nil) { (nil, error) in
                    dispatchGroup.leave()
                    if let error = error {
                        print("💩There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                    }
                }
            }
            dispatchGroup.notify(queue: .main) {
                completion()
            }
        }
    }
    
    func add(photo: UIImage, to adventure: Adventure, completion: @escaping () -> Void) {
        let photoNumber = adventure.photoIDs.count + 1
        let newPhotoID = "photo\(photoNumber)"
        adventure.photoIDs.append(newPhotoID)
        
        let baseStorageRef = Storage.storage().reference(withPath: "adventurePhotos/\(adventure.uuid)")
        guard let photoID = adventure.photoIDs.last else { completion() ; return }
        let storageRef = baseStorageRef.child(photoID)
        if let data = photo.jpegData(compressionQuality: 0.5) {
            storageRef.putData(data, metadata: nil) { (nil, error) in
                if let error = error {
                    print("💩There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                }
                FirebaseManager.updateData(object: adventure, dictionary: adventure.dictionary, completion: { (error) in
                     if let error = error {
                        print("💩There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                    }
                    completion()
                })
            }
        }
    }
    
    // fetch image from firebase
    func fetchImageFromFirebase(for photo: Photo, completion: @escaping (UIImage?) -> Void) {
        if let url = photo.imageURL {
            FirebaseManager.fetchPhotoFromFirebase(url: url, completion: { (success, image) in
                if !success {
                    completion(nil)
                    return
                }
                if let image = image {
                    completion(image)
                }
            })
        }
    }
    
    //Save users profile pic to firebase
    func saveProfilePic(from image: UIImage, user: AppUser, completion: @escaping (String?) -> Void) {
        
        let newProfilePhoto = Photo(image: image, uuid: user.uuid, creatorID: "", adventureID: "")
        FirebaseManager.uploadPhotoToFirebase(newProfilePhoto) { (url, error) in
            if let error = error {
                print("There was a problem uploading profile Pic to firebase storage: \(error.localizedDescription)")
                completion(nil)
                return
            } else {
                guard let url = url else { return }
                do {
                    let urlAsString = try String(contentsOf: url)
                    user.profilePicURL = urlAsString
                    completion(urlAsString)
                } catch {
                    print("Yo yo there was an error in \(#function) ; \(error.localizedDescription)")
                }
            }
        }
    }
}
