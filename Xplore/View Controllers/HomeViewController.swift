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
    @IBOutlet var signUpVIew: UIView!
    @IBOutlet weak var landingPageImageView: UIImageView!
    @IBOutlet weak var sigupLabel: UILabel!
    
    // Source of truth
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
        signUpVIew.isHidden = AppUserController.shared.currentUser != nil ? true : false
        fetchAdventures()
        updateViews()
    }
    
    //Fetch for users events from firebase, maybe store locally
    func fetchAdventures() {
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
            if let profilePicture = AppUserController.shared.currentUser?.profilePic {
                DispatchQueue.main.async {
                    self.profilePicImageView.image = profilePicture
                }
            }else {
                AppUserController.shared.getProfilePic(for: currentUser, completion: { (image) in
                    DispatchQueue.main.async {
                        self.profilePicImageView.image = image
                        AppUserController.shared.currentUser?.profilePic = image
                    }
                })
            }
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let viewController = UIStoryboard(name: "SignInFlow", bundle: nil).instantiateViewController(withIdentifier: "signInVC") as UIViewController
        self.present(viewController, animated:  true, completion: nil)
    }
    
    @IBAction func createAdventureButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "createAdventure", sender: self)
    }
    
    //   MARK: - Actions
    @IBAction func mapViewOrTableView(_ sender: UISegmentedControl) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AdventureController.shared.adventures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let adventureCell = tableView.dequeueReusableCell(withIdentifier: "adventureCell", for: indexPath) as! MyAdventuresTableViewCell
        let adventure = AdventureController.shared.adventures[indexPath.row]
        adventureCell.adventureName.text = adventure.adventureName
        adventureCell.adventureDetails.text = adventure.details
        adventureCell.layer.shadowOpacity = 0.5
        adventureCell.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        
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
    
    //    Delete your adventures
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteAnadventure = AdventureController.shared.adventures[indexPath.row]
            AdventureController.shared.deleteAnAdventure(adventure: deleteAnadventure) { (success) in
                if success {
                    self.adventureTableView.deleteRows(at: [indexPath], with: .automatic)
                    print("Delete was succesful")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let destinationVC = segue.destination as? AdventureDetailViewController {
                if let indexPath = adventureTableView.indexPathForSelectedRow {
                    let adventure = AdventureController.shared.adventures[indexPath.row]
                    destinationVC.adventure = adventure
                }
            }
        }
    }
}
