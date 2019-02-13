//
//  IntroductionViewController.swift
//  Xplore
//
//  Created by Jack Knight on 2/5/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class IntroductionViewController: UIViewController {

    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var xploreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        displayView.layer.shadowOpacity = 0.8
        displayView.layer.shadowOffset = CGSize(width: 0, height: 10.0)
        xploreButton.layer.cornerRadius = xploreButton.frame.height / 2
    }

    @IBAction func xploreButtonTapped(_ sender: UIButton) {
        segueOverToLoginInPage()
    }
    
    func segueOverToLoginInPage() {
        self.performSegue(withIdentifier: "toLoginPage", sender: self)
    }
    
    func animate() {
        UIView.animate(withDuration: 0.2, delay: 0.3, options: [.curveLinear], animations: {
            self.displayView.alpha = 0
        }, completion: nil)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
