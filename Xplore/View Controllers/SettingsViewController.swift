//
//  SettingsViewController.swift
//  Xplore
//
//  Created by Jack Knight on 2/9/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var changeProfilePicture: UIButton!
    @IBOutlet weak var changeUsernameButton: UIButton!
    @IBOutlet weak var changeNameButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    // Landing Pad
    var currentUser = AppUserController.shared.currentUser
    
    var photo: UIImage = UIImage() {
        didSet {
            self.profilePicImageView.image = photo
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.height / 2
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateViews()
    }
    
    
    //Update Views
    func updateViews() {
        guard let currentUser = currentUser else {return}
        nameLabel.text = currentUser.name
        usernameLabel.text = currentUser.username
        if let currentUser = AppUserController.shared.currentUser {
            if let profilePicture = AppUserController.shared.currentUser?.profilePic {
                DispatchQueue.main.async {
                    self.profilePicImageView.image = profilePicture
                }
            }else {
                AppUserController.shared.getProfilePic(for: currentUser, completion: { (image) in
                    DispatchQueue.main.async {
                        self.profilePicImageView.image = image
                        AppUserController.shared.currentUser?.profilePic = image
                    }
                })
            }
        }
    }
    
    //   MARK: - Actions
    @IBAction func changeProfilePicButtonTapped(_ sender: Any) {
        selectImage()
    }
    
    func selectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let imagePickerActionSheet = UIAlertController(title: "Select Photo", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePickerActionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePickerController, animated:  true, completion:  nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerActionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        imagePickerActionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(imagePickerActionSheet, animated: true)
    }
    
    // Change User's Name
    @IBAction func changeDisplayNameButton(_ sender: Any) {
        guard let currentUser = currentUser else {return}
        let changeDisplayNameAlert = UIAlertController(title: "Change Name", message: "Your current name is \(currentUser.name)", preferredStyle: .alert)
        changeDisplayNameAlert.addTextField { (textField) in
            textField.placeholder = "New Name Here"
        }
        changeDisplayNameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        changeDisplayNameAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (okayAction) in
            guard let newNameText = changeDisplayNameAlert.textFields?.first?.text else {return}
            self.nameLabel.text = newNameText
            self.currentUser?.name = newNameText
            self.saveChangesToFirebase()
            
        }))
        present(changeDisplayNameAlert, animated:  true)
    }
    // Change Username
    @IBAction func changeUsernameButtonTapped(_ sender: Any) {
        guard let currentUser = currentUser else {return}
        let changeUsernameAlert = UIAlertController(title: "Change Username", message: "Current Username is \(currentUser.username)", preferredStyle: .alert)
        changeUsernameAlert.addTextField { (textField) in
            textField.placeholder = "New Username"
        }
        changeUsernameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        changeUsernameAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (okayAction) in
            guard let newUsernameText = changeUsernameAlert.textFields?.first?.text else { return }
            self.usernameLabel.text = newUsernameText
            self.currentUser?.username = newUsernameText
            self.saveChangesToFirebase()
        }))
        present(changeUsernameAlert, animated: true)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        AppUserController.shared.logOutUser { (success) in
            if success {
                print("The user has logged out")
                self.performSegue(withIdentifier: "landingPage", sender: self)
            }
        }
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        FirebaseManager.deleteLoggedInUser { (success) in
            if success {
                print("User Deleted❌")
                self.performSegue(withIdentifier: "landingPage", sender: self)
            } else {
                print("Error deleting user.")
            }
        }
    }
    
    func saveChangesToFirebase() {
        guard let currentUser = currentUser else {return}
        AppUserController.shared.changeUserInfo(user: currentUser) { (success) in
            if !success {
                print("Error saving changes to database")
            }
        }
    }
}

 //   MARK: - ImagePickerControllerDelegate
extension SettingsViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.photo = photo
            currentUser?.profilePic = photo
            guard let currentUser = currentUser else {return}
            let newProfilePicture = Photo(image: photo, creatorID: currentUser.uuid, adventureID: "")
            FirebaseManager.uploadPhotoToFirebase(newProfilePicture) { (url, error) in
                if let error = error {
                    print("There was an error uploading to firebase storage: \(error.localizedDescription)")
                    return
                }
                if let url = url {
                    currentUser.profilePicURL = "\(url)"
                    newProfilePicture.imageURL = "\(url)"
                    AppUserController.shared.changeUserInfo(user: currentUser, completion: { (success) in
                        if success {
                            print("Success updating current user info")
                        } else {
                            print("Error updating users info")
                        }
                    })
                    FirebaseManager.saveData(object: newProfilePicture, completion: { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    })
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
