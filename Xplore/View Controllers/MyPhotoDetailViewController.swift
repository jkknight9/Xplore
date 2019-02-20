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
        myPhotosCollectionView.delegate = self
        myPhotosCollectionView.dataSource = self
        myPhotosCollectionView.isPagingEnabled = true
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}



