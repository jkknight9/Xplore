//
//  CustomPointAnnotation.swift
//  Xplore
//
//  Created by Jack Knight on 2/15/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit
import MapKit

class CustomPointAnnotation: MKPointAnnotation {
    var adventure: Adventure? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let adventure = adventure,
        let location = adventure.location else { return }
        self.title = adventure.adventureName
        self.subtitle = adventure.details
        self.coordinate = location
    }
}
