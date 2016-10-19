//
//  SurveyPage5ViewController.swift
//  PaWPal
//
//  Created by Doren Lan on 10/5/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit

class SurveyPage5ViewController: UIViewController {
    
    var temp1: MultiSliderQuestion!
    
    @IBAction func next(sender: UIButton) {
        // save data TODO - make required vs optional
        DatabaseController.updateMultiSlider("feeling", question: temp1)
    }
    
    func displayQuestions(){
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.distribution = .FillEqually
        stackView.alignment = .Fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // MULTI SLIDER
        if let multiSliderQuestionView = NSBundle.mainBundle().loadNibNamed("MultiSliderQuestion", owner: self, options: nil).first as? MultiSliderQuestion {
            temp1 = multiSliderQuestionView
            stackView.addArrangedSubview(multiSliderQuestionView)
            multiSliderQuestionView.promptLabel.text = "Describe your mood as you were pinged"
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
