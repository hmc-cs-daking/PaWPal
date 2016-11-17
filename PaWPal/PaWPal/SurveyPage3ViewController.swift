//
//  SurveyPage3ViewController.swift
//  PaWPal
//
//  Created by Doren Lan on 10/4/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit

class SurveyPage3ViewController: UIViewController {
    var q1: SliderQuestion!
    var q2: SliderQuestion!
    var q3: SliderQuestion!
    var q4: SliderQuestion!
    
    @IBAction func save(sender: UIButton) {
        DatabaseController.updateSlider("challenge", question: q1)
        DatabaseController.updateSlider("skilled", question: q2)
        DatabaseController.updateSlider("succeeding", question: q3)
        DatabaseController.updateSlider("wishElse", question: q4)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create questions
        q1 = SliderQuestion.create("How challenging was this activity?",
                                        key: "challenge")
        q2 = SliderQuestion.create("How skilled are you at this activity?",
                                        key: "skilled")
        q3 = SliderQuestion.create("Were you succeeding at this activity?",
                                        key: "succeeding")
        q4 = SliderQuestion.create("Did you wish you had been doing something else?",
                                        key: "wishElse")
        
        self.displayQuestions([q1, q2, q3, q4], distribution: .FillEqually)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}