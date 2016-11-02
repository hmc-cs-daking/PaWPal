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
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var promptLabel: UILabel!
    
    // add question to survey
    static func addToSurvey(question: String, key: String, stackView: UIStackView, placeHolder: String) -> TextQuestion {
        let textQuestion = NSBundle.mainBundle().loadNibNamed("TextQuestion", owner: self, options: nil).first as! TextQuestion
        
        stackView.addArrangedSubview(textQuestion)
        textQuestion.promptLabel.text = question
        textQuestion.answerTextField.text = (AppState.sharedInstance.surveyList[key] as? String)!
        textQuestion.answerTextField.attributedPlaceholder = NSAttributedString(string: placeHolder)
        return textQuestion
        
    }
}
