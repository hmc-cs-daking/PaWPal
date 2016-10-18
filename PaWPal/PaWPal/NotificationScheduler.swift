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
        // Computes how many new notifications to schedule
        let calendar = NSCalendar.currentCalendar()
        let nsDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyy hh:mm:ss +zzzz"
        
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
        // TODO: call this in the right place
        var scheduledNewNotification = false
        let calendar = NSCalendar.currentCalendar()
        let nsDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyy hh:mm:ss +zzzz"
        
        let currentTimeComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: nsDate)
        
        let wakeTimeComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: nsDate)
        let wakeTime = DatabaseController.getWakeTime().componentsSeparatedByString(":")
        wakeTimeComponents.hour = Int(wakeTime[0])!
        let wakeTimeMinutesAndAmPm = wakeTime[1].componentsSeparatedByString(" ")
        wakeTimeComponents.minute = Int(wakeTimeMinutesAndAmPm[0])! + 30
        if (wakeTimeMinutesAndAmPm[1] == "PM") {
            wakeTimeComponents.hour += 12
        }
        
        let surveyCount = DatabaseController.getDailySurveyCount()
        // check if the user has already taken all of their surveys for the day
        if (surveyCount < 6) {
            let plusTwoHoursComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: nsDate)
            
            // don't ever schedule notifications between 2 am and the morning notification
            if (plusTwoHoursComponents.hour <= 2 || (plusTwoHoursComponents.hour >= wakeTimeComponents.hour && plusTwoHoursComponents.minute >= wakeTimeComponents.minute)) {
                plusTwoHoursComponents.hour += 2
                
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
                    let notification = UILocalNotification()
                    notification.alertBody = "It's time to take a survey!"
                    notification.alertAction = "open"
                    notification.fireDate = calendar.dateFromComponents(plusTwoHoursComponents)
                    UIApplication.sharedApplication().scheduleLocalNotification(notification)
                    DatabaseController.setClosestNotification(dateFormatter.stringFromDate(notification.fireDate!))
                    scheduledNewNotification = true
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
    
    static func clearScheduledNotifications() {
        UIApplication.sharedApplication().scheduledLocalNotifications = []
        DatabaseController.setFurthestNotification("")
        DatabaseController.setClosestNotification("")
        AppState.sharedInstance.closestScheduledNotification = ""
        AppState.sharedInstance.furthestScheduledNotification = ""
    }
    
    static func printScheduledNotifications() {
        print(UIApplication.sharedApplication().scheduledLocalNotifications)
    }
}