//
//  SurveyPage6ViewController.swift
//  PaWPal
//
//  Created by Doren Lan on 10/17/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit

class SurveyPage6ViewController: UIViewController {
    var q1: TextQuestion!
    var q2: TextQuestion!
    
    
    @IBAction func save(sender: UIButton) {
        // save data
        for q in [q1, q2] {
            DatabaseController.updateText(q)
        }
        
        self.displayYesNoAlert("Alert", message: "Are you sure you want to submit?", yesHandler: submit)
    }
    
    func submit(alert: UIAlertAction!) {
        // record timestamp
        let timestamp = DataProcessor.makeKeyTimeStamp(NSDate())
        AppState.sharedInstance.surveyList["timestamp"] = timestamp
        
        //submit survey and update autocomplete
        DatabaseController.submitSurvey()
        

        DatabaseController.incrementDailySurveyCount()
        DatabaseController.incrementTotalSurveyCount()
        NotificationScheduler.scheduleNextNotificationOfTheDay()
        
        
        let formatter = NotificationScheduler.getDateFormatter()
        DatabaseController.setLastActionTakenAt(formatter.stringFromDate(NSDate()))
        
        // go back to main survey page
        performSegueWithIdentifier("SurveyPage6ToSurvey", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create questions
        q1 = TextQuestion.create("(Optional) If you were feeling strong emotions, why?", key: "strongEmotionsOptional", placeHolder: "Describe", required: false)
        q2 = TextQuestion.create("(Optional) Was there something else on your mind?", key: "elseMindOptional", placeHolder: "Describe", required: false)
        
        self.displayQuestions([q1, q2], distribution: .FillEqually)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
