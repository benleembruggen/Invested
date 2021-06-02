//
//  ViewController.swift
//  Invested
//
//  Created by Ben Leembruggen on 21/4/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        // add styles to elements
        Style.styleFilledButton(signUpButton)
        Style.styleHollowButton(loginButton)
    }


}

