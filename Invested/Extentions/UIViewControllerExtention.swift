//
//  UIViewControllerExtention.swift
//  Invested
//
//  Created by Ben Leembruggen on 3/5/21.
//

import Foundation
import UIKit

var activityView: UIView?

extension UIViewController {
    // message display extention for UIViewController
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showSpinner() {
        activityView = UIView(frame: self.view.bounds)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = activityView!.center
        activityIndicator.startAnimating()
        activityView?.addSubview(activityIndicator)
        self.view.addSubview(activityView!)
    }
    
    func removeSpinner() {
        activityView?.removeFromSuperview()
        activityView = nil
    }
}

