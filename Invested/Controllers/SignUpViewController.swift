//
//  SignUpViewController.swift
//  Invested
//
//  Created by Ben Leembruggen on 21/4/21.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
    }
    
    func setUpElements() {
        // hide error message
        errorLabel.alpha = 0
        
        // add styles to elements
        Style.styleTextField(firstNameTextField)
        Style.styleTextField(lastNameTextField)
        Style.styleTextField(emailTextField)
        Style.styleTextField(passwordTextField)
        Style.styleFilledButton(signUpButton)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // check the fields and validate the data is correct
    // if no error return nil, else return error message
    func validateFields() -> String? {
        // check all fields have a value
        if firstNameTextField.text == "" || lastNameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "" {
            return "Please fill in all fields"
        }
        
        // check password strength
        let cleanedPassword = passwordTextField.text!
        if Validation.isPasswordValid(cleanedPassword) == false {
            return "Please ensure your password is strong enough"
        }
        
        return nil
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        let destination = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        // overwrite root view controller
        view.window?.rootViewController = destination
        view.window?.makeKeyAndVisible()
    }

    @IBAction func signUpButtonClick(_ sender: Any) {
        // validate fields
        let error = validateFields()
        
        // show the error message to the user
        if error != nil {
            showError(error!)
        } else {
            // create user
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
                // check for errors
                if error != nil {
                    self.showError("Error creating user")
                } else {
                    // user was created successfully, now store first and last name
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstName": self.firstNameTextField.text!, "lastName": self.lastNameTextField.text!, "uid": authResult!.user.uid]) { (error) in
                        if error != nil {
                            // error adding data to db
                            self.showError("User data could not be added to database")
                        }
                    }
                }
            }
            // transition to home screen
            self.transitionToHome()
        }
        
    }
}
