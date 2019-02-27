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
import Photos
import BSImagePicker

class CreateAdventureViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var adventureNameTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var uploadPhotosButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let locationManager = CLLocationManager()
    var photos: [UIImage] = []
    var selectedAssests = [PHAsset]()
    var currentLocation: CLLocation?
    var useCurrentLocation: Bool = false
    var placeholderLabel : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosCollectionView.dataSource = self
        scrollView.delegate = self
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
        setDoneOnKeyboard()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setDoneOnKeyboard() {
        let keyboardToolBar = UIToolbar()
        keyboardToolBar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolBar.items = [flexBarButton, doneBarButton]
        detailsTextView.inputAccessoryView = keyboardToolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func toggleCurrentLocationEnabledButton() {
        currentLocationButton.backgroundColor = useCurrentLocation ? .xploreGreen : .lightGray
        let buttonText = useCurrentLocation ? "Using My Location For Adventure" : "Not Using My location For Adventure"
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
        self.selectedAssests = []
        let vc = BSImagePickerViewController()
        self.bs_presentImagePickerController(vc, animated: true, select: { (asset: PHAsset) -> Void in
            
        }, deselect: { (asset:PHAsset) -> Void in
            
        }, cancel: { (assets: [PHAsset]) -> Void in
            
        }, finish: { (assets: [PHAsset]) -> Void in
            
            for i in 0..<assets.count {
                
                self.selectedAssests.append(assets[i])
            }
            self.convertAssetToImage()
            
        }, completion: nil)
    }
    
    func convertAssetToImage() -> Void {
        
        if selectedAssests.count != 0 {
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            var image = UIImage()
            options.isSynchronous = true
            
            for i in 0..<selectedAssests.count {
                
                manager.requestImage(for: selectedAssests[i], targetSize: CGSize(width: 1000, height: 1000), contentMode: .aspectFill, options: options, resultHandler: {(result, info) -> Void in image = result!
                    
                })
                
                if let data = image.jpegData(compressionQuality: 1.0) {
                    if let newImage = UIImage(data: data) {
                        self.photos.append(newImage)
                        
                    }
                }
            }
            DispatchQueue.main.async {
                self.photosCollectionView.reloadData()
            }
        }
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
