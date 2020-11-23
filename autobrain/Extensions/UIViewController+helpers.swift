//
//  UIViewController+helpers.swift
//  Autobrain
//
//  Created by Kyle Smith on 7/28/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func message( _ title: String, message: String) {
        
        Session.performSync { () -> Void in
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func ask( _ title: String, message: String, title1: String, title2: String?, handler1: ((UIAlertAction) -> Void)?, handler2: ((UIAlertAction) -> Void)?) {
        
        Session.performSync { () -> Void in
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: title1, style: UIAlertAction.Style.default, handler: handler1))
            
            if let title2 = title2 {
                alert.addAction(UIAlertAction(title: title2, style: UIAlertAction.Style.default, handler: handler2))
            }
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func ask( _ title: String, message: String, closeTitle: String, destructiveTitle: String, destructiveHandler: ((UIAlertAction) -> Void)?) {
        
        Session.performSync { () -> Void in
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: closeTitle, style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: destructiveTitle, style: UIAlertAction.Style.destructive, handler: destructiveHandler))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

