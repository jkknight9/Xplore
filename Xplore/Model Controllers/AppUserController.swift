//
//  AppUserController.swift
//  Xplore
//
//  Created by Jack Knight on 2/7/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class AppUserController {
    
    //   MARK: - Shared Instance
    
    static let shared = AppUserController()
    private init(){}
    
    //   MARK: - Source of Truth
    
    var currentUser: AppUser? {
        didSet {
            if let currentUser = currentUser {
                print("The current user username is :\(currentUser.username)")
            }
        }
    }
    
    //   MARK: - User Functions
    
    // Check if current user is logged in
    func checkForLoggerInUser(completion: @escaping (Bool) -> Void) {
        FirebaseManager.getLoggedInUser { (currentLoggedInUser) in
            if let currentLoggedInUser = currentLoggedInUser {
                self.currentUser = currentLoggedInUser
                FirebaseManager.setUpListenerForUser()
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    // Log in a User
    func logInUser(emailAddress: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        FirebaseManager.logInWith(emailAddress: emailAddress, password: password) { (loggedInUser, error) in
            if let error = error {
                print("Error signing in the user \(error.localizedDescription)")
                completion(false, error)
                return
            }
            if let loggedInUser = loggedInUser {
                self.currentUser = loggedInUser
                completion(true, nil)
                return
            }
        }
    }
    //Sign up a new user
    func signUpUser(name: String, emailAddress: String, username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        FirebaseManager.signUp(name: name, emailAddress: emailAddress, username: username, password: password) { (firebaseUser, error) in
            if let error = error {
                print("Error saving a new user to firebase database: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            if let newUser = firebaseUser {
                self.currentUser = newUser
                completion(true, nil)
                return
            }
        }
    }
    
    //Log out a user
    func logOutUser(completion: @escaping (Bool) -> Void) {
        guard let currentUser = currentUser else {return}
        FirebaseManager.signOut { (error) in
            if let error = error {
                print("There was an error signing out user \(currentUser.name). \(error) ; \(error.localizedDescription)")
                completion(false)
                return
            } else {
                self.currentUser = nil
                completion(true)
                return
            }
        }
    }
    
    // User forgot password
    func forgotPassword(emailAddess: String, completion: @escaping (Bool) -> Void) {
        FirebaseManager.forgotPassword(emailAddress: emailAddess) { (success) in
            if success {
                print("Successfully sent password to email to \(emailAddess)")
                completion(true)
                return
            } else {
                print("There was a problem sending password reset to \(emailAddess)")
                completion(false)
                return
            }
        }
    }
    
    //Change info
    func changeUserInfo(user: AppUser, completion: @escaping (Bool) -> Void) {
        FirebaseManager.updateData(object: user, dictionary: user.dictionary) { (error) in
            if let error = error {
                print("There was an error updating \(user.name); \(error) ; \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
            self.currentUser = user
        }
    }
    
    func getProfilePic(for user: AppUser, completion: @escaping (UIImage?) -> Void) {
        guard let profilePicURL = user.profilePicURL else { completion(nil) ; return }
        FirebaseManager.fetchPhotoFromFirebase(url: profilePicURL) { (success, image) in
            if success{
                print("There was an error fetching profile pic \(profilePicURL)")
                completion(image)
                return
            }
            completion(nil)
            return
        }
    }
}

