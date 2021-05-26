//
//  Post.swift
//  Invested
//
//  Created by Ben Leembruggen on 25/5/21.
//

import Foundation

class Post {
    var likes: Int
    var stock: String
    var description: String
    var tip: String
    
    init(likes: Int, stock: String, description: String, tip: String) {
        self.likes = likes
        self.stock = stock
        self.description = description
        self.tip = tip
    }
}

