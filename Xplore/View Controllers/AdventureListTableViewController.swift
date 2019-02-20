//
//  AdventureListTableViewController.swift
//  Xplore
//
//  Created by Jack Knight on 2/12/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class AdventureListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
 
    @IBOutlet weak var adventureTableView: UITableView!
    
    // Source of truth
    var adventures: [Adventure]?
    var allAdventures: [Adventure]?
    private let refreshControl = UIRefreshControl()
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adventureTableView.delegate = self
        adventureTableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: MapViewController.allAdventuresReceived, object: nil)
        reloadTableView()
    }

    
    @objc func reloadTableView() {
        DispatchQueue.main.async {
            self.adventureTableView.reloadData()
        }
        self.refreshControl.endRefreshing()
        self.activityIndicator.stopAnimating()
        
    }

// MARK: - Table view data source

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return AdventureController.shared.allAdventures.count
    
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "adventureCell", for: indexPath) as! AdventureTableViewCell
    let adventure = AdventureController.shared.allAdventures[indexPath.row]
    cell.adventureNameLabel.text = adventure.adventureName
    cell.adventureDetailsLabel.text = adventure.details
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(reloadTableView), for: .valueChanged)
    refreshControl.tintColor = UIColor.xploreGreen
    return cell
}
    
   // MARK: - Navigation
 
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toAdventureDetailVC" {
        if let destinationVC = segue.destination as? AdventureDetailViewController {
            if let indexPath = adventureTableView.indexPathForSelectedRow {
                let adventure = AdventureController.shared.allAdventures[indexPath.row]
                destinationVC.adventure = adventure
                }
            }
        }
    }
}

