//
//  SignUpViewController.swift
//  Xplore
//
//  Created by Jack Knight on 2/5/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = #colorLiteral(red: 0.1670879722, green: 0.6660012007, blue: 0.5340312719, alpha: 1)
        nameTextField.layer.cornerRadius = nameTextField.frame.height / 2
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = #colorLiteral(red: 0.1670879722, green: 0.6660012007, blue: 0.5340312719, alpha: 1)
        emailTextField.layer.cornerRadius = emailTextField.frame.height / 2
        usernameTextField.layer.borderWidth = 1
        usernameTextField.layer.borderColor = #colorLiteral(red: 0.1670879722, green: 0.6660012007, blue: 0.5340312719, alpha: 1)
        usernameTextField.layer.cornerRadius = usernameTextField.frame.height / 2
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = #colorLiteral(red: 0.1670879722, green: 0.6660012007, blue: 0.5340312719, alpha: 1)
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height / 2
        signupButton.layer.cornerRadius = signupButton.frame.height / 2
    }
    
    
    //   MARK: - Actions
    @IBAction func singupButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text,
        !name.isEmpty,
        let email = emailTextField.text,
        !email.isEmpty,
        let username = usernameTextField.text,
        !username.isEmpty,
        let password = passwordTextField.text,
            !password.isEmpty else { presentRequiredFieldAlert() ; return}
        
        AppUserController.shared.signUpUser(name: name, emailAddress: email, username: username, password: password) { (success, error) in
            if let error = error {
                self.presentSignUpErrorAlert(error: error)
            } else {
                print("Success signing up")
            }
        }
    }
    func signUpSuccess() {
        self.performSegue(withIdentifier: "signupSuccess", sender: self)
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func presentRequiredFieldAlert() {
        let requiredFieldAlert = UIAlertController(title: "Missing Information!", message: "All fields are required.", preferredStyle: .alert)
        requiredFieldAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(requiredFieldAlert, animated: true)
    }
    
    func presentSignUpErrorAlert(error: Error) {
        let signUpErrorAlert = UIAlertController(title: "Error!", message: "\(error.localizedDescription)", preferredStyle: .alert)
        signUpErrorAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(signUpErrorAlert, animated: true)
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
