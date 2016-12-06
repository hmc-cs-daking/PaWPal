//
//  ForgotPasswordViewController.swift
//  PaWPal
//
//  Created by cs laptop on 11/15/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetPassword(sender: AnyObject) {
        guard let email = emailTextField.text
            where email.isValidEmail() else {
                self.displayAlert("Hello", message: "Please enter an email", handler: nil)
                return
        }
        DatabaseController.resetPassword(self, email: email)
    }
    
    @IBAction func cancelReset(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

