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
        DatabaseController.updateMultiSlider("feeling", question: q1)
    }
    
    func displayQuestions(){
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.distribution = .FillEqually
        stackView.alignment = .Fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        q1 = MultiSliderQuestion.addToSurvey("Describe your mood as you were pinged", key: "feeling", stackView: stackView)
        
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
