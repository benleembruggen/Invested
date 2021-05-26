//
//  PostTableViewCell.swift
//  Invested
//
//  Created by Ben Leembruggen on 25/5/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
