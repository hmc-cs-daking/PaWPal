//
//  MultiSliderQuestion.swift
//  PaWPal
//
//  Created by Tiffany Fong on 10/4/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import Foundation
import UIKit

class MultiSliderQuestion: UIView {
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet var sliders: [UISlider]!
    @IBOutlet var lowLabels: [UILabel]!
    @IBOutlet var highLabels: [UILabel]!
    
    @IBAction func moved(sender: UISlider) {
        sender.setValue(Float(lroundf(sender.value)), animated: true)
    }
    
    static func addToSurvey(question: String, key: String, stackView: UIStackView) -> MultiSliderQuestion{
        let multiSliderQuestionView = NSBundle.mainBundle().loadNibNamed("MultiSliderQuestion", owner: self, options: nil).first as! MultiSliderQuestion
        stackView.addArrangedSubview(multiSliderQuestionView)
        multiSliderQuestionView.promptLabel.text = question
            
        //display all saved answers
        let answerArray: [Float]! = AppState.sharedInstance.surveyList[key] as? [Float]
        for i in 0..<answerArray.count{
            multiSliderQuestionView.sliders[i].value = answerArray[i]
        }
        return multiSliderQuestionView
    }
    
}
