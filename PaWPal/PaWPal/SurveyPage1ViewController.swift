//
//  SurveyPage1ViewController.swift
//  PaWPal
//
//  Created by Tiffany Fong on 9/27/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit


class SurveyPage1ViewController: UIViewController {
    var temp1: TextQuestion!
    var temp2: TextQuestion!
    var temp3: TextQuestion!
    var locations: [String]? = ["Platt", "Place", "Shanahan", "Atwood"]
    var activities: [String] = ["Working", "Class"]
 
    
    @IBAction func next(sender: UIButton) {
        // require that text fields be complete
        guard let textAnswer1 = q1.answerTextField.text
            where !textAnswer1.isEmpty else {
                self.displayAlert("Hello", message: "Please fill in all required fields :)", handler: nil)
                return
        }
        guard let textAnswer2 = q2.answerTextField.text
            where !textAnswer2.isEmpty else {
                self.displayAlert("Hello", message: "Please fill in all required fields :)", handler: nil)
                return
        }
        DatabaseController.updateText("where", question: q1)
        DatabaseController.updateText("activity", question: q2)
        DatabaseController.updateText("elseOptional", question: q3)
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
        if let textQ1 = NSBundle.mainBundle().loadNibNamed("TextQuestion", owner: self, options: nil).first as? TextQuestion {
            temp1 = textQ1
            stackView.addArrangedSubview(textQ1)
            textQ1.promptLabel.text = "Where were you?"
            textQ1.answerTextField.attributedPlaceholder = NSAttributedString(string:"Platt, Shanahan, Atwood, etc. ")
            textQ1.answerTextField.text = AppState.sharedInstance.surveyList["where"] as? String
        }
        
        if let textQ2 = NSBundle.mainBundle().loadNibNamed("TextQuestion", owner: self, options: nil).first as? TextQuestion {
            temp2 = textQ2
            stackView.addArrangedSubview(textQ2)
            textQ2.promptLabel.text = "What was the main thing you were doing?"
            textQ2.answerTextField.attributedPlaceholder = NSAttributedString(string:"Working, Class, etc. ")
            textQ2.answerTextField.text = AppState.sharedInstance.surveyList["activity"] as? String
        }
        
        if let textQ3 = NSBundle.mainBundle().loadNibNamed("TextQuestion", owner: self, options: nil).first as? TextQuestion {
            temp3 = textQ3
            stackView.addArrangedSubview(textQ3)
            textQ3.promptLabel.text = "(Optional) What else were you doing?"
            textQ3.answerTextField.text = AppState.sharedInstance.surveyList["elseOptional"] as? String
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
