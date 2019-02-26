//
//  LandingPageViewController.swift
//  Xplore
//
//  Created by Jack Knight on 2/5/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        AppUserController.shared.checkForLoggerInUser { (success) in
            if success {
                self.performSegue(withIdentifier: "loggedInUser", sender: self)
            } else {
                self.performSegue(withIdentifier: "toIntroductionPageVC", sender: self)
            }
        }
    }
}
