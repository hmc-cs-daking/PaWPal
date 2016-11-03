//
//  RegisterViewController.swift
//  PaWPal
//
//  Created by Tiffany Fong on 9/13/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userRepeatPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Registers new users - unless fields are invalid
    @IBAction func createRegistration(sender: AnyObject) {
        
        // Guards against invalid email
        guard let userEmail = userEmailTextField.text
            where userEmail.isValidEmail() else {
                self.displayAlert("Error", message: "Invalid email", handler: nil)
                return
        }
        
        // Guards against short passwords
        guard let userPassword = userPasswordTextField.text
            where userPassword.characters.count >= 6 else {
                self.displayAlert("Error", message: "Password must be at least 6 characters", handler: nil)
                return
        }
        
        // Guards against different passwords
        guard let userRepeatPassword = userRepeatPasswordTextField.text
            where userPassword == userRepeatPassword else {
                self.displayAlert("Error", message: "Passwords do not match", handler: nil)
                return
        }
        
        // Store data
        DatabaseController.signUp(userEmail, userPassword: userPassword,
                                  completion: { self.successRegistration() },
                                  currentVC: self)
        
    }
    
    func successRegistration() {
        self.displayAlert("Success!", message: "Registration successful. Thank you!",
                          handler: {action in self.dismissViewControllerAnimated(true, completion: nil)})
    }
    
    // Go back to login page
    @IBAction func cancelRegistration(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
