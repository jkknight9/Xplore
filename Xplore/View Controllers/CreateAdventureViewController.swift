//
//  CreateAdventureViewController.swift
//  Xplore
//
//  Created by Jack Knight on 2/11/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CreateAdventureViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var adventureNameTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var uploadPhotosButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    private let locationManager = CLLocationManager()
    var photos: [UIImage] = []
    var currentLocation: CLLocation?
    var useCurrentLocation: Bool = false
    var placeholderLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosCollectionView.dataSource = self
        adventureNameTextField.layer.borderWidth = 2
        adventureNameTextField.layer.borderColor = #colorLiteral(red: 0.1670879722, green: 0.6660012007, blue: 0.5340312719, alpha: 1)
        adventureNameTextField.layer.cornerRadius = 5
        detailsTextView.layer.cornerRadius = 5
        photosCollectionView.layer.cornerRadius = 5
        uploadPhotosButton.layer.cornerRadius = adventureNameTextField.frame.height / 2
        photosCollectionView.layer.borderWidth = 2
        photosCollectionView.layer.borderColor = #colorLiteral(red: 0.1670879722, green: 0.6660012007, blue: 0.5340312719, alpha: 1)
        detailsTextView.layer.borderWidth = 2
        detailsTextView.layer.borderColor = #colorLiteral(red: 0.1670879722, green: 0.6660012007, blue: 0.5340312719, alpha: 1)
        currentLocationButton.layer.cornerRadius = currentLocationButton.frame.height / 2
        detailsTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter Details..."
        placeholderLabel.sizeToFit()
        detailsTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (detailsTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !detailsTextView.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    private func toggleCurrentLocationEnabledButton() {
        currentLocationButton.backgroundColor = useCurrentLocation ? .xploreGreen : .lightGray
        let buttonText = useCurrentLocation ? "Using My Location" : "Not Using My location"
        currentLocationButton.setTitle(buttonText, for: .normal)
    }
    
    private func createAdventureForData() {
        guard let adventureName = adventureNameTextField.text,
            !adventureName.isEmpty,
            let curretnUserId = AppUserController.shared.currentUser?.uuid,
            let details = detailsTextView.text else { return }
        
        let currentCoordiate = useCurrentLocation ? currentLocation?.coordinate : nil
        AdventureController.shared.createAnAdventure(adventureName: adventureName, details: details, location: currentCoordiate, creatorID: curretnUserId, photos: photos) { (adventure) in
            guard adventure != nil else {
                self.presentSimpleAlert(title: "Whoops", message: "We can't create this adventure right now.  Please try again later.", compleitionHandler: nil)
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        createAdventureForData()
    }
    
    @IBAction func useCoreLocationButtonTapped(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            useCurrentLocation.toggle()
            toggleCurrentLocationEnabledButton()
        }
    }
    
    
    @IBAction func uploadPhotosButtonTapped(_ sender: Any) {
        presentImagePicker()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - ImagePickerDelegate
extension CreateAdventureViewController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photos.append(photo)
            photosCollectionView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - UICollectionViewDataSource
extension CreateAdventureViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        let photo = photos[indexPath.row]
        cell.photoImageView.image = photo
        return cell
    }
}

//MARK CLLocationManagerDelegate
extension CreateAdventureViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.first
        toggleCurrentLocationEnabledButton()
    }
}
