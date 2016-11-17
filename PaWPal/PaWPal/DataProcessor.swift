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
    
    static func getDayData(date: NSDate){
        // get the start of day as NSDate
        let calendar = NSCalendar.currentCalendar()
        let startOfDay = calendar.startOfDayForDate(date)
        
        var array: [NSDictionary] = []
        
        let surveyList = AppState.sharedInstance.databaseRef.child("users").child(DatabaseController.getUid()).child("surveyList")
        let dayQuery = surveyList.queryOrderedByChild("timestamp").queryStartingAtValue(self.makeKeyTimeStamp(startOfDay))
        dayQuery.observeEventType(FIRDataEventType.ChildAdded, withBlock: { snapshot in
            print(snapshot.childrenCount)
            
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                array.append(childSnapshot.value as! NSDictionary)
                print(array.count)
            }
        })
    }
    
    static func getWeekData(date: NSDate){
        // get the weekAgo date
        let calendar = NSCalendar.currentCalendar()
        //var weekAgo = calendar.dateByAddingUnit(.Day, value: -7, toDate: date, options: [])
        let weekAgoComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        weekAgoComponents.day -= 7
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
            
            var timestamp = 0
            var dayDiff = 0
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                let value = childSnapshot.value as! NSDictionary
                
                if let childTime = value["timestamp"] { timestamp = (childTime as? Int)! }
                dayDiff = self.daysDifference(weekAgo!, endDate: self.timeStampToDate(timestamp))
                
                // update moods in mood dictionary
                if let happy = value["feeling"]![0]{
                    updateMoodDict("happy", dayDiff: dayDiff, value: (happy as? Double)!, count: counterArray[dayDiff])
                }
                if let confident = value["feeling"]![1]{
                    updateMoodDict("confident", dayDiff: dayDiff, value: (confident as? Double)!, count: counterArray[dayDiff])
                }
                if let calm = value["feeling"]![2]{
                    updateMoodDict("calm", dayDiff: dayDiff, value: (calm as? Double)!, count: counterArray[dayDiff])
                }
                if let friendly = value["feeling"]![3]{
                    updateMoodDict("friendly", dayDiff: dayDiff, value: (friendly as? Double)!, count: counterArray[dayDiff])
                }
                if let awake = value["feeling"]![4]{
                    updateMoodDict("awake", dayDiff: dayDiff, value: (awake as? Double)!, count: counterArray[dayDiff])
                }
                
                counterArray[dayDiff] += 1
            }
        })
        
    }
    
    // helper function to update the mood dictionary in AppState
    static func updateMoodDict(feeling: String, dayDiff: Int, value: Double, count: Int){
        let currentValue = AppState.sharedInstance.moodDict[feeling]![dayDiff]
        
        AppState.sharedInstance.moodDict[feeling]![dayDiff] = runningAverage(currentValue, newValue: value, count: count)
    }
    
    // possible function to combine mood data
    static func runningAverage(currentAverage: Double, newValue: Double, count: Int) -> Double{
        return (currentAverage*Double(count) + newValue)/(Double(count)+1)
    }
}