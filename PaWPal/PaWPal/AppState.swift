//
//  AppState.swift
//  PaWPal
//
//  Created by cs laptop on 9/25/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//


import Foundation
import FirebaseDatabase

class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var userName: String?
    var userEmail: String?
    var uid: String?
    var school: String?
    var wakeTime: String?
    var sleepTime: String?
    var signedIn = false
    var closestScheduledNotification: String?
    var furthestScheduledNotification: String?
    var databaseRef = FIRDatabase.database().reference()
    var surveyList = ["where": "",
                      "activity": "",
                      "elseOptional": "",
                      
                      "enjoyment": 0,
                      "concentration": 0,
                      "gettingBetter": 0,
                      "choice": 0,
                      
                      "challenge": 0,
                      "skilled": 0,
                      "succeedng": 0,
                      "wishElse": 0,
                      
                      "interaction": [
                        0,0,0,0,0],
                      "howLong": "",
                      
                      "feeling": [
                        0,0,0,0,0],
                      
                      "strongEmotionsOptional": "",
                      "elseMindOptional": ""
    ]
}
