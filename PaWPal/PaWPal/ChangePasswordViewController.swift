//
//  ChangePasswordViewController.swift
//  PaWPal
//
//  Created by cs laptop on 10/27/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var newPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changePassword(sender: AnyObject) {
        guard let userPassword = newPassword.text
            where !userPassword.isEmpty else {
                self.displayAlert("Error", message: "Password not entered", handler: nil)
                return
        }
        
        DatabaseController.setPassword(newPassword.text!, controller: self, completion: {
            self.displayAlert("Password changed", message: "Your info is saved", handler: {
                (action) in self.dismissViewControllerAnimated(true, completion: nil)})
        })
    }
}

