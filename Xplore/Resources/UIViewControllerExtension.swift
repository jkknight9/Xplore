//
//  UIViewControllerExtension.swift
//  Xplore
//
//  Created by Jack Knight on 2/11/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentImagePicker() {
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
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {
    func presentSimpleAlert(title: String, message: String?, compleitionHandler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: compleitionHandler)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
    }
}
