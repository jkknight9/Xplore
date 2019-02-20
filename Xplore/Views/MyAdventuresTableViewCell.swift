//
//  MyAdventuresTableViewCell.swift
//  Xplore
//
//  Created by Jack Knight on 2/11/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class MyAdventuresTableViewCell: UITableViewCell {
    
    @IBOutlet weak var adventureName: UILabel!
    @IBOutlet weak var adventureDetails: UILabel!
    
   // Landing Pad
    var photo: Photo?
    var adventure: Adventure? {
        didSet{
            updateViews()
        }
    }
    
    func updateViews() {
        guard let adventure = adventure else {return}
        
        DispatchQueue.main.async {
            self.adventureName.text = adventure.adventureName
            self.adventureDetails.text = adventure.details
        }
    }
}
