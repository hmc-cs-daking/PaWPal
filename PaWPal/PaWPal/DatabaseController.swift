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
    
    static func signUp(userEmail: String, userPassword: String, completion: () -> Void, currentVC: UIViewController) {
        //TODO: check async stuff here
        FIRAuth.auth()?.createUserWithEmail(userEmail, password: userPassword) { (user, error) in
            if let error = error {
                currentVC.displayAlert("Error", message: error.localizedDescription, handler: nil)
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
                        "totalSurveyCount": 0,
                        "surveyList": []]
            let childUpdates = ["/users/\(key)": signUp]
            AppState.sharedInstance.databaseRef.updateChildValues(childUpdates)
            
            completion()
        }
    }
    
    static func signIn(userEmail: String, userPassword: String, completion: () -> Void, currentVC: UIViewController){
        FIRAuth.auth()?.signInWithEmail(userEmail, password: userPassword) { (user, error) in
            if let error = error {
                currentVC.displayAlert("Error", message: error.localizedDescription, handler: nil)
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
                if let dailyCount = value?["dailySurveyCount"] { AppState.sharedInstance.dailySurveyCount = (dailyCount as! NSNumber).integerValue }
                if let totalCount = value?["totalSurveyCount"] { AppState.sharedInstance.totalSurveyCount = (totalCount as! NSNumber).integerValue }
                NotificationScheduler.scheduleNotificationsOnSignIn()
                }
            )
            
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
//        var answer = Array(count: 5, repeatedValue: 0)
//        for i in 0...answer.count{
//            answer[i] = question.slider[i].value
//        }
        let answer: [Float] = [
            question.answerSlider1.value,
            question.answerSlider2.value,
            question.answerSlider3.value,
            question.answerSlider4.value,
            question.answerSlider5.value
        ]
        AppState.sharedInstance.surveyList[key] = answer
    }
    
    static func updateMultiCheck(key: String, question: MultiCheckQuestion){
        var answer: [Bool] = Array(count: 5, repeatedValue: false)
        for i in 0..<answer.count{
            answer[i] = question.switches[i].on
        }
        AppState.sharedInstance.surveyList[key] = answer
    }
    
    // HERE HERE HERE
    static func submitSurvey(){
        // append survey answers to surveyList
        // creates a new automated child id (string of characters, but firebase keeps them in time order)
            AppState.sharedInstance.databaseRef.child("users").child(getUid()).child("surveyList").childByAutoId().setValue(AppState.sharedInstance.surveyList)
        
        // clear survey answers in AppState
        // @Doren, this clears the survey text fields when you take the next survey
        AppState.sharedInstance.surveyList = AppState.emptySurvey
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
    
    static func getDailySurveyCount() -> Int {
        return AppState.sharedInstance.dailySurveyCount
    }
    
    static func getTotalSurveyCount() -> Int {
        return AppState.sharedInstance.totalSurveyCount
    }
    
    //list of functions to set user info
    static func setEmail(userEmail: String){
        AppState.sharedInstance.databaseRef.child("/users/\(getUid())/userEmail").setValue(userEmail)
        AppState.sharedInstance.userName = userEmail
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
    
    static func incrementDailySurveyCount() {
        AppState.sharedInstance.databaseRef.child("/users/\(getUid())/dailySurveyCount").setValue(getDailySurveyCount()+1)
        AppState.sharedInstance.dailySurveyCount += 1
    }
    
    static func resetDailySurveyCount() {
        AppState.sharedInstance.databaseRef.child("/users/\(getUid())/dailySurveyCount").setValue(0)
        AppState.sharedInstance.dailySurveyCount = 0
    }
    
    static func incrementTotalSurveyCount() {
        AppState.sharedInstance.databaseRef.child("/users/\(getUid())/totalSurveyCount").setValue(getTotalSurveyCount()+1)
        AppState.sharedInstance.totalSurveyCount += 1
    }
}