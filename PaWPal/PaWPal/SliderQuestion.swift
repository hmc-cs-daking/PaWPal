//
//  SliderQuestion.swift
//  PaWPal
//
//  Created by Tiffany Fong on 9/27/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import Foundation
import UIKit

class SliderQuestion: UIView {
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var answerSlider: UISlider!
    
    @IBAction func sliderMoved(sender: UISlider) {
        sender.setValue(Float(lroundf(answerSlider.value)), animated: true)
    }
    
    static func addToSurvey(question: String, key: String, stackView: UIStackView) -> SliderQuestion {
        let sliderQuestion = NSBundle.mainBundle().loadNibNamed("SliderQuestion", owner: self, options: nil).first as! SliderQuestion //else {
            // throw error
          //  return nil
      //  }
        
        // TODO
        // use guard instead of force unwrapping 
        
        stackView.addArrangedSubview(sliderQuestion)
        sliderQuestion.promptLabel.text = question
        sliderQuestion.answerSlider.value = (AppState.sharedInstance.surveyList[key] as? Float)!
        return sliderQuestion
        
    }
}
