//
//  MapAndListViewController.swift
//  Xplore
//
//  Created by Jack Knight on 2/12/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class MapAndListViewController: UIViewController {

    
    @IBOutlet weak var mapAndListSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var listContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listContainerView.isHidden = true
    }
    
    @IBAction func mapAndListSegmentTapped(_ sender: Any) {
        switch mapAndListSegmentedControl.selectedSegmentIndex {
        case 0:
            mapContainerView.isHidden = false
            listContainerView.isHidden = true
        case 1:
            mapContainerView.isHidden = true
            listContainerView.isHidden = false
        default:
            break
        }
    }
}
