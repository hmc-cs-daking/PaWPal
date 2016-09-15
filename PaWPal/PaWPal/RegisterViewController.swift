//
//  RegisterViewController.swift
//  PaWPal
//
//  Created by Tiffany Fong on 9/13/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit

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
    // Currently, a single device's login data is stored using NSUserDefaults
    // Eventually, login data for multiple devices/users will be stored in a database
    @IBAction func createRegistration(sender: AnyObject) {
        
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let userRepeatPassword = userRepeatPasswordTextField.text
        
        // Check validity
        // TODO: check valid email address
        if (userEmail!.isEmpty || userPassword!.isEmpty || userRepeatPassword!.isEmpty) {
            displayAlert("All fields must be filled", handler: nil)
        }
        if (!userEmail!.isValidEmail()) {
            displayAlert("Invalid email", handler: nil)
        }
        else if (userPassword != userRepeatPassword) {
            displayAlert("Passwords do not match", handler: nil)
        }
        else {
            // Store data
            // TODO: find a more secure way to store data
            NSUserDefaults.standardUserDefaults().setObject(userEmail, forKey: "userEmail")
            NSUserDefaults.standardUserDefaults().setObject(userPassword, forKey: "userPassword")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            // Go back to login page
            displayAlert("Registration successful. Thank you!", handler: { action in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
        }
        
    }
    
    // Customize message and exit handler method
    // TODO potential: move this func to an extension of TabBarConroller
    func displayAlert(message: String, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "Alert", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(
            title: "Ok",
            style: UIAlertActionStyle.Default,
            handler: handler))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Go back to login page
    @IBAction func cancelRegistration(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
