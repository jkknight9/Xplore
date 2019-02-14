//
//  MyAdventureViewController.swift
//  Xplore
//
//  Created by Jack Knight on 2/11/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class MyAdventureViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var adventureName: UILabel!
    @IBOutlet weak var adventureDetails: UILabel!
    @IBOutlet weak var addPhotosButton: UIButton!
    @IBOutlet weak var photoCollectionVIew: UICollectionView!
    
    
    var photos: [UIImage]?
    
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
       
        
}
    
    func fetchDetails(for adventure: Adventure) {
        PhotoController.shared.fetchPhotos(for: adventure) { (photos) in
            DispatchQueue.main.async {
                self.photos = photos
                self.photoCollectionVIew.reloadData()
            }
        }
    }
    
    // Collection View Data Source Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let photos = photos else {return 0}
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myPhotosCell", for: indexPath) as! MyPhotosCollectionViewCell
        let photo = photos?[indexPath.row]
        cell.myPostedImages.image = photo
        return cell
    }
    

    
     //   MARK: - Set up
    
    func updateViews() {
        guard let adventure = adventure else{return}
        adventureName.text = adventure.adventureName
        adventureDetails.text = adventure.details
        fetchDetails(for: adventure)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
