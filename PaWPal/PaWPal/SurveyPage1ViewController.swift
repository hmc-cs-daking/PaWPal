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
    
    var locations: [String] = []
    var activities: [String] = []
    var other: [String] = []
    
    var autoCompleteDictionary = [AutoCompleteTextField: [String]]()
    
    @IBAction func next(sender: UIButton) {
        // check for filled text fields of mandatory questions
        for q in [q1, q2, q3] where q.required == true {
            guard let textAnswer = q.answerTextField.text
                where !textAnswer.isEmpty else {
                    self.displayAlert("Hello", message: "Please fill in all required fields :)", handler: nil)
                    return
            }
            
            DatabaseController.updateText(q)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create questions
        q1 = TextQuestion.create("Where were you?", key: "where", placeHolder: "Platt, Shanahan, Atwood, etc. ", required: true)
        q2 = TextQuestion.create("What was the main thing you were doing?", key: "activity", placeHolder: "Working, Class, Socializing etc. ", required: true)
        q3 = TextQuestion.create("(Optional) What else were you doing?", key: "elseOptional", placeHolder: "", required: false)
        
        self.displayQuestions([q1, q2, q3], distribution: .FillEqually)
        
        // Autocomplete
        for q in [q1, q2, q3] {
            q.answerTextField.autoCompleteTextFieldDataSource = self
            q.answerTextField.showAutoCompleteButton(autoCompleteButtonViewMode: .WhileEditing)
        }
        
        //set autocomplete strings
        locations = AppState.sharedInstance.locationSuggestions
        activities = AppState.sharedInstance.activitySuggestions
        other = AppState.sharedInstance.otherSuggestions
        
        autoCompleteDictionary = [q1.answerTextField:locations, q2.answerTextField:activities, q3.answerTextField:other]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func autoCompleteTextFieldDataSource(autoCompleteTextField: AutoCompleteTextField) -> [String] {
        
        return autoCompleteDictionary[autoCompleteTextField]!
    }
}