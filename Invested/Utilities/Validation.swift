//
//  Utilities.swift
//  Invested
//
//  Created by Ben Leembruggen on 21/4/21.
//  Sourced from https://www.youtube.com/watch?v=1HN7usMROt8

import Foundation
import UIKit

class Validation {
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}
