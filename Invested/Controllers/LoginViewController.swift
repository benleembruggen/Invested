//
//  LoginViewController.swift
//  Invested
//
//  Created by Ben Leembruggen on 21/4/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        // hide error message
        errorLabel.alpha = 0
        
        // add styles to elements
        Style.styleTextField(emailTextField)
        Style.styleTextField(passwordTextField)
        Style.styleFilledButton(loginButton)
    }
    
    // check the fields and validate the data is correct
    // if no error return nil, else return error message
    func validateFields() -> String? {
        if emailTextField.text == "" || passwordTextField.text == "" {
            return "Please fill in all fields"
        }
        return nil
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }

    @IBAction func loginButtonClicked(_ sender: Any) {
        // validate text fields
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        } else {
            // sign in the user
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                
                if error != nil {
                    self.showError("Error when signing in the user")
                }
                else {
                    // user can sign in
                    let destination = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                    
                    self.view.window?.rootViewController = destination
                    self.view.window?.makeKeyAndVisible()
                }
                
            }
        }
    }
}
