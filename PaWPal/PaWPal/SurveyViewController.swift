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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (NotificationScheduler.canTakeSurvey()) {
            startSurveyButton.enabled = true
        } else {
            startSurveyButton.backgroundColor = UIColor.grayColor()
            startSurveyButton.enabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}


