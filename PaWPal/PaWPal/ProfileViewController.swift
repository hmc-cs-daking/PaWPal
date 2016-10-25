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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userEmailLabel.text = DatabaseController.getEmail()
        userNameTextField.text = DatabaseController.getName()
        userSchoolTextField.text = DatabaseController.getSchool()
        
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
        DatabaseController.setName(userName)
        DatabaseController.setSchool(userSchool ?? "")
        self.displayAlert("Saved", message: "Your info is saved", handler: nil)
        return
    }
    
}

