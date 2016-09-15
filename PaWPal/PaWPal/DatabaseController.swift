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
    
}