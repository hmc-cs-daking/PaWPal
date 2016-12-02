//
//  NotificationScheduler.swift
//  PaWPal
//
//  Created by cs laptop on 10/5/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import Foundation
import UIKit

// This class handles the scheduling and clearing of local notifications for taking surveys
class NotificationScheduler {
    
    // Schedule daily notifications for a week in advance at wakeTime + 30 minutes
    static func scheduleNotificationsOnSignIn() {
        let calendar = NSCalendar.currentCalendar()
        let nsDate = NSDate()
        let dateFormatter = getDateFormatter()
        
        let closestNotification = AppState.sharedInstance.closestScheduledNotification
        var furthestNotification = AppState.sharedInstance.furthestScheduledNotification
        
        // treat the current time as the furthest scheduled notification if there is no furthest scheduled notification
        if (furthestNotification == nil || furthestNotification == "") {
            furthestNotification = dateFormatter.stringFromDate(nsDate)
        }
        
        // set the times to be compared to 12 PM to count the days accurately
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
        let wakeTimeComponents = parseWakeTime(true)
        furthestComponents.hour = wakeTimeComponents.hour
        furthestComponents.minute = wakeTimeComponents.minute
        furthestComponents.second = 0
        
        // Schedules the appropriate amount of new notifications to have one each morning for the next 7 days
        for i in ((7-dayDifference)+1)..<8 {
            let notification = UILocalNotification()
            notification.alertBody = "Start your day off on the right foot!"
            notification.alertAction = "open"
            furthestComponents.day += 1
            notification.fireDate = calendar.dateFromComponents(furthestComponents)
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
            // handle initially setting the closest scheduled notification
            if ((closestNotification == nil || closestNotification == "") && i == 1) {
                DatabaseController.setClosestNotification(dateFormatter.stringFromDate(notification.fireDate!))
            }
            
            if (i == 7) {
                DatabaseController.setFurthestNotification(dateFormatter.stringFromDate(notification.fireDate!))
            }
        }
    }
    
    // upon survey submission, conditionally schedule another notification for approximately 2 hours later
    static func scheduleNextNotificationOfTheDay() {
        var scheduledNewNotification = false
        let calendar = NSCalendar.currentCalendar()
        let nsDate = NSDate()
        let dateFormatter = getDateFormatter()
        
        let currentTimeComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: nsDate)
        
        let wakeTimeComponents = parseWakeTime(true)
        
        let surveyCount = DatabaseController.getDailySurveyCount()
        // check if the user has already taken all of their surveys for the day
        if (surveyCount < 6) {
            // create a date that is two hours away
            var plusTwoHoursComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: nsDate)
            plusTwoHoursComponents.hour += 2
            plusTwoHoursComponents.second = 0
            
            // randomly add between -30 and 30 minutes to the 2 hours later time so that the user is not always getting
            // notifications at the exact same time
            let randomizedTimeAddition = Int(arc4random_uniform(61)) - 30
            plusTwoHoursComponents.minute += Int(randomizedTimeAddition)
            
            plusTwoHoursComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: calendar.dateFromComponents(plusTwoHoursComponents)!)
            
            // don't ever schedule notifications between 2 am and the morning notification
            if (plusTwoHoursComponents.hour < 2 || (plusTwoHoursComponents.hour >= (wakeTimeComponents.hour+2))) {
                
                if ((plusTwoHoursComponents.hour != wakeTimeComponents.hour+2) || (plusTwoHoursComponents.minute >= wakeTimeComponents.minute)) {
                
                    // parse sleep time
                    let sleepTimeComponents = parseSleepTime(true)
                
                    // check if the two hours later time is before the user's bedtime
                    if ((calendar.dateFromComponents(sleepTimeComponents))?.compare(calendar.dateFromComponents(plusTwoHoursComponents)!) == NSComparisonResult.OrderedDescending) {
                        // schedule a notification for two hours from current time
                        let notification = UILocalNotification()
                        notification.alertBody = "It's time to take a survey!"
                        notification.alertAction = "open"
                        notification.fireDate = calendar.dateFromComponents(plusTwoHoursComponents)
                        UIApplication.sharedApplication().scheduleLocalNotification(notification)
                    DatabaseController.setClosestNotification(dateFormatter.stringFromDate(notification.fireDate!))
                        scheduledNewNotification = true
                    }
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
    
    // if we are determined to be on a new day, reset the daily survey count
    static func resetDailyCountIfNecessary() {
        let dateFormatter = getDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        let nsDate = NSDate()
        
        let currentComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: nsDate)
        
        if (currentComponents.hour < 2) {
            return
        }
        
        currentComponents.hour = 2
        let lastAction = dateFormatter.dateFromString(DatabaseController.getLastActionTakenAt())
        
        if (calendar.dateFromComponents(currentComponents)!.compare(lastAction!) == NSComparisonResult.OrderedDescending) {
            DatabaseController.resetDailySurveyCount()
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
    
    // determine if the user should be allowed to take a survey by checking if the current time is past the
    // closest notification time, and either past the wake time or before the sleep time
    static func canTakeSurvey() -> Bool {
        let calendar = NSCalendar.currentCalendar()
        let nsDate = NSDate()
        let formatter = getDateFormatter()
        let currentTimeComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: nsDate)
        let closestNotificationTimeComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: formatter.dateFromString(DatabaseController.getClosestNotification())!)
        
        let wakeTimeComponents = parseWakeTime(true)
        
        let sleepTimeComponents = parseSleepTime(false)
        
        if ((calendar.dateFromComponents(currentTimeComponents)!.compare(calendar.dateFromComponents(closestNotificationTimeComponents)!) == NSComparisonResult.OrderedDescending) && ((calendar.dateFromComponents(currentTimeComponents)!.compare(calendar.dateFromComponents(wakeTimeComponents)!) == NSComparisonResult.OrderedDescending) || (calendar.dateFromComponents(sleepTimeComponents)!.compare(calendar.dateFromComponents(currentTimeComponents)!) == NSComparisonResult.OrderedDescending))) {
            return true
        } else {
            return false
        }
    }
    
    // parse a string that looks like '9:00 AM' into NSDateComponents
    static func parseTime(time: String, addThirtyMinutes: Bool, addDayIfAM: Bool) -> NSDateComponents {
        let calendar = NSCalendar.currentCalendar()
        let nsDate = NSDate()
        var timeComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: nsDate)
        let timePieces = time.componentsSeparatedByString(":")
        timeComponents.hour = Int(timePieces[0])!
        let timeMinutesAndAmPm = timePieces[1].componentsSeparatedByString(" ")
        timeComponents.minute = Int(timeMinutesAndAmPm[0])!
        timeComponents.second = 0
        if (addDayIfAM && timeMinutesAndAmPm[1] == "AM") {
            timeComponents.day += 1
        }
        if (addThirtyMinutes) {
            timeComponents.minute += 30
        }
        if (timeMinutesAndAmPm[1] == "PM") {
            timeComponents.hour += 12
        }
        timeComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: calendar.dateFromComponents(timeComponents)!)
        
        return timeComponents
    }
    
    static func parseWakeTime(addThirtyMinutes: Bool) -> NSDateComponents {
        return parseTime(DatabaseController.getWakeTime(), addThirtyMinutes: addThirtyMinutes, addDayIfAM: false)
    }
    
    static func parseSleepTime(addDayIfAM: Bool) -> NSDateComponents {
        return parseTime(DatabaseController.getSleepTime(), addThirtyMinutes: false, addDayIfAM: addDayIfAM)
    }
}