//
//  AdventureTableViewCell.swift
//  Xplore
//
//  Created by Jack Knight on 2/14/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit
import CoreLocation

class AdventureTableViewCell: UITableViewCell {

   
    @IBOutlet weak var adventureNameLabel: UILabel!
    @IBOutlet weak var adventureDetailsLabel: UILabel!
    @IBOutlet weak var distanceAwayLabel: UILabel!
    
// Landing Pad
    var photo: Photo?
    var adventure: Adventure? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let adventure = adventure else {return}
        
        DispatchQueue.main.async {
            self.adventureNameLabel.text = adventure.adventureName
            self.adventureDetailsLabel.text = adventure.details
//            self.distanceAwayLabel.text = adventure.distanceFromUser
        }
    }
}
