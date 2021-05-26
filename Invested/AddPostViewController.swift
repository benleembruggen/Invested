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
        if stockField.text == "" {
            displayMessage(title: "Error creating psot", message: "Please enter a stock symbol")
            return
        } else if descriptionField.text == "" {
            displayMessage(title: "Error creating psot", message: "Please enter a description for your post")
            return
        }
        
        // check that the stock is valid by calling the API
        guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/market/batch") else {
            print("URL not valid")
            return
        }
        
        // add query params to the API string
        let queryItems = [URLQueryItem(name: "symbols", value: stockField.text),
                          URLQueryItem(name: "types", value: "quote"),
                          URLQueryItem(name: "token", value: Constants.API.APIKey)]
        let newUrl = url.appending(queryItems)!
        
        // make the request to the API and sotre data
        let task = URLSession.shared.dataTask(with: newUrl) { data, response, error in
            if let error = error {
                print("The inputed stock is not valid \(error)")
            }
            let httpResponse = response as! HTTPURLResponse
            
            // check if the stock entered is valid
            if httpResponse.statusCode == 404 {
                DispatchQueue.main.async {
                    self.displayMessage(title: "Invalid stock", message: "The stock that you have eneted is not a valid symbol")
                }
            } else if data != nil {
                // add the new symbol to the users positoins in firebase
                DispatchQueue.main.async {
                    self.docRef.addDocument(data: [
                        "stock": self.stockField.text!,
                        "tip": self.tipField.titleForSegment(at: self.tipField.selectedSegmentIndex)!,
                        "description": self.descriptionField.text!,
                        "likes": 0
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                } 
            }
        }
        task.resume()
    }
    
    // calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        // causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
