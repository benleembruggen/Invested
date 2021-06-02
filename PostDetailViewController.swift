//
//  PostDetailViewController.swift
//  Invested
//
//  Created by Ben Leembruggen on 2/6/21.
//

import UIKit

class PostDetailViewController: UIViewController {

    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    
    var titleText: String?
    var tipText: String?
    var postDescription: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTitleLabel.text = titleText
        tipLabel.text = tipText
        descriptionText.text = postDescription
        
        // set the colour for the tip
        if tipText == "Buy" {
            tipLabel.textColor = .green
        } else if tipText == "Sell" {
            tipLabel.textColor = .red
        } else if tipText == "Hold" {
            tipLabel.textColor = .lightGray
        }
    }
}
