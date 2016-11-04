//
//  SurveyViewController.swift
//  PaWPal
//
//  Created by cs laptop on 9/9/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit


class SurveyViewController: UIViewController {

    @IBOutlet weak var startSurveyButton: UIButton!
    @IBOutlet weak var nextSurveyTimeLabel: UILabel!
    @IBOutlet weak var nextSurveyPromptLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (NotificationScheduler.canTakeSurvey()) {
            startSurveyButton.enabled = true
            startSurveyButton.backgroundColor = UIColor.orangeColor()
            nextSurveyTimeLabel.text = ""
            nextSurveyPromptLabel.text = ""
        } else {
            startSurveyButton.backgroundColor = UIColor.grayColor()
            startSurveyButton.enabled = false
            
            let formatter = NotificationScheduler.getDateFormatter()
            let nextSurveyDate = formatter.dateFromString(DatabaseController.getClosestNotification())
            
            let newFormatter = NSDateFormatter()
            newFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            print(nextSurveyDate)
            let nextSurveyTime = newFormatter.stringFromDate(nextSurveyDate!)
            nextSurveyTimeLabel.text = nextSurveyTime
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}


