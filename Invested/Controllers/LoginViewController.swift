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

    @IBAction func loginButtonClicked(_ sender: Any) {
        // validate text fields
        
        
        // sign in the user
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            
            if error != nil {
                // couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
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
