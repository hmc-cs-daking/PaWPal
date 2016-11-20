//
//  AppDelegate.swift
//  PaWPal
//
//  Created by cs laptop on 9/9/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Show login page if user is not logged in
    // Or loads info if user is already logged in
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        FIRApp.configure()
        
        // naviagation bar
//        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
//        UINavigationBar.appearance().barTintColor = UIColor.orangeColor()
//        UINavigationBar.appearance().titleTextAttributes=[NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        // prompt the user to allow notifications from the PaWPal app
        // TODO: what if the user says no?
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))

        // retrieve user cached in firebase
        if let currentUser = FIRAuth.auth()?.currentUser {
            AppState.sharedInstance.databaseRef.child("users").observeSingleEventOfType(FIRDataEventType.Value, withBlock:{ (snapshot) in
                
                    // ensure user exists in firebase
                    if (snapshot.hasChild(currentUser.uid)) {
                        AppState.sharedInstance.uid = currentUser.uid
                    
                        // Retrieves user's info from firebase
                        let value = snapshot.childSnapshotForPath(currentUser.uid).value as? NSDictionary
                        
                        if let userEmail = value?["userEmail"] { AppState.sharedInstance.userEmail = userEmail as? String }
                        
                        DatabaseController.loadAppStateFromFirebase(value)
                        
                        
                        // will reset the daily survey count if the closestNotification is the morning notification and the current time is past that
                        NotificationScheduler.resetDailyCountIfNecessary()
                        
                        // will schedule the morning notifications for the coming week
                        NotificationScheduler.scheduleNotificationsOnSignIn()
                        
                        // show survey screen
                        LoginViewController.showTabContoller()
                    }
                    else {
                        // if user doesn't exist in firebase
                        LoginViewController.showLogin()
                    }
                }
            )
        }
        else {
            LoginViewController.showLogin()
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

