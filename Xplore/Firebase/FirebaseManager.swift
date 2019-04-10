//
//  FirebaseManager.swift
//  Xplore
//
//  Created by Jack Knight on 2/5/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class FirebaseManager {
    
    
    static let UserUpdateNotification: Notification.Name = Notification.Name(rawValue: "userUpdated")
    static let AdventureUpdateNotification: Notification.Name = Notification.Name("adventureUpdated")
    
    //   MARK: - User Functions
    
    static func signUp(name: String, emailAddress: String, username: String, password: String, completion: @escaping (AppUser?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: emailAddress, password: password) { (authResult, error) in
            if let error = error {
                print("There was an error creating user with email address \(emailAddress)...\(error.localizedDescription)")
                completion(nil, error)
                return
            }
            guard let user = authResult?.user else {
                print("Error unwrapping user.")
                return
            }
            let uuid = user.uid
            
            let newUser = AppUser(uuid: uuid, name: name, username: username, emailAddress: emailAddress)
            
            self.saveData(object: newUser, completion: { (error) in
                if let error = error {
                    print("Error saving user to FireStore: \(error.localizedDescription)")
                    completion(nil, error)
                    return
                }
                
            })
            completion(newUser, nil)
            return
        }
    }
    
    static func logInWith(emailAddress: String, password: String, completion: @escaping (AppUser?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (authResult, error) in
            if let error = error {
                print("There was an error signing in user with email address \(emailAddress). \(error) ; \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            guard let user = authResult?.user else {
                print("Error getting user")
                return
            }
            let uuid = user.uid
            let collectionReference = Firestore.firestore().collection("users")
            
            collectionReference.document(uuid).getDocument(completion: { (fetchedUserSnapshot, error) in
                if let error = error {
                    print("There was an error in \(#function): \(error) ; \(error.localizedDescription)")
                    completion(nil, error)
                    return
                }
                guard let fetchedUserData = fetchedUserSnapshot, fetchedUserData.exists, let fetchedUserDictionary = fetchedUserData.data() else { completion(nil, nil) ; return}
                
                let signedInUser = AppUser(with: fetchedUserDictionary, id: fetchedUserData.documentID)
                completion(signedInUser, nil)
            })
        }
    }
    // Sign out user
    
    static func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            print("There was an error signing out. \(error) ; \(error.localizedDescription)")
            completion(error)
        }
    }
    
    static func getLoggedInUser(completion: @escaping (AppUser?) -> Void) {
        if Auth.auth().currentUser != nil {
            guard let user = Auth.auth().currentUser else {return}
            
            let uuid = user.uid
            
            let collectionReference = Firestore.firestore().collection("users")
            collectionReference.document(uuid).getDocument { (fetchedUserSnapshot, error) in
                if let error = error {
                    print("There was an error in \(#function): \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                guard let fetchedUserData = fetchedUserSnapshot, fetchedUserData.exists, let fetchedUserDictionary = fetchedUserData.data() else { completion(nil) ; return}
                
                let loggedInUser = AppUser(with: fetchedUserDictionary, id: uuid)
                completion(loggedInUser)
            }
        } else {
            print("No user is signed in")
            completion(nil)
            return
        }
    }
    
    // Delete User
    static func deleteLoggedInUser(completion: @escaping (Bool) -> Void) {
        if Auth.auth().currentUser != nil {
            guard let user = Auth.auth().currentUser else {return}
            
            let userID = user.uid
            let usersCollectionReference = Firestore.firestore().collection("users")
            usersCollectionReference.document(userID).delete() { (error) in
                if let error = error {
                    print("Error deleting user from \"user\" database \(error.localizedDescription)")
                } else {
                    print("User deleted")
                }
            }
            
            user.delete { (error) in
                if let error = error {
                    print("💩There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                } else {
                    print("Account was deleted for sure!!!")
                    completion(true)
                }
            }
        }
    }
    
    // Forgot Password
    static func forgotPassword(emailAddress: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: emailAddress) { (error) in
            if let error = error {
                print("There was an error sending password reset to \(emailAddress). \(error) ; \(error.localizedDescription)")
                completion(false)
                return
            } else {
                completion(true)
                return
            }
        }
    }
    
    //   MARK: - Fetch Functions
    static func fetchFromFireStore<T: FirestoreFetchable>(uuid: String, completion: @escaping (T?) -> Void) {
        let collectionReference = T.collection
        collectionReference.document(uuid).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("There was an error in \(#function) \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let documentSnapshot = documentSnapshot, documentSnapshot.exists, let objectDictionary = documentSnapshot.data() else { completion(nil) ; return }
            
            let object = T(with: objectDictionary, id: documentSnapshot.documentID)
            completion(object)
        }
    }
    
    static func fetchAllinACollectionFromFirestore<T: FirestoreFetchable>(completion: @escaping ([T]?) -> Void) {
        let collectionReference = T.collection
        
        collectionReference.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("There was an error in \(#function) \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let documents = querySnapshot?.documents else { completion(nil) ; return }
            let dictionaries = documents.compactMap{$0.data() }
            var returnValue: [T] = []
            
            for dictionary in dictionaries {
                guard let uuid = dictionary["uuid"] as? String,
                    let object = T(with: dictionary, id: uuid) else { continue }
                returnValue.append(object)
            }
            completion(returnValue)
        }
    }
    
    static func fetchFireStoreWithFieldAndCriteria<T: FirestoreFetchable>(for field: String, criteria: String, inArray: Bool, completion: @escaping ([T]?) -> Void) {
        let collectionReference = T.collection
        var filteredCollection: Query?
        if inArray {
            filteredCollection = collectionReference.whereField(field, arrayContains: criteria)
        } else {
            filteredCollection = collectionReference.whereField(field, isEqualTo: criteria)
        }
        
        filteredCollection?.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("There was an error in \(#function) \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let documents = querySnapshot?.documents else { completion(nil) ; return }
            let dictionaries = documents.compactMap{ $0.data() }
            var returnValue: [T] = []
            for dictionary in dictionaries {
                guard let uuid = dictionary["uuid"] as? String,
                    let object = T(with: dictionary, id: uuid) else { print("Error  with firebasemanager!!!!❌") ;
                        completion(nil) ; return }
                returnValue.append(object)
            }
            completion(returnValue)
        }
    }
    
    //   MARK: - Create, Update, Delete
    
    static func saveData<T: FirestoreFetchable>(object: T, completion: @escaping (Error?) -> Void) {
        let collectionReference = T.collection
        let documentReference = collectionReference.document(object.uuid)
        documentReference.setData(object.dictionary) { (error) in
            if let error = error {
                print("Error \(error) \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    static func updateData<T: FirestoreFetchable>(object: T, dictionary: [String : Any], completion: @escaping (Error?) -> Void) {
        let documentReference = T.collection.document(object.uuid)
        documentReference.updateData(dictionary) {(error) in
            if let error = error {
                print("There was an error in \(#function) ; \(error) ; \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    static func deleteData<T: FirestoreFetchable>(object: T, withChildren children: [String]? = nil, completion: @escaping (Bool) -> Void) {
        let collectionReference = T.collection
        
        collectionReference.document(object.uuid).delete { (error) in
            if let error = error {
                print("Error deleting data \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    //   MARK: - Photo Storage
    
    // Upload photo from Firebase
    static func uploadPhotoToFirebase<T: FirebaseStorage>(_ object: T, completion: @escaping (URL?, Error?) -> Void) {
        let storageRef = object.storageReference
        let objectRef = storageRef.child("\(object.uuid).jpg")
        let _ = objectRef.putData(object.data, metadata: nil) { (metadata, error) in
            guard let _ = metadata else {
                completion(nil, nil)
                return
            }
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
                return
            }
            
            objectRef.downloadURL(completion: { (url, _) in
                guard let downloadURL = url else {return}
                print(downloadURL)
                completion(downloadURL, nil)
            })
        }
    }
    
    // Delete Photo from Firebase
    static func deletePhotoFromFirebase(uuid: String, completion: @escaping (Bool) -> Void) {
        let storage = Storage.storage().reference().child("adventurePhotos")
        let objectRef = storage.child("\(uuid).jpg")
        objectRef.delete { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Photo delected correctly!📸")
            }
        }
    }
    
    // Fetch Photo from Firebase
    static func fetchPhotoFromFirebase(url: String, completion: @escaping (Bool, UIImage?) -> Void) {
        let storage = Storage.storage()
        let pathReference = storage.reference(forURL: url)
        
        pathReference.getData(maxSize: 10000000) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, nil)
            } else {
                guard let data = data else {return}
                let image = UIImage(data: data)
                completion(true, image)
            }
        }
    }
    
    // Fetch Photo from Firebase
    static func fetchPhotoFromFirebase(relativePath: String, completion: @escaping (Bool, UIImage?) -> Void) {
        let storage = Storage.storage()
        let pathReference = storage.reference(withPath: relativePath)
        
        pathReference.getData(maxSize: 10000000) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, nil)
            } else {
                guard let data = data else {return}
                let image = UIImage(data: data)
                completion(true, image)
            }
        }
    }
    
    static func setUpListenerForUser() {
        guard let currentUserID = AppUserController.shared.currentUser?.uuid else {return}
        let collectionReference = Firestore.firestore().collection("users")
        collectionReference.document(currentUserID).addSnapshotListener(includeMetadataChanges: true) { (fetchedUserSnapshot, error) in
            if let error = error {
                print("There was an error in \(#function): \(error.localizedDescription)")
                return
            }
            guard let fetchedUserData = fetchedUserSnapshot, fetchedUserData.exists, let fetchedUserDictionary = fetchedUserData.data() else { return}
            let loggedInUser = AppUser(with: fetchedUserDictionary, id: currentUserID)
            AppUserController.shared.currentUser = loggedInUser
            let notification = Notification(name: UserUpdateNotification)
            NotificationCenter.default.post(notification)
            print("User updated")
        }
    }
    
    static func setUpListenerForAdventure() {
        let adventures = AdventureController.shared.allAdventures
        Firestore.firestore().collection("adventures").document("adventures").addSnapshotListener { (documentSnapShot, error) in
            guard let document = documentSnapShot, document.exists, let data = document.data() else {
                if let error = error {
                    print("Error fetching document: \(error)")
                }
                return
            }
            print("Current data: \(data)")
            let notification = Notification(name: AdventureUpdateNotification)
            NotificationCenter.default.post(notification)
            print("Adventure Updated")
        }
    }
}



