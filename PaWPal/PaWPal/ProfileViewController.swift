//
//  ProfileViewController.swift
//  PaWPal
//
//  Created by cs laptop on 9/9/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userSchoolTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userEmailLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")
        userNameTextField.text = NSUserDefaults.standardUserDefaults().stringForKey("userName")
        userSchoolTextField.text = NSUserDefaults.standardUserDefaults().stringForKey("userSchool")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //store input from the user
    @IBAction func saveProfile() {
        
        // guard against empty name
        guard let userName = userNameTextField.text
            where !userName.isEmpty else {
                self.displayAlert("Error", message: "You need a name!", handler: nil)
                return
        }
        
        let userSchool = userSchoolTextField.text
        
        // save the school and name of the user
        NSUserDefaults.standardUserDefaults().setObject(userName, forKey: "userName")
        NSUserDefaults.standardUserDefaults().setObject(userSchool, forKey: "userSchool")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.displayAlert("Saved", message: "Your info is saved", handler: nil)
        return
    }
    
}

