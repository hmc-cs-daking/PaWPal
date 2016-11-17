//
//  TextQuestion.swift
//  PaWPal
//
//  Created by Tiffany Fong on 9/26/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import Foundation
import UIKit

class TextQuestion: UIView {
    @IBOutlet weak var answerTextField: AutoCompleteTextField!
    @IBOutlet weak var promptLabel: UILabel!
    
    internal var required: Bool!
    
    // add question to survey
    static func create(question: String, key: String, placeHolder: String, required: Bool) -> TextQuestion {
        
        let textQuestion = NSBundle.mainBundle().loadNibNamed("TextQuestion", owner: self, options: nil).first as! TextQuestion
        
        textQuestion.promptLabel.text = question
        textQuestion.answerTextField.text = (AppState.sharedInstance.surveyList[key] as? String)!
        textQuestion.answerTextField.attributedPlaceholder = NSAttributedString(string: placeHolder)
        textQuestion.required = required

        return textQuestion
        
    }
}
