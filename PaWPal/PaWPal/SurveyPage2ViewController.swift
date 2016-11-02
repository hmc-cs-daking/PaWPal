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
        DatabaseController.updateSlider("enjoyment", question: q1)
        DatabaseController.updateSlider("concentration", question: q2)
        DatabaseController.updateSlider("gettingBetter", question: q3)
        DatabaseController.updateSlider("choice", question: q4)
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
        q1 = SliderQuestion.addToSurvey("Did you enjoy what you were doing?",
                                           key: "enjoyment", stackView: stackView)
        q2 = SliderQuestion.addToSurvey("How well were you concentrating?",
                                        key: "concentration", stackView: stackView)
        q3 = SliderQuestion.addToSurvey("Were you getting better at something?",
                                        key: "gettingBetter", stackView: stackView)
        q4 = SliderQuestion.addToSurvey("Did you have some choice in picking the activity?",
                                        key: "choice", stackView: stackView)
         
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
