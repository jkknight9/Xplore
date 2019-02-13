//
//  MyPhotoDetailViewController.swift
//  Xplore
//
//  Created by Jack Knight on 2/12/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class MyPhotoDetailViewController: UIViewController {

 
    @IBOutlet weak var myPhotosCollectionView: UICollectionView!
   
    
    var photos: [UIImage] = [] {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    var selectedPosition: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myPhotosCollectionView.isPagingEnabled = true
        myPhotosCollectionView.frame = view.frame
    }
    
    func updateViews() {
        myPhotosCollectionView.reloadData()
        guard myPhotosCollectionView.numberOfItems(inSection: 0) >= selectedPosition else {return}
        let indexPath = IndexPath(row: selectedPosition, section: 0)
        myPhotosCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
}

extension MyPhotoDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myPhotosCell", for: indexPath) as! MyPhotosCollectionViewCell
        let photo = photos[indexPath.row]
        cell.photo = photo
       return cell
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


