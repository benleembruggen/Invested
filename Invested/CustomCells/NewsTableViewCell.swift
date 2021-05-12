//
//  NewsTableViewCell.swift
//  Invested
//
//  Created by Ben Leembruggen on 12/5/21.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var imageRef: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
