//
//  AddStockViewController.swift
//  Invested
//
//  Created by Ben Leembruggen on 30/4/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AddStockViewController: UIViewController {
    
    @IBOutlet weak var stockTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    let docRef = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add styling element to the page
        Style.styleTextField(stockTextField)
        Style.styleFilledButton(addButton)
        
        // looks for single or multiple taps, in order to dismiss the keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func addButtonClick(_ sender: Any) {
        // TODO add further validation to ensure that the stock is an actual position
        
        guard stockTextField.text != nil else {
            print("error with input")
            return
        }
        docRef.updateData([
            "positions": FieldValue.arrayUnion([stockTextField.text!])
        ])
        
        dismiss(animated: true, completion: nil)
    }
    
    // calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        // causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
