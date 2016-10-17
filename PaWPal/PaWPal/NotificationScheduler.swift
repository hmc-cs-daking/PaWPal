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
        clearScheduledNotifications()
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