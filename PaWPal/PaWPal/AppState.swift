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
    
    // ------ DEFAULTS ------
    
    static let emptySurvey: [String: AnyObject] =
        ["timestamp": 0, // time when survey was submitted
        "where": "",
        "activity": "",
        "elseOptional": "",
        
        "enjoyment": 0,
        "concentration": 0,
        "gettingBetter": 0,
        "choice": 0,
        
        "challenge": 0,
        "skilled": 0,
        "succeeding": 0,
        "wishElse": 0,
        
        "interaction": Array(count: 5, repeatedValue: false),
        "howLong": "",
        
        "feeling": Array(count: 5, repeatedValue: 4.0),
        
        "strongEmotionsOptional": "",
        "elseMindOptional": ""
    ]
    
    static let emptyMoodDict: [String:[Double]] = [
        "happy": Array(count: 7, repeatedValue: 0.0),
        "confident": Array(count: 7, repeatedValue: 0.0),
        "calm": Array(count: 7, repeatedValue: 0.0),
        "friendly": Array(count: 7, repeatedValue: 0.0),
        "awake": Array(count: 7, repeatedValue: 0.0)
    ]

    // autocomplete variables
    static let defaultLocations:[String] = ["Platt", "Place", "Shanahan", "Atwood"]
    static let defaultActivities:[String] = ["Working", "Class"]
    static let defaultOther:[String] = ["Sleeping", "Netflix"]
    
    // ------ END DEFAULTS ------
    
    
    // ------ VARIABLES "CACHED" FROM FIREBASE ------
    
    // user attributes
    var userName: String?
    var userEmail: String?
    var uid: String?
    var school: String?
    var wakeTime: String?
    var sleepTime: String?
    
    // notification instances
    var closestScheduledNotification: String?
    var furthestScheduledNotification: String?
    var dailySurveyCount = 0
    var totalSurveyCount = 0
    var lastActionTakenAt: String?
    
    // survey query dictionaries
    var databaseRef = FIRDatabase.database().reference()
    var surveyList:[String:AnyObject] = emptySurvey
    var moodDictWeek: [String:[Double]] = emptyMoodDict
    var moodDictDay: [String:[Double]] = emptyMoodDict
    var activityDict: [String:[Double]] = [:]
    var locationDict: [String:[Double]] = [:]
    
    // autocomplete instances
    var locationSuggestions: [String] = defaultLocations
    var activitySuggestions: [String] = defaultActivities
    var otherSuggestions: [String] = defaultOther
    
    // ------ END VARIABLES "CACHED" FROM FIREBASE ------
    
}
