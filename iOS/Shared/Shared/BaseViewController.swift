//
//  BaseViewController.swift
//  Shared
//
//  Created by kankan on 29/04/20.
//  Copyright © 2020 queuesafe. All rights reserved.
//

import Foundation
import UIKit

open class BaseViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .black
        
        if let _ = scrollViewBottomConstraint {
             NotificationCenter.default.addObserver(self, selector: #selector(_KeyboardHeightChanged(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        }
    }
    
    @objc private func _KeyboardHeightChanged(_ notification: Notification){
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let y = frame.cgRectValue.origin.y
            UIView.animate(withDuration: 0.5, animations: {
                if y >= self.view.bounds.height {
                    self.scrollViewBottomConstraint?.constant = 0
                } else {
                    self.scrollViewBottomConstraint?.constant = self.view.bounds.height - y
                }
            })
        }
    }
    
    public func showDialog(_ title: String, message: String, actions: [UIAlertAction]? = nil) {
        
        let popup = UIAlertController( title: title,
                                       message: message,
                                       preferredStyle: .alert )
        
        if let actions = actions, actions.count > 0 {
            actions.forEach { action in
                popup.addAction(action)
            }
        } else {
            popup.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            }))
        }
        self.present(popup, animated: true, completion: nil)
    }
    
    public func showNetworkErrorDialog() {
        showErrorDialog(message: "Please check your internet connectivity and try again later.")
    }
    
    public func showErrorDialog(message: String?) {
        if let message = message {
            showDialog("Attention", message: message)
        } else {
            showGenericDialog()
        }
    }
    
    public func showGenericDialog() {
        showDialog("Attention", message: "We are unable to validate your information. Please try again later.")
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
