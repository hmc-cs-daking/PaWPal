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
    
    func displayQuestions(){
        
        // create the stack view
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.distribution = .FillEqually
        stackView.alignment = .Fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // add questions to stack view
        q1 = SliderQuestion.addToSurvey("How challenging was this activity?",
                                        key: "challenge", stackView: stackView)
        q2 = SliderQuestion.addToSurvey("How skilled are you at this activity?",
                                        key: "skilled", stackView: stackView)
        q3 = SliderQuestion.addToSurvey("Were you succeeding at this activity?",
                                        key: "succeeding", stackView: stackView)
        q4 = SliderQuestion.addToSurvey("Did you wish you had been doing something else?",
                                        key: "wishElse", stackView: stackView)
        
        view.addSubview(stackView)
        
        //autolayout the stack view - pin 30 up 20 left 20 right 100 down
        let viewsDictionary = ["stackView":stackView]
        let stackView_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[stackView]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let stackView_V = NSLayoutConstraint.constraintsWithVisualFormat("V:|-30-[stackView]-100-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        view.addConstraints(stackView_H)
        view.addConstraints(stackView_V)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayQuestions()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}