//
//  SurveyPage4ViewController.swift
//  PaWPal
//
//  Created by Doren Lan on 10/4/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit

class SurveyPage4ViewController: UIViewController {
    
    func displayQuestions(){
        
        // create the stack view
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.distribution = .FillEqually
        stackView.alignment = .Fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // add questions to the stack view
        if let textQ1 = NSBundle.mainBundle().loadNibNamed("TextQuestion", owner: self, options: nil).first as? TextQuestion {
            stackView.addArrangedSubview(textQ1)
            textQ1.promptLabel.text = "This is a Text Question (number 1)?"
        }
        
        if let sliderQ1 = NSBundle.mainBundle().loadNibNamed("SliderQuestion", owner: self, options: nil).first as? SliderQuestion {
            stackView.addArrangedSubview(sliderQ1)
            sliderQ1.promptLabel.text = "This is a Slider Question?"
        }
        
        if let textQ2 = NSBundle.mainBundle().loadNibNamed("TextQuestion", owner: self, options: nil).first as? TextQuestion {
            stackView.addArrangedSubview(textQ2)
            textQ2.promptLabel.text = "This is a Text Question (number 2)?"
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