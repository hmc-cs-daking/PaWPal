//
//  SurveyPage3ViewController.swift
//  PaWPal
//
//  Created by Doren Lan on 10/4/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit

class SurveyPage3ViewController: UIViewController {
    var temp1: SliderQuestion!
    var temp2: SliderQuestion!
    var temp3: SliderQuestion!
    var temp4: SliderQuestion!
    
    @IBAction func next(sender: UIButton) {
        // save data TODO - make required vs optional
        DatabaseController.updateSlider("challenge", question: temp1)
        DatabaseController.updateSlider("skilled", question: temp2)
        DatabaseController.updateSlider("succeeding", question: temp3)
        DatabaseController.updateSlider("wishElse", question: temp4)
    }
    
    func displayQuestions(){
        
        // create the stack view
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.distribution = .FillEqually
        stackView.alignment = .Fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // add questions to the stack view
        if let sliderQ1 = NSBundle.mainBundle().loadNibNamed("SliderQuestion", owner: self, options: nil).first as? SliderQuestion {
            temp1 = sliderQ1
            stackView.addArrangedSubview(sliderQ1)
            sliderQ1.promptLabel.text = "How challenging was this activity?"
            sliderQ1.answerSlider.value = (AppState.sharedInstance.surveyList["challenge"] as? Float)!
        }
        
        if let sliderQ2 = NSBundle.mainBundle().loadNibNamed("SliderQuestion", owner: self, options: nil).first as? SliderQuestion {
            temp2 = sliderQ2
            stackView.addArrangedSubview(sliderQ2)
            sliderQ2.promptLabel.text = "How skilled are you at this activity?"
            sliderQ2.answerSlider.value = (AppState.sharedInstance.surveyList["skilled"] as? Float)!
        }
        
        if let sliderQ3 = NSBundle.mainBundle().loadNibNamed("SliderQuestion", owner: self, options: nil).first as? SliderQuestion {
            temp3 = sliderQ3
            stackView.addArrangedSubview(sliderQ3)
            sliderQ3.promptLabel.text = "Were you succeeding at this activity?"
            sliderQ3.answerSlider.value = (AppState.sharedInstance.surveyList["succeeding"] as? Float)!
        }
        
        if let sliderQ4 = NSBundle.mainBundle().loadNibNamed("SliderQuestion", owner: self, options: nil).first as? SliderQuestion {
            temp4 = sliderQ4
            stackView.addArrangedSubview(sliderQ4)
            sliderQ4.promptLabel.text = "Did you wish you had been doing something else?"
            sliderQ4.answerSlider.value = (AppState.sharedInstance.surveyList["wishElse"] as? Float)!
        }
        
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
    
}