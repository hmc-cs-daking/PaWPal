//
//  DataProcessor.swift
//  PaWPal
//
//  Created by Doren Lan on 11/9/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class DataProcessor {
    
    // helper functions to help determine specific dates
    static func makeKeyTimeStamp(date: NSDate) -> Int{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        return Int(formatter.stringFromDate(date))!
    }
    
    static func timeStampToDate(timestamp: Int) -> NSDate{
        let stringDate: String = String(timestamp)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        return formatter.dateFromString(stringDate)!
    }
    
    static func daysDifference(startDate: NSDate, endDate: NSDate) -> Int{
        let calendar = NSCalendar.currentCalendar()
        let beginStartDate = calendar.startOfDayForDate(startDate)
        let beginEndDate = calendar.startOfDayForDate(endDate)
        let components = calendar.components([.Day], fromDate: beginStartDate, toDate: beginEndDate, options: [])
        return components.day
    }
    
    static func hoursDifference(startDate: NSDate, endDate: NSDate) -> Int{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour], fromDate: startDate, toDate: endDate, options: [])
        return components.hour
    }
    
    static func hoursIndex(hoursDiff: Int) -> Int{
        let firstHour = 0
        return (hoursDiff - firstHour)/4
        
    }
    
    static func getDayData(date: NSDate, completion: () -> Void){
        // get the start of day as NSDate
        let calendar = NSCalendar.currentCalendar()
        let startOfDay = calendar.startOfDayForDate(date)
        var counterArray: [Int] = Array(count: 7, repeatedValue: 0)
        
        let surveyList = AppState.sharedInstance.databaseRef.child("users").child(DatabaseController.getUid()).child("surveyList")
        let dayQuery = surveyList.queryOrderedByChild("timestamp").queryStartingAtValue(self.makeKeyTimeStamp(startOfDay))
        dayQuery.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
            
            // clear the current dictionary
            AppState.sharedInstance.moodDictDay = AppState.emptyMoodDict
            for location in AppState.sharedInstance.locationSuggestions {
                AppState.sharedInstance.locationDict[location]![0] = 0.0
            }
            for activity in AppState.sharedInstance.activitySuggestions {
                AppState.sharedInstance.activityDict[activity]![0] = 0.0
            }
            
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                let value = childSnapshot.value as! NSDictionary
                
                let timestamp = value["timestamp"] as? Int ?? 0
                let hourDiff = self.hoursDifference(startOfDay, endDate: self.timeStampToDate(timestamp))
                let hourIndex = hoursIndex(hourDiff)
                
                // update moods in mood dictionary
                let moodValues = value["feeling"] as? [Double] ?? []
                let moods = ["happy", "confident", "calm", "friendly", "awake"]
                
                for (mood, value) in zip(moods, moodValues) {
                    updateMoodDictDay(mood, dayDiff: hourIndex, value: value, count: counterArray[hourIndex])
                }
                
                counterArray[hourIndex] += 1
                
                // update activity and location dictionaries
                let numHours = Double(value["howLong"] as? String ?? "") ?? 0.0
                if let activity = value["activity"] as? String {
                    AppState.sharedInstance.activityDict[activity]![0] += numHours
                }
                if let location = value["where"] as? String {
                    AppState.sharedInstance.locationDict[location]![0] += numHours
                }
            }
            
            completion()
        })
    }
    
    static func getWeekData(date: NSDate){
        // get the weekAgo date
        let calendar = NSCalendar.currentCalendar()
        let weekAgoComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        weekAgoComponents.day -= 6
        weekAgoComponents.hour = 0
        weekAgoComponents.minute = 0
        weekAgoComponents.second = 0
        let weekAgo = calendar.dateFromComponents(weekAgoComponents)!
        var counterArray: [Int] = Array(count: 7, repeatedValue: 0)
        
        let surveyList = AppState.sharedInstance.databaseRef.child("users").child(DatabaseController.getUid()).child("surveyList")
        let weekQuery = surveyList.queryOrderedByChild("timestamp").queryStartingAtValue(self.makeKeyTimeStamp(weekAgo))

        // EXPENSIVE OPERATIONS
        weekQuery.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { snapshot in
            
            // clear the current dictionary
            AppState.sharedInstance.moodDictWeek = AppState.emptyMoodDict
            for location in AppState.sharedInstance.locationSuggestions {
                AppState.sharedInstance.locationDict[location]![1] = 0.0
            }
            for activity in AppState.sharedInstance.activitySuggestions {
                AppState.sharedInstance.activityDict[activity]![1] = 0.0
            }
            
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                let value = childSnapshot.value as! NSDictionary
                
                let timestamp: Int = value["timestamp"] as? Int ?? 0
                let dayDiff = self.daysDifference(weekAgo, endDate: self.timeStampToDate(timestamp))
                
                // update moods in mood dictionary
                let moodValues = value["feeling"] as? [Double] ?? []
                let moods = ["happy", "confident", "calm", "friendly", "awake"]
                
                for (mood, value) in zip(moods, moodValues) {
                    updateMoodDictWeek(mood, dayDiff: dayDiff, value: value, count: counterArray[dayDiff])
                }
                
                counterArray[dayDiff] += 1
                
                // update activity and location dictionaries
                let numHours = Double(value["howLong"] as? String ?? "") ?? 0.0
                if let activity = value["activity"] as? String {
                    AppState.sharedInstance.activityDict[activity]![1] += numHours
                }
                if let location = value["where"] as? String {
                    AppState.sharedInstance.locationDict[location]![1] += numHours
                }
            }
        })
        
    }
    
    // generate pie slices (string labels)
    static func generateSliceTypes(dictionary: [String:[Double]], timeType: Int) -> [String]{
        return dictionary.filter{ (_,value) in value[timeType] != 0.0 }.map{$0.0}
    }
    
    static func generateSliceValues(dictionary: [String:[Double]], slices: [String], timeType: Int) -> [Double]{
        return slices.map {dictionary[$0]![timeType]}
    }
    
    // helper functions to update the mood dictionaries in AppState
    static func updateMoodDictDay(feeling: String, dayDiff: Int, value: Double, count: Int){
        let currentValue = AppState.sharedInstance.moodDictDay[feeling]![dayDiff]
        
        AppState.sharedInstance.moodDictDay[feeling]![dayDiff] = runningAverage(currentValue, newValue: value, count: count)
    }
    
    static func updateMoodDictWeek(feeling: String, dayDiff: Int, value: Double, count: Int){
        let currentValue = AppState.sharedInstance.moodDictWeek[feeling]![dayDiff]
        
        AppState.sharedInstance.moodDictWeek[feeling]![dayDiff] = runningAverage(currentValue, newValue: value, count: count)
    }
    
    // possible function to combine mood data
    static func runningAverage(currentAverage: Double, newValue: Double, count: Int) -> Double{
        return (currentAverage*Double(count) + newValue)/(Double(count)+1)
    }
}