//
//  ForgotPasswordViewController.swift
//  Xplore
//
//  Created by Jack Knight on 2/5/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: PaddingTextField!
    @IBOutlet weak var emailLinkButton: UIButton!
    @IBOutlet weak var backToLoginButton: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        emailTextField.layer.cornerRadius = emailTextField.frame.height / 2
        emailTextField.clipsToBounds = true
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = #colorLiteral(red: 0.1670879722, green: 0.6660012007, blue: 0.5340312719, alpha: 1)
        emailLinkButton.layer.cornerRadius = emailLinkButton.frame.height / 2
    }
    
    @IBAction func emailLinkButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        if email.isEmpty {
        } else {
            AppUserController.shared.forgotPassword(emailAddess: email) { (success) in
                if success {
                }
            }
        }
    }
    
    @IBAction func backToLoginButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            self.emailLinkButtonTapped(emailLinkButton)
        }
        return true
    }
}
