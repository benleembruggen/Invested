//
//  AddPostViewController.swift
//  Invested
//
//  Created by Ben Leembruggen on 25/5/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class AddPostViewController: UIViewController {

    @IBOutlet weak var stockField: UITextField!
    @IBOutlet weak var tipField: UISegmentedControl!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var addButton: UIButton!
    
    let docRef = Firestore.firestore().collection("posts")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add styling element to the page
        Style.styleTextField(stockField)
        Style.styleFilledButton(addButton)

        // looks for single or multiple taps, in order to dismiss the keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func addPost(_ sender: Any) {
        docRef.addDocument(data: [
            "stock": stockField.text!,
            "tip": tipField.titleForSegment(at: tipField.selectedSegmentIndex)!,
            "description": descriptionField.text!,
            "likes": 0
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
 
    
    // calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        // causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
