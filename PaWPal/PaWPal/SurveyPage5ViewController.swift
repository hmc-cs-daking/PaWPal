//
//  SurveyPage5ViewController.swift
//  PaWPal
//
//  Created by Doren Lan on 10/5/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit

class SurveyPage5ViewController: UIViewController {
    
    var q1: MultiSliderQuestion!
    
    @IBAction func save(sender: UIButton) {
        DatabaseController.updateMultiSlider(q1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        q1 = MultiSliderQuestion.create("Describe your mood as you were pinged", key: "feeling")
        
        self.displayQuestions([q1], distribution: .FillEqually)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
