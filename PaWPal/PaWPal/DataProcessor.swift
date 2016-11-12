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
//    let date = NSDate()
//    let calendar = NSCalendar.currentCalendar()
//    let components = calendar.components([.Day , .Month , .Year], fromDate: date)
//    
//    let year =  components.year
//    let month = components.month
//    let day = components.day
    
    static func makeKeyTimeStamp(date: NSDate) -> Int{
        //let calendar = NSCalendar.currentCalendar()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        let keyTimeStamp: Int? = Int(formatter.stringFromDate(date))
        return keyTimeStamp!
    }
    
    static func getDayData(date: NSDate){
        // get the start of day as NSDate
        let calendar = NSCalendar.currentCalendar()
        let startOfDayComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        startOfDayComponents.hour = 0
        startOfDayComponents.minute = 0
        startOfDayComponents.second = 0
        let startOfDay = calendar.dateFromComponents(startOfDayComponents)
        
        let surveyList = AppState.sharedInstance.databaseRef.child("users").child(DatabaseController.getUid()).child("surveyList")
        let dayQuery = surveyList.queryOrderedByChild("timestamp").queryStartingAtValue(self.makeKeyTimeStamp(startOfDay!))
        print(dayQuery)
        
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
        
        let surveyList = AppState.sharedInstance.databaseRef.child("users").child(DatabaseController.getUid()).child("surveyList")
        let weekQuery = surveyList.queryOrderedByChild("timestamp").queryStartingAtValue(self.makeKeyTimeStamp(weekAgo!))
        print(weekQuery)
        
    }
    
    // possible function to process data into an array of doubles
    static func dayAggregate() -> [Double]{
        return [1, 0, 0]
    }
    
    // possible function to combine mood data
    static func dayAverage(dayData: [Double]) -> Double{
        return dayData.reduce(0, combine: +) / Double(dayData.count)
    }
}