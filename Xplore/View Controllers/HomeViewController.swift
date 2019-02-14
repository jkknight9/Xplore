//
//  HomeViewController.swift
//  Xplore
//
//  Created by Jack Knight on 2/8/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var mapAndListControl: UISegmentedControl!
    @IBOutlet weak var adventureTableView: UITableView!
    @IBOutlet weak var mapViewOrTableView: UISegmentedControl!
    @IBOutlet weak var createButton: UIButton!
    // Source of truth
    var adventures: [Adventure]? 
//        didSet {
//            self.adventureTableView.reloadData()
//        }
    
    let cellSpacingHeight: CGFloat = 10
    
    var currentUser = AppUserController.shared.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createButton.layer.cornerRadius = createButton.frame.height / 2
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.height / 2
        adventureTableView.backgroundColor = UIColor.clear
        adventureTableView.dataSource = self
        adventureTableView.delegate = self
        updateViews()
}
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAdventures()
    }
    
    //Fetch for users events from firebase, maybe store locally
    func fetchAdventures() {
        // Create a func in AdventureController to fetch the adventures (needs a completion)
        guard let currentUser = currentUser else { return}
        FirebaseManager.fetchFireStoreWithFieldAndCriteria(for: "creatorID", criteria: currentUser.uuid, inArray: false) { (adventures: [Adventure]?) in
            if let adventures = adventures {
                AdventureController.shared.adventures = adventures
                DispatchQueue.main.async {
                    self.adventureTableView.reloadData()                    
                }
            }
        }
    }

    // Update the views
    func updateViews() {
        nameLabel.text = currentUser?.name
        usernameLabel.text = currentUser?.username
        if let currentUser = AppUserController.shared.currentUser {
            AppUserController.shared.getProfilePic(for: currentUser, completion: { (image) in
                DispatchQueue.main.async {
                    self.profilePicImageView.image = image
                }
            })
        }
        
    }
    @IBAction func createAdventureButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "createAdventure", sender: self)
    }
    
     //   MARK: - Actions
    

    @IBAction func mapViewOrTableView(_ sender: UISegmentedControl) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let adventures = adventures else {return 0}
        return AdventureController.shared.adventures.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let adventureCell = tableView.dequeueReusableCell(withIdentifier: "adventureCell", for: indexPath) as! MyAdventuresTableViewCell
        let adventure = AdventureController.shared.adventures[indexPath.row]
        adventureCell.adventureName.text = adventure.adventureName
        adventureCell.adventureDetails.text = adventure.details
        adventureCell.layer.borderWidth = 1
        adventureCell.layer.borderColor = UIColor.xploreGreen.cgColor
        adventureCell.layer.cornerRadius = 10
        
        adventureCell.clipsToBounds = true
        return adventureCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    
    
   // Delete your adventures
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let deleteAnadventure = adventures?[indexPath.row]
//            AdventureController.shared.deleteAnAdventure(adventure: deleteAnadventure!) { (success) in
//                if !success {
//                    print("There was an error deleting an adventure from list of adventures.")
//                } else {
//
//                }
//            }
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMyAdventureDetail" {
            if let destinationVC = segue.destination as? MyAdventureViewController {
                if let indexPath = adventureTableView.indexPathForSelectedRow {
                    let adventure = AdventureController.shared.adventures[indexPath.row]
                    destinationVC.adventure = adventure
                }
            }
        }
    }
}
