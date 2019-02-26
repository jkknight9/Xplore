//
//  PhotoPair.swift
//  Xplore
//
//  Created by Jack Knight on 2/21/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class PhotoPair {
    let photoUrl: String
    var image: UIImage?
    
    init(photoUrl: String, image: UIImage?){
        self.photoUrl = photoUrl
        self.image = image
    }
}
