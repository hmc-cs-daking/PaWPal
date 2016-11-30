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
    
    static func makeKeyTimeStamp(date: NSDate) -> Int{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        let keyTimeStamp: Int? = Int(formatter.stringFromDate(date))
        return keyTimeStamp!
    }
    
    static func timeStampToDate(timestamp: Int) -> NSDate{
        let stringDate: String = String(timestamp)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        let date: NSDate = formatter.dateFromString(stringDate)!
        return date
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
            print(snapshot.childrenCount)
            
            // clear the current dictionary
            AppState.sharedInstance.moodDictDay = AppState.emptyMoodDict
            for location in AppState.sharedInstance.locationSuggestions {
                AppState.sharedInstance.locationDict[location]![0] = 0.0
            }
            for activity in AppState.sharedInstance.activitySuggestions {
                AppState.sharedInstance.activityDict[activity]![0] = 0.0
            }
            
            var timestamp = 0
            var hourDiff = 0
            var hourIndex = 0
            var numHours: String = ""
            for child in snapshot.children {
                
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                let value = childSnapshot.value as! NSDictionary
                
                if let childTime = value["timestamp"] { timestamp = (childTime as? Int)! }
                hourDiff = self.hoursDifference(startOfDay, endDate: self.timeStampToDate(timestamp))
                hourIndex = hoursIndex(hourDiff)
                // update moods in mood dictionary
                if let happy = value["feeling"]![0]{
                    updateMoodDictDay("happy", dayDiff: hourIndex, value: (happy as? Double)!, count: counterArray[hourIndex])
                }
                if let confident = value["feeling"]![1]{
                    updateMoodDictDay("confident", dayDiff: hourIndex, value: (confident as? Double)!, count: counterArray[hourIndex])
                }
                if let calm = value["feeling"]![2]{
                    updateMoodDictDay("calm", dayDiff: hourIndex, value: (calm as? Double)!, count: counterArray[hourIndex])
                }
                if let friendly = value["feeling"]![3]{
                    updateMoodDictDay("friendly", dayDiff: hourIndex, value: (friendly as? Double)!, count: counterArray[hourIndex])
                }
                if let awake = value["feeling"]![4]{
                    updateMoodDictDay("awake", dayDiff: hourIndex, value: (awake as? Double)!, count: counterArray[hourIndex])
                }
                
                counterArray[hourIndex] += 1
                
                // update activity and location dictionaries
                if let howLong = value["howLong"]{
                    numHours = (howLong as? String)!
                }
                if let activity = value["activity"]{
                    AppState.sharedInstance.activityDict[(activity as? String)!]![0] += Double(numHours)!
                }
                if let location = value["where"]{
                    AppState.sharedInstance.locationDict[(location as? String)!]![0] += Double(numHours)!
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
        let weekAgo = calendar.dateFromComponents(weekAgoComponents)
        var counterArray: [Int] = Array(count: 7, repeatedValue: 0)
        
        let surveyList = AppState.sharedInstance.databaseRef.child("users").child(DatabaseController.getUid()).child("surveyList")
        let weekQuery = surveyList.queryOrderedByChild("timestamp").queryStartingAtValue(self.makeKeyTimeStamp(weekAgo!))

        // EXPENSIVE OPERATIONS
        weekQuery.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { snapshot in
            print(snapshot.childrenCount)
            
            // clear the current dictionary
            AppState.sharedInstance.moodDictWeek = AppState.emptyMoodDict
            for location in AppState.sharedInstance.locationSuggestions {
                AppState.sharedInstance.locationDict[location]![1] = 0.0
            }
            for activity in AppState.sharedInstance.activitySuggestions {
                AppState.sharedInstance.activityDict[activity]![1] = 0.0
            }
            
            var timestamp = 0
            var dayDiff = 0
            var numHours: String = ""
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                let value = childSnapshot.value as! NSDictionary
                
                if let childTime = value["timestamp"] { timestamp = (childTime as? Int)! }
                dayDiff = self.daysDifference(weekAgo!, endDate: self.timeStampToDate(timestamp))
                
                // update moods in mood dictionary
                if let happy = value["feeling"]![0]{
                    updateMoodDictWeek("happy", dayDiff: dayDiff, value: (happy as? Double)!, count: counterArray[dayDiff])
                }
                if let confident = value["feeling"]![1]{
                    updateMoodDictWeek("confident", dayDiff: dayDiff, value: (confident as? Double)!, count: counterArray[dayDiff])
                }
                if let calm = value["feeling"]![2]{
                    updateMoodDictWeek("calm", dayDiff: dayDiff, value: (calm as? Double)!, count: counterArray[dayDiff])
                }
                if let friendly = value["feeling"]![3]{
                    updateMoodDictWeek("friendly", dayDiff: dayDiff, value: (friendly as? Double)!, count: counterArray[dayDiff])
                }
                if let awake = value["feeling"]![4]{
                    updateMoodDictWeek("awake", dayDiff: dayDiff, value: (awake as? Double)!, count: counterArray[dayDiff])
                }
                
                counterArray[dayDiff] += 1
                
                // update activity and location dictionaries
                if let howLong = value["howLong"]{
                    numHours = (howLong as? String)!
                }
                if let activity = value["activity"]{
                    AppState.sharedInstance.activityDict[(activity as? String)!]![1] += Double(numHours)!
                }
                if let location = value["where"]{
                    AppState.sharedInstance.locationDict[(location as? String)!]![1] += Double(numHours)!
                }
            }
        })
        
    }
    
    // generate pie slices
    static func generateSliceTypes(dictionary: [String:[Double]], timeType: Int) -> [String]{
        var slices: [String] = []
        for (key, value) in dictionary{
            if(value[timeType] != 0.0){
                slices.append(key)
            }
        }
        return slices
    }
    
    static func generateSliceValues(dictionary: [String:[Double]], slices: [String], timeType: Int) -> [Double]{
        var values: [Double] = []
        for slice in slices{
            values.append(dictionary[slice]![timeType])
        }
        return values
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