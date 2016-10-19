//
//  DatabaseController.swift
//  PaWPal
//
//  Created by Doren Lan on 9/15/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class DatabaseController {
    
    static func signUp(userEmail: String, userPassword: String) {
        //TODO: check async stuff here
        FIRAuth.auth()?.createUserWithEmail(userEmail, password: userPassword) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let key = (user! as FIRUser).uid
            let signUp = ["uid": (user! as FIRUser).uid,
                        "userName": userEmail,
                        "userEmail": userEmail,
                        "school": "",
                        "wakeTime": "9:00 AM",
                        "sleepTime": "11:59 PM",
                        "closestScheduledNotification": "",
                        "furthestScheduledNotification": "",
                        "dailySurveyCount": 0,
                        "totalSurveyCount": 0]
            let childUpdates = ["/users/\(key)": signUp]
            AppState.sharedInstance.databaseRef.updateChildValues(childUpdates)
        }
    }
    
    // NOTE: success and failure takes a second to run. firebase auth is slow
    // If successful, run completion(). If failure, run failure()
    static func signIn(userEmail: String, userPassword: String, completion: () -> Void, failure: () -> Void){
        FIRAuth.auth()?.signInWithEmail(userEmail, password: userPassword) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                failure()
                return
            }
            
            AppState.sharedInstance.userEmail = userEmail
            AppState.sharedInstance.uid = (user! as FIRUser).uid
            AppState.sharedInstance.userName = userEmail
            
            // Retrieves user's info from firebase
            AppState.sharedInstance.databaseRef.child("users").child(getUid()).observeSingleEventOfType(FIRDataEventType.Value, withBlock:{ (snapshot) in
                let value = snapshot.value as? NSDictionary
                if let userName = value?["userName"] { AppState.sharedInstance.userName = userName as? String }
                if let school = value?["school"] { AppState.sharedInstance.school = school as? String }
                if let wakeTime = value?["wakeTime"] { AppState.sharedInstance.wakeTime = wakeTime as? String }
                if let sleepTime = value?["sleepTime"] { AppState.sharedInstance.sleepTime = sleepTime as? String }
                if let closestNotification = value?["closestScheduledNotification"] { AppState.sharedInstance.closestScheduledNotification = closestNotification as? String }
                if let furthestNotification = value?["furthestScheduledNotification"] { AppState.sharedInstance.furthestScheduledNotification = furthestNotification as? String }
                }
            )
            
            // Remembers the user id in a keychain
            let MyKeychainWrapper = KeychainWrapper()
            MyKeychainWrapper.mySetObject(AppState.sharedInstance.uid, forKey:kSecValueData)
            MyKeychainWrapper.writeToKeychain()
            
            completion()
        }
    }
    
    //methods to update different types of questions
    static func updateSlider(key: String, question: SliderQuestion){
        let answer = question.answerSlider.value
        AppState.sharedInstance.surveyList[key] = answer

    }
    
    static func updateText(key: String, question: TextQuestion){
        let answer = question.answerTextField.text
        AppState.sharedInstance.surveyList[key] = answer
    }
    
    static func updateMultiSlider(key: String, question: MultiSliderQuestion){
        let answer = [question.answerSlider1.value,
                      question.answerSlider2.value,
                      question.answerSlider3.value,
                      question.answerSlider4.value,
                      question.answerSlider5.value,
                      ]
        AppState.sharedInstance.surveyList[key] = answer
    }
    
    static func updateMultiCheck(key: String, question: MultiCheckQuestion){
        let answer = [question.answerSwitch1.on,
                      question.answerSwitch2.on,
                      question.answerSwitch3.on,
                      question.answerSwitch4.on,
                      question.answerSwitch5.on,
                      ]
        AppState.sharedInstance.surveyList[key] = answer
    }
    
    static func submitSurvey(){
        AppState.sharedInstance.databaseRef.child("/users/\(getUid())/surveyList/\(AppState.sharedInstance.totalSurveyCount))").setValue(AppState.sharedInstance.surveyList)
    }
    
    //list of functions to access user info
    static func getEmail() -> String{
        if let email = AppState.sharedInstance.userEmail { return email }
        else { return "" }
    }
    
    static func getName() -> String{
        if let userName = AppState.sharedInstance.userName { return userName }
        else { return "" }
    }
    
    static func getSchool() -> String{
        if let school = AppState.sharedInstance.school { return school }
        else { return "" }
    }
    
    static func getWakeTime() -> String {
        if let time = AppState.sharedInstance.wakeTime { return time }
        else { return "" }
    }
    
    static func getSleepTime() -> String {
        if let time = AppState.sharedInstance.sleepTime { return time }
        else { return "" }
    }
    
    static func getUid() -> String {
        if let uid = AppState.sharedInstance.uid { return uid }
        else { return "" }
    }
    
    //list of functions to set user info
    static func setEmail(userEmail: String){
        //TODO
        NSUserDefaults.standardUserDefaults().setObject(userEmail, forKey: "userEmail")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    static func setPassword(userPassword: String){
        //TODO
        NSUserDefaults.standardUserDefaults().setObject(userPassword, forKey: "userPassword")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    static func setName(userName: String){
        AppState.sharedInstance.databaseRef.child("/users/\(getUid())/userName").setValue(userName)
        AppState.sharedInstance.userName = userName
    }
    
    static func setSchool(userSchool: String){
        AppState.sharedInstance.databaseRef.child("/users/\(getUid())/school").setValue(userSchool)
        AppState.sharedInstance.school = userSchool
    }
    
    static func setWakeTime(wakeTime: String) {
        AppState.sharedInstance.databaseRef.child("/users/\(getUid())/wakeTime").setValue(wakeTime)
        AppState.sharedInstance.wakeTime = wakeTime
    }
    
    static func setSleepTime(sleepTime: String) {
        AppState.sharedInstance.databaseRef.child("/users/\(getUid())/sleepTime").setValue(sleepTime)
        AppState.sharedInstance.sleepTime = sleepTime
    }
    
    static func setClosestNotification(date: String) {
        AppState.sharedInstance.databaseRef.child("/users/\(getUid())/closestScheduledNotification").setValue(date)
        AppState.sharedInstance.closestScheduledNotification = date
    }
    
    static func setFurthestNotification(date: String) {
        AppState.sharedInstance.databaseRef.child("/users/\(getUid())/furthestScheduledNotification").setValue(date)
        AppState.sharedInstance.furthestScheduledNotification = date
    }
    
}