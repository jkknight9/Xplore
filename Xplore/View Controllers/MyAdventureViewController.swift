//
//  MyAdventureViewController.swift
//  Xplore
//
//  Created by Jack Knight on 2/11/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class MyAdventureViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet weak var adventureName: UILabel!
    @IBOutlet weak var adventureDetails: UILabel!
    @IBOutlet weak var addPhotosButton: UIButton!
    @IBOutlet weak var photoCollectionVIew: UICollectionView!
    
    var photos = [UIImage]()
    
    // Landing Pad
    var adventureID: String?
    var adventure: Adventure? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionVIew.dataSource = self
        adventureDetails.layer.cornerRadius = 20
        adventureDetails.layer.borderWidth = 1
        adventureDetails.layer.borderColor = UIColor.xploreGreen.cgColor
        addPhotosButton.layer.cornerRadius = addPhotosButton.frame.height / 2
        photoCollectionVIew.layer.borderWidth = 1
        photoCollectionVIew.layer.borderColor = UIColor.xploreGreen.cgColor
        photoCollectionVIew.layer.cornerRadius = 5
        
}
    
    func fetchDetails(for adventure: Adventure) {
        PhotoController.shared.fetchPhotos(for: adventure) { (photos) in
            DispatchQueue.main.async {
                guard let photos = photos else {return}
                self.photos = photos
                self.photoCollectionVIew.reloadData()
            }
        }
    }
    
    // Collection View Data Source Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         let photos = self.photos 
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myPhotosCell", for: indexPath) as! MyPhotosCollectionViewCell
        let photo = photos[indexPath.row]
        cell.myPostedImages.image = photo
        return cell
        
    }

    //   MARK: - Actions
    
    @IBAction func addPhotosToAdventure(_ sender: Any) {
        presentImagePicker()
    }
    
     //   MARK: - Set up
    
    func updateViews() {
        guard let adventure = adventure else{return}
        adventureName.text = adventure.adventureName
        adventureDetails.text = adventure.details
        fetchDetails(for: adventure)
    }
    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotosDetailsVC" {
            guard let indexPaths = photoCollectionVIew.indexPathsForSelectedItems,
                let indexPath = indexPaths.first,
                let destinationVC = segue.destination as? MyPhotoDetailViewController else {return}
            destinationVC.selectedPosition = indexPath.row
            destinationVC.photos = self.photos
            
        }
    }
}

extension MyAdventureViewController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let currentAdventure = adventure{
            PhotoController.shared.add(photo: photo, to: currentAdventure) {
                self.photos.append(photo)
                DispatchQueue.main.async {
                    
                    picker.dismiss(animated: true, completion: {
                        self.photoCollectionVIew.reloadData()
                    })
                }
            }
        }
    }
}
