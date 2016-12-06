//
//  SurveyPage2ViewController.swift
//  PaWPal
//
//  Created by Tiffany Fong on 9/27/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit

class SurveyPage2ViewController: UIViewController {
    var q1: SliderQuestion!
    var q2: SliderQuestion!
    var q3: SliderQuestion!
    var q4: SliderQuestion!
    
    @IBAction func save(sender: UIButton) {
        for q in [q1, q2, q3, q4] {
            DatabaseController.updateAnswer(q)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create questions
        q1 = SliderQuestion.create("Did you enjoy what you were doing?",
                                        key: "enjoyment")
        q2 = SliderQuestion.create("How well were you concentrating?",
                                        key: "concentration")
        q3 = SliderQuestion.create("Were you getting better at something?",
                                        key: "gettingBetter")
        q4 = SliderQuestion.create("Did you have some choice in picking the activity?",
                                        key: "choice")
        
        self.displayQuestions([q1, q2, q3, q4], distribution: .FillEqually)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
