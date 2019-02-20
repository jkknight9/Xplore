//
//  AdventureDetailViewController.swift
//  Xplore
//
//  Created by Jack Knight on 2/9/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit
import MapKit

class AdventureDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var adventureName: UILabel!
    @IBOutlet weak var navigateToMapsButton: UIButton!
    @IBOutlet weak var adventureDetailsLabel: UILabel!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    
    var photos = [UIImage]()
    var adventureID: String?
    var adventure: Adventure? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosCollectionView.dataSource = self
        adventureDetailsLabel.layer.cornerRadius = 20
        adventureDetailsLabel.layer.borderWidth = 1
        adventureDetailsLabel.layer.borderColor = UIColor.xploreGreen.cgColor
        photosCollectionView.layer.borderWidth = 1
        photosCollectionView.layer.borderColor = UIColor.xploreGreen.cgColor
        photosCollectionView.layer.cornerRadius = 5
        
    }
    
    @IBAction func navigateToMapsButtonTapped(_ sender: Any) {
    
        guard let adventureLocation = adventure?.location else {return}
        
        let usersLocationMapItem = MKMapItem.forCurrentLocation()
        
        let selectedPlacemark = MKPlacemark(coordinate: adventureLocation, addressDictionary: nil)
        let selecedMapItem = MKMapItem(placemark: selectedPlacemark)
        let mapItems = [selecedMapItem, usersLocationMapItem]
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        MKMapItem.openMaps(with: mapItems, launchOptions: launchOptions)
    }
    
    
    func fetchDetails(for adventure: Adventure) {
        PhotoController.shared.fetchPhotos(for: adventure) { (photos) in
            DispatchQueue.main.async {
                guard let photos = photos else {return}
                self.photos = photos
                self.photosCollectionView.reloadData()
            }
        }
    }
    
    // Collection View Data Source Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let photos = self.photos
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        let photo = photos[indexPath.row]
        cell.photo = photo
        return cell
    }
    
    func updateViews() {
        guard let adventure = adventure else {return}
        adventureName.text = adventure.adventureName
        adventureDetailsLabel.text = adventure.details
        fetchDetails(for: adventure)
    }
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoDetailsVC" {
            guard let indexPaths = photosCollectionView.indexPathsForSelectedItems,
                let indexPath = indexPaths.first,
                let destinationVC = segue.destination as? PhotoDetailViewController else {return}
            destinationVC.selectedPosition = indexPath.row
            destinationVC.photos = self.photos
        }
    }
}
