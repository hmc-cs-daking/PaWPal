//
//  DatabaseController.swift
//  PaWPal
//
//  Created by Doren Lan on 9/15/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import Foundation

class DatabaseController {
    
    //list of functions to access user info
    func getEmail() -> String{
        let userEmailStored = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")
        return userEmailStored!
    }
    
    func getPassword() -> String{
        let userPasswordStored = NSUserDefaults.standardUserDefaults().stringForKey("userPassword")
        return userPasswordStored!
    }
    
    func getName() -> String{
        let userNameStored = NSUserDefaults.standardUserDefaults().stringForKey("userName")
        return userNameStored!
    }
    
    func getSchool() -> String{
        let userSchoolStored = NSUserDefaults.standardUserDefaults().stringForKey("userSchool")
        return userSchoolStored!
    }
    
    func getWakeTime() -> String {
        return NSUserDefaults.standardUserDefaults().stringForKey("wakeTime")!
    }
    
    func getSleepTime() -> String {
        return NSUserDefaults.standardUserDefaults().stringForKey("sleepTime")!
    }
    
    //list of functions to set user info
    func setEmail(userEmail: String){
        NSUserDefaults.standardUserDefaults().setObject(userEmail, forKey: "userEmail")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setPassword(userPassword: String){
        NSUserDefaults.standardUserDefaults().setObject(userPassword, forKey: "userPassword")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setName(userName: String){
        NSUserDefaults.standardUserDefaults().setObject(userName, forKey: "userName")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setSchool(userSchool: String){
        NSUserDefaults.standardUserDefaults().setObject(userSchool, forKey: "userSchool")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setWakeTime(wakeTime: String) {
        NSUserDefaults.standardUserDefaults().setObject(wakeTime, forKey: "wakeTime")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setSleepTime(sleepTime: String) {
        NSUserDefaults.standardUserDefaults().setObject(sleepTime, forKey: "sleepTime")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
}