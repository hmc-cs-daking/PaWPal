//
//  LoginViewController.swift
//  PaWPal
//
//  Created by Tiffany Fong on 9/13/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Login attempt
    @IBAction func enterCredentials(sender: AnyObject) {
        
        // Guards against invalid email
        guard let userEmail = userEmailTextField.text
            where userEmail.isValidEmail() else {
                self.displayAlert("Error", message: "Invalid email", handler: nil)
                return
        }
        
        // Guards against empty passwords
        guard let userPassword = userPasswordTextField.text
            where !userPassword.isEmpty else {
                self.displayAlert("Error", message: "Password not entered", handler: nil)
                return
        }
        
        activityIndicator.startAnimating()
        
        // sets up background thread to do time-intensive work
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            // time-intensive code
            DatabaseController.signIn(userEmail,
                userPassword: userPassword,
                completion: { LoginViewController.showTabContoller() },
                currentVC: self)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.activityIndicator.stopAnimating()
            })
        });
        

    }
    
    // If login is successful, go to main view.
    static func showTabContoller() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBarController
    }
    
    // accessible from other controllers/swift files
    static func showLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewControllerWithIdentifier("Login") as! LoginViewController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginVC
    }
}
