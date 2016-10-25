//
//  SurveyPage4ViewController.swift
//  PaWPal
//
//  Created by Doren Lan on 10/4/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit

class SurveyPage4ViewController: UIViewController {
    var temp1: MultiCheckQuestion!
    var temp2: TextQuestion!
    
    @IBAction func save(sender: UIButton) {
        // save data TODO - make required vs optional
        DatabaseController.updateMultiCheck("interaction", question: temp1)
        DatabaseController.updateText("howLong", question: temp2)
    }
    
    func displayQuestions(){
        
        // create the stack view
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.distribution = .FillProportionally
        stackView.alignment = .Fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // add questions to the stack view
        if let checkQ1 = NSBundle.mainBundle().loadNibNamed("MultiCheckQuestion", owner: self, options: nil).first as? MultiCheckQuestion {
            temp1 = checkQ1
            stackView.addArrangedSubview(checkQ1)
            checkQ1.promptLabel.text = "Who were you with? (Check all that apply)"
            
            // display the saved answers
            let answerArray: [Bool]! = AppState.sharedInstance.surveyList["interaction"] as? [Bool]
            for i in 0..<answerArray.count{
                checkQ1.switches[i].on = answerArray[i]
            }
        }
        
        if let textQ1 = NSBundle.mainBundle().loadNibNamed("TextQuestion", owner: self, options: nil).first as? TextQuestion {
            temp2 = textQ1
            stackView.addArrangedSubview(textQ1)
            textQ1.promptLabel.text = "How long had you been doing this activity for?"
            textQ1.answerTextField.text = AppState.sharedInstance.surveyList["howLong"] as? String
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