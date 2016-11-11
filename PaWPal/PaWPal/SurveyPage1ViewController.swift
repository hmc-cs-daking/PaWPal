//
//  SurveyPage1ViewController.swift
//  PaWPal
//
//  Created by Tiffany Fong on 9/27/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit

class SurveyPage1ViewController: UIViewController, AutoCompleteTextFieldDataSource, AutoCompleteTextFieldDelegate {
    var q1: TextQuestion!
    var q2: TextQuestion!
    var q3: TextQuestion!
    
    var locations: [String] = ["Platt", "Place", "Shanahan", "Atwood"]
    var activities: [String] = ["Working", "Class"]
    var other: [String] = ["Sleeping", "Netflix"]
    
    var autoCompleteDictionary = [AutoCompleteTextField: [String]]()
    
    @IBAction func next(sender: UIButton) {
        // check for filled text fields of mandatory questions
        for q in [q1, q2, q3] where q.required == true {
            guard let textAnswer = q.answerTextField.text
                where !textAnswer.isEmpty else {
                    self.displayAlert("Hello", message: "Please fill in all required fields :)", handler: nil)
                    return
            }
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
        q1 = TextQuestion.addToSurvey("Where were you?", key: "where", stackView: stackView, placeHolder: "Platt, Shanahan, Atwood, etc. ", required: true)
        q2 = TextQuestion.addToSurvey("What was the main thing you were doing?", key: "activity", stackView: stackView, placeHolder: "Working, Class, etc. ", required: true)
        q3 = TextQuestion.addToSurvey("(Optional) What else were you doing?", key: "elseOptional", stackView: stackView, placeHolder: "", required: false)
        
        view.addSubview(stackView)
        
        //autolayout the stack view - pin 30 up 20 left 20 right 100 down
        let viewsDictionary = ["stackView":stackView]
        let stackView_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[stackView]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let stackView_V = NSLayoutConstraint.constraintsWithVisualFormat("V:|-30-[stackView]-100-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        view.addConstraints(stackView_H)
        view.addConstraints(stackView_V)
        
        autoCompleteDictionary = [q1.answerTextField:locations, q2.answerTextField:activities, q3.answerTextField:other]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayQuestions()
        q1.answerTextField.autoCompleteTextFieldDataSource = self
        q1.answerTextField.showAutoCompleteButton(autoCompleteButtonViewMode: .WhileEditing)
        q2.answerTextField.autoCompleteTextFieldDataSource = self
        q2.answerTextField.showAutoCompleteButton(autoCompleteButtonViewMode: .WhileEditing)
        q3.answerTextField.autoCompleteTextFieldDataSource = self
        q3.answerTextField.showAutoCompleteButton(autoCompleteButtonViewMode: .WhileEditing)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func autoCompleteTextFieldDataSource(autoCompleteTextField: AutoCompleteTextField) -> [String] {
        
        return autoCompleteDictionary[autoCompleteTextField]!
    }
}