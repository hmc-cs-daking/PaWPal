//
//  SurveyPage4ViewController.swift
//  PaWPal
//
//  Created by Doren Lan on 10/4/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit

class SurveyPage4ViewController: UIViewController {
    var q1: MultiCheckQuestion!
    var q2: TextQuestion!
    
    @IBAction func save(sender: UIButton) {
        DatabaseController.updateMultiCheck("interaction", question: q1)
        DatabaseController.updateText("howLong", question: q2)
    }
    
    @IBAction func next(sender: UIButton) {
        // require numerical answer
        guard let textAnswer = q2.answerTextField.text
            where Float(textAnswer) != nil else {
                self.displayAlert("Hello", message: "Please enter a number :)", handler: nil)
                return
        }
        save(sender)
    }
    
    func displayQuestions(){
        
        // create the stack view
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.distribution = .FillProportionally
        stackView.alignment = .Fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // add questions to view
        q1 = MultiCheckQuestion.addToSurvey("Who were you with? (Check all that apply)", key: "interaction", stackView: stackView)
        q2 = TextQuestion.addToSurvey("How many hours have you been doing this activity?", key: "howLong", stackView: stackView, placeHolder: "", required: true)
        
        // for numerical answers
        q2.answerTextField.keyboardType = .NumberPad
        
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