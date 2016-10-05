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
        
        let errorMessage = "The password is invalid or the user does not have a password."
        
        DatabaseController.signIn(userEmail,
                                  userPassword: userPassword,
                                  completion: {self.removeLoginFromView()
                                                self.scheduleWeeklyNotifications()},
                                  failure: {
            self.displayAlert("Error", message: errorMessage, handler: nil)
        })
    }
    
    // When fully implemented, will keep a wake up notification schedule for the coming week
    func scheduleWeeklyNotifications() {
        print("Scheduling notifications")
        UIApplication.sharedApplication().scheduledLocalNotifications = []
        for i in 1...7 {
            let notification = UILocalNotification()
            notification.alertBody = "Take your damn survey"
            notification.alertAction = "open"
            
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
            components.hour = 10
            components.minute = 0
            components.second = 0
            components.day += i
            
            notification.fireDate = calendar.dateFromComponents(components)
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
        
        print(UIApplication.sharedApplication().scheduledLocalNotifications)
        print("Scheduled notification")
        
    }
    
    // If login is successful, go to main view
    func removeLoginFromView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBarController
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
