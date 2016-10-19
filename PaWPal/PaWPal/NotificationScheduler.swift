//
//  NotificationScheduler.swift
//  PaWPal
//
//  Created by cs laptop on 10/5/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import Foundation
import UIKit

class NotificationScheduler {
    // Schedule daily 10 AM notifications for a week in advance
    static func scheduleNotificationsOnSignIn() {
        //clearScheduledNotifications()
        // Computes how many new notifications to schedule
        let calendar = NSCalendar.currentCalendar()
        let nsDate = NSDate()
        let dateFormatter = getDateFormatter()
        
        let closestNotification = AppState.sharedInstance.closestScheduledNotification
        var furthestNotification = AppState.sharedInstance.furthestScheduledNotification

        if (furthestNotification == nil || furthestNotification == "") {
            furthestNotification = dateFormatter.stringFromDate(nsDate)
        }
        
        var furthestComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: dateFormatter.dateFromString(furthestNotification!)!)
        furthestComponents.hour = 12
        let currentComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: nsDate)
        currentComponents.hour = 12
        
        let currentDate = calendar.dateFromComponents(currentComponents)
        let furthestDate = calendar.dateFromComponents(furthestComponents)
        
        let differenceComponents = calendar.components([], fromDate: currentDate!, toDate: furthestDate!, options: [])

        var dayDifference = differenceComponents.day
        if (dayDifference < 0 || dayDifference > 7) {
            dayDifference = 7
            furthestComponents = currentComponents
        }
        
        // set the time for the morning notifications based on the user's wake time
        let wakeTime = DatabaseController.getWakeTime()
        let wakeTimeComponents = wakeTime.componentsSeparatedByString(":")
        furthestComponents.hour = Int(wakeTimeComponents[0])!
        furthestComponents.minute = Int(wakeTimeComponents[1].componentsSeparatedByString(" ")[0])! + 30
        furthestComponents.second = 0
        
        // Schedules the new notifications
        for i in ((7-dayDifference)+1)..<8 {
            let notification = UILocalNotification()
            notification.alertBody = "Start your day off on the right foot!"
            notification.alertAction = "open"
            furthestComponents.day += 1
            notification.fireDate = calendar.dateFromComponents(furthestComponents)
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
            if ((closestNotification == nil || closestNotification == "") && i == 1) {
                DatabaseController.setClosestNotification(dateFormatter.stringFromDate(notification.fireDate!))
            }
            
            if (i == 7) {
                DatabaseController.setFurthestNotification(dateFormatter.stringFromDate(notification.fireDate!))
            }
        }
    }
    
    static func scheduleNextNotificationOfTheDay() {
        var scheduledNewNotification = false
        let calendar = NSCalendar.currentCalendar()
        let nsDate = NSDate()
        let dateFormatter = getDateFormatter()
        
        let currentTimeComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: nsDate)
        
        var wakeTimeComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: nsDate)
        let wakeTime = DatabaseController.getWakeTime().componentsSeparatedByString(":")
        wakeTimeComponents.hour = Int(wakeTime[0])!
        let wakeTimeMinutesAndAmPm = wakeTime[1].componentsSeparatedByString(" ")
        wakeTimeComponents.minute = Int(wakeTimeMinutesAndAmPm[0])! + 30
        if (wakeTimeMinutesAndAmPm[1] == "PM") {
            wakeTimeComponents.hour += 12
        }
        wakeTimeComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: calendar.dateFromComponents(wakeTimeComponents)!)
        
        let surveyCount = DatabaseController.getDailySurveyCount()
        // check if the user has already taken all of their surveys for the day
        if (surveyCount < 6) {
            var plusTwoHoursComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: nsDate)
            plusTwoHoursComponents.hour += 2
            plusTwoHoursComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: calendar.dateFromComponents(plusTwoHoursComponents)!)
            
            // don't ever schedule notifications between 2 am and the morning notification
            if (plusTwoHoursComponents.hour < 2 || (plusTwoHoursComponents.hour >= (wakeTimeComponents.hour+2) && plusTwoHoursComponents.minute >= wakeTimeComponents.minute)) {
                
                let sleepTimeComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: nsDate)
                let sleepTime = DatabaseController.getSleepTime().componentsSeparatedByString(":")
                sleepTimeComponents.hour = Int(sleepTime[0])!
                let sleepTimeMinutesAndAmPm = sleepTime[1].componentsSeparatedByString(" ")
                sleepTimeComponents.minute = Int(sleepTimeMinutesAndAmPm[0])!
                if (sleepTimeMinutesAndAmPm[1] == "AM") {
                    sleepTimeComponents.day += 1
                } else {
                    sleepTimeComponents.hour += 12
                }
                
                // check if two hours later is before the user's bedtime
                if ((calendar.dateFromComponents(sleepTimeComponents))?.compare(calendar.dateFromComponents(plusTwoHoursComponents)!) == NSComparisonResult.OrderedDescending) {
                    // schedule a notification for two hours from current time
                    let notification = UILocalNotification()
                    notification.alertBody = "It's time to take a survey!"
                    notification.alertAction = "open"
                    notification.fireDate = calendar.dateFromComponents(plusTwoHoursComponents)
                    UIApplication.sharedApplication().scheduleLocalNotification(notification)
                    DatabaseController.setClosestNotification(dateFormatter.stringFromDate(notification.fireDate!))
                    scheduledNewNotification = true
                    
                    // leaving print here to help me debug as we continue to work
                    printScheduledNotifications()
                }
            }
        }
        
        if (!scheduledNewNotification) {
            // set closestNotification to the next morning if no next notification was scheduled for the current day
            if (currentTimeComponents.hour >= wakeTimeComponents.hour) {
                wakeTimeComponents.day += 1
            }
            DatabaseController.setClosestNotification(dateFormatter.stringFromDate(calendar.dateFromComponents(wakeTimeComponents)!))
        }
    }
    
    static func resetDailyCountIfNecessary() {
        let dateFormatter = getDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        let nsDate = NSDate()
        
        let closestNotification = AppState.sharedInstance.closestScheduledNotification
        let closestComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: dateFormatter.dateFromString(closestNotification!)!)
        
        var wakeTimeComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: nsDate)
        let wakeTime = DatabaseController.getWakeTime().componentsSeparatedByString(":")
        wakeTimeComponents.hour = Int(wakeTime[0])!
        let wakeTimeMinutesAndAmPm = wakeTime[1].componentsSeparatedByString(" ")
        wakeTimeComponents.minute = Int(wakeTimeMinutesAndAmPm[0])!
        wakeTimeComponents.minute += 30
        if (wakeTimeMinutesAndAmPm[1] == "PM") {
            wakeTimeComponents.hour += 12
        }
        
        wakeTimeComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: calendar.dateFromComponents(wakeTimeComponents)!)

        // will reset the dailySurveyCount if the closest notification is the morning notification and the current time is past the morning notification
        if (closestComponents.hour == wakeTimeComponents.hour && closestComponents.minute == wakeTimeComponents.minute) {
            if (nsDate.compare(calendar.dateFromComponents(closestComponents)!) == NSComparisonResult.OrderedDescending) {
                DatabaseController.resetDailySurveyCount()
            }
        }
    }
    
    static func clearScheduledNotifications() {
        UIApplication.sharedApplication().scheduledLocalNotifications = []
        DatabaseController.setFurthestNotification("")
        DatabaseController.setClosestNotification("")
        AppState.sharedInstance.closestScheduledNotification = ""
        AppState.sharedInstance.furthestScheduledNotification = ""
    }
    
    static func printScheduledNotifications() {
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] {
            print(notification.fireDate)
        }
    }
    
    static func getDateFormatter() -> NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyy hh:mm:ss a +zzzz"
        return formatter
    }
}