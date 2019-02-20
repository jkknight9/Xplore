//
//  LoginPageViewController.swift
//  Xplore
//
//  Created by Jack Knight on 2/5/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController {
   
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = emailTextField.frame.height / 2
        passwordTextField.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = emailTextField.frame.height / 2
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text,
        !email.isEmpty,
        let password = passwordTextField.text,
            !password.isEmpty, password.count >= 6 else {return}
        
        AppUserController.shared.logInUser(emailAddress: email, password: password) { (success, error) in
            if let error = error {
                self.presentLoginErrorAlert(error: error)
            }
            if success {
                self.performSegue(withIdentifier: "loginSuccess", sender: self)
            }
        }
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "signupSegue", sender: self)
    }
    
        func presentLoginErrorAlert(error: Error) {
            let logInErrorAlert = UIAlertController(title: "Error!", message: "\(error.localizedDescription)", preferredStyle: .alert)
            logInErrorAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(logInErrorAlert, animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

extension LoginPageViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
            self.loginButtonTapped(loginButton)
        }
        return true
    }
}
