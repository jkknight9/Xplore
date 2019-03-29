
//
//  PhotoCollectionViewCell.swift
//  Xplore
//
//  Created by Jack Knight on 2/11/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

protocol PhotoCollectionViewCellDelegate: class {
    func reportButtonTapped(sender: PhotoCollectionViewCell)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    let emailComposer = MessageComposer()
    
    weak var delegate: PhotoCollectionViewCellDelegate?
    
    var photoPair: PhotoPair? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        if let photo = photoPair?.image {
            self.photoImageView.image = photo
        }else {
            fetchAndSetImage()
        }
    }
    
    func fetchAndSetImage() {
        guard let url = photoPair?.photoUrl else { return }
        FirebaseManager.fetchPhotoFromFirebase(relativePath: url) { (_, image) in
            DispatchQueue.main.async {
                self.photoPair?.image = image
                self.photoImageView.image = image
            }
        }
    }
    
    @IBAction func reportPhotoButtonTapped(_ sender: Any) {
        delegate?.reportButtonTapped(sender: self)
    }
}
