//
//  DatabaseController.swift
//  PaWPal
//
//  Created by Doren Lan on 9/15/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import Foundation

class DatabaseController {
    
    struct ConnectionConstants {
        private static let PORT = 7000;
        private static let HOST = "heatlab.duckdns.org";
        private static let BASE_URL = "http://\(HOST):\(PORT)/";
        
    }
    
    static func signup(userName: String, password: String) {
        //TODO This still gets a completionCode = -1 response from the database, need to debug, or change backend
        let request = NSMutableURLRequest(URL: NSURL(string: ConnectionConstants.BASE_URL+"signup")!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let params = ["username":userName, "password":password] as Dictionary<String, String>
        
        request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(params, options: [])
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            NSLog("Response: '%@'", response! as NSObject)})
        
        task.resume()
    }
    
    //list of functions to access user info
    static func getEmail() -> String{
        let userEmailStored = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")
        return userEmailStored!
    }
    
    static func getPassword() -> String{
        let userPasswordStored = NSUserDefaults.standardUserDefaults().stringForKey("userPassword")
        return userPasswordStored!
    }
    
    static func getName() -> String{
        let userNameStored = NSUserDefaults.standardUserDefaults().stringForKey("userName")
        return userNameStored!
    }
    
    static func getSchool() -> String{
        let userSchoolStored = NSUserDefaults.standardUserDefaults().stringForKey("userSchool")
        return userSchoolStored!
    }
    
    static func getWakeTime() -> String {
        if let time = NSUserDefaults.standardUserDefaults().stringForKey("wakeTime") { return time }
        else { return "" }
    }
    
    static func getSleepTime() -> String {
        if let time = NSUserDefaults.standardUserDefaults().stringForKey("sleepTime") { return time }
        else { return "" }
    }
    
    //list of functions to set user info
    static func setEmail(userEmail: String){
        NSUserDefaults.standardUserDefaults().setObject(userEmail, forKey: "userEmail")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    static func setPassword(userPassword: String){
        NSUserDefaults.standardUserDefaults().setObject(userPassword, forKey: "userPassword")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    static func setName(userName: String){
        NSUserDefaults.standardUserDefaults().setObject(userName, forKey: "userName")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    static func setSchool(userSchool: String){
        NSUserDefaults.standardUserDefaults().setObject(userSchool, forKey: "userSchool")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    static func setWakeTime(wakeTime: String) {
        NSUserDefaults.standardUserDefaults().setObject(wakeTime, forKey: "wakeTime")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    static func setSleepTime(sleepTime: String) {
        NSUserDefaults.standardUserDefaults().setObject(sleepTime, forKey: "sleepTime")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
}