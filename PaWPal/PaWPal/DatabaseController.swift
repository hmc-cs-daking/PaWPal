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

// this class contains methods for interacting with Firebase and storing and retrieving user data
class DatabaseController {
    
    // signs a user up in Firebase
    static func signUp(userEmail: String, userPassword: String, completion: () -> Void, currentVC: UIViewController) {
        FIRAuth.auth()?.createUserWithEmail(userEmail, password: userPassword) { (user, error) in
            if let error = error {
                currentVC.displayAlert("Error", message: error.localizedDescription, handler: nil)
                return
            }
            
            let formatter = NotificationScheduler.getDateFormatter()
            
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
                        "surveyList": [],
                        "locationSuggestions": AppState.defaultLocations,
                        "activitySuggestions": AppState.defaultActivities,
                        "otherSuggestions": AppState.defaultOther,
                        "lastActionTakenAt": formatter.stringFromDate(NSDate())]
            let childUpdates = ["/users/\(key)": signUp]
            AppState.sharedInstance.databaseRef.updateChildValues(childUpdates)
            
            completion()
        }
    }
    
    // signs a user in using Firebase
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

                loadAppStateFromFirebase(snapshot.value as? NSDictionary)
                
                NotificationScheduler.scheduleNotificationsOnSignIn()
                
                completion()
                }
            )
        }
    }
    
    // stores user's info in AppState, excluding userEmail and uid
    static func loadAppStateFromFirebase(value: NSDictionary?) {
        if let userName = value?["userName"] { AppState.sharedInstance.userName = userName as? String }
        if let school = value?["school"] { AppState.sharedInstance.school = school as? String }
        if let wakeTime = value?["wakeTime"] { AppState.sharedInstance.wakeTime = wakeTime as? String }
        if let sleepTime = value?["sleepTime"] { AppState.sharedInstance.sleepTime = sleepTime as? String }
        if let closestNotification = value?["closestScheduledNotification"] { AppState.sharedInstance.closestScheduledNotification = closestNotification as? String }
        if let furthestNotification = value?["furthestScheduledNotification"] { AppState.sharedInstance.furthestScheduledNotification = furthestNotification as? String }
        if let dailyCount = value?["dailySurveyCount"] { AppState.sharedInstance.dailySurveyCount = (dailyCount as! NSNumber).integerValue }
        if let totalCount = value?["totalSurveyCount"] { AppState.sharedInstance.totalSurveyCount = (totalCount as! NSNumber).integerValue }
        if let lastActionTakenAt = value?["lastActionTakenAt"] { AppState.sharedInstance.lastActionTakenAt = lastActionTakenAt as? String }
        if let locationSuggestions = value?["locationSuggestions"] {
            AppState.sharedInstance.locationSuggestions = locationSuggestions as! [String]
            for location in AppState.sharedInstance.locationSuggestions {
                AppState.sharedInstance.locationDict.updateValue([0.0, 0.0], forKey: location)
            }
        }
        if let activitySuggestions = value?["activitySuggestions"] {
            AppState.sharedInstance.activitySuggestions = activitySuggestions as! [String]
            for activity in AppState.sharedInstance.activitySuggestions {
                AppState.sharedInstance.activityDict.updateValue([0.0, 0.0], forKey: activity)
            }
        }
        if let otherSuggestions = value?["otherSuggestions"] { AppState.sharedInstance.otherSuggestions = otherSuggestions as! [String] }
    }
    
    // resets a user's password using Firebase to send an email
    static func resetPassword(controller: UIViewController, email: String) {
        FIRAuth.auth()?.sendPasswordResetWithEmail(email) { (error) in
            if let error = error {
                controller.displayAlert("Error", message: error.localizedDescription, handler: nil)
                return
            }
            
            controller.displayAlert("Password reset", message: "An email has been sent to reset your password", handler: { action in controller.dismissViewControllerAnimated(true, completion: nil)})
        }
    }
    
    //methods to update different types of questions
    static func updateSlider(question: SliderQuestion){
        let answer = question.answerSlider.value
        AppState.sharedInstance.surveyList[question.key] = answer

    }
    
    static func updateText(question: TextQuestion){
        let answer = question.answerTextField.text
        AppState.sharedInstance.surveyList[question.key] = answer
    }
    
    static func updateMultiSlider(question: MultiSliderQuestion){
        let answer = question.sliders.map {$0.value}
        AppState.sharedInstance.surveyList[question.key] = answer
    }
    
    static func updateMultiCheck(question: MultiCheckQuestion){
        let answer = question.switches.map {$0.on}
        AppState.sharedInstance.surveyList[question.key] = answer
    }
    
    // submits the completed survey to Firebase
    static func submitSurvey(){
        
        // append survey answers to surveyList
        // creates a new automated child id (string of characters, but firebase keeps them in time order)
        AppState.sharedInstance.databaseRef.child("users").child(getUid()).child("surveyList").childByAutoId().setValue(AppState.sharedInstance.surveyList)
        
        // update autocomplete lists
        updateAutocomplete()
        // updates firebase
        AppState.sharedInstance.databaseRef.child("users").child(getUid()).child("activitySuggestions").setValue(AppState.sharedInstance.activitySuggestions)
        AppState.sharedInstance.databaseRef.child("users").child(getUid()).child("locationSuggestions").setValue(AppState.sharedInstance.locationSuggestions)
        AppState.sharedInstance.databaseRef.child("users").child(getUid()).child("otherSuggestions").setValue(AppState.sharedInstance.otherSuggestions)
        
        // clear survey answers in AppState
        AppState.sharedInstance.surveyList = AppState.emptySurvey
    }
    
    static func updateAutocomplete(){
        //append user input to autocomplete lists
        let activity = AppState.sharedInstance.surveyList["activity"] as! String
        let location = AppState.sharedInstance.surveyList["where"] as! String
        let elseOptional = AppState.sharedInstance.surveyList["elseOptional"] as! String
        
        if (!AppState.sharedInstance.activitySuggestions.contains(activity)){
            AppState.sharedInstance.activitySuggestions.append(activity)
            AppState.sharedInstance.activityDict.updateValue([0.0, 0.0], forKey: activity)
        }
        if (!AppState.sharedInstance.locationSuggestions.contains(location)){
            AppState.sharedInstance.locationSuggestions.append(location)
            AppState.sharedInstance.locationDict.updateValue([0.0, 0.0], forKey: location)
        }
        if (!AppState.sharedInstance.otherSuggestions.contains(elseOptional)){
            AppState.sharedInstance.otherSuggestions.append(elseOptional)
        }
    }
    
    // functions to access user info
    static func getEmail() -> String{
        return AppState.sharedInstance.userEmail ?? ""
    }
    
    static func getName() -> String{
        return AppState.sharedInstance.userName ?? ""
    }
    
    static func getSchool() -> String{
        return AppState.sharedInstance.school ?? ""
    }
    
    static func getWakeTime() -> String {
        return AppState.sharedInstance.wakeTime ?? ""
    }
    
    static func getSleepTime() -> String {
        return AppState.sharedInstance.sleepTime ?? ""
    }
    
    static func getUid() -> String {
        return AppState.sharedInstance.uid ?? ""
    }
    
    static func getDailySurveyCount() -> Int {
        return AppState.sharedInstance.dailySurveyCount
    }
    
    static func getTotalSurveyCount() -> Int {
        return AppState.sharedInstance.totalSurveyCount
    }
    
    static func getClosestNotification() -> String {
        return AppState.sharedInstance.closestScheduledNotification!
    }
    
    static func getFurthestNotification() -> String {
        return AppState.sharedInstance.furthestScheduledNotification!
    }
    
    static func getLastActionTakenAt() -> String {
        return AppState.sharedInstance.lastActionTakenAt!
    }
    
    // functions to set user info
    static func setEmail(userEmail: String, controller: UIViewController, completion: () -> Void){
        FIRAuth.auth()?.currentUser?.updateEmail(userEmail) { (error) in
            if let error = error {
                controller.displayAlert("Error", message: error.localizedDescription, handler: nil)
                return
            }
            
            completion()
        }
        AppState.sharedInstance.databaseRef.child("/users/\(getUid())/userEmail").setValue(userEmail)
        AppState.sharedInstance.userName = userEmail
    }
    
    static func setPassword(userPassword: String, controller: UIViewController, completion: () -> Void){
        FIRAuth.auth()?.currentUser?.updatePassword(userPassword) { (error) in
            if let error = error {
                controller.displayAlert("Error", message: error.localizedDescription, handler: {
                    (action) in controller.dismissViewControllerAnimated(true, completion: nil)})
                return
            }
            
            completion()
        }
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
    
    static func setLastActionTakenAt(date: String) {
        AppState.sharedInstance.databaseRef.child("/users/\(getUid())/lastActionTakenAt").setValue(date)
        AppState.sharedInstance.lastActionTakenAt = date
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