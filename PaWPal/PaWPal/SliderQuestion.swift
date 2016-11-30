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
    
    internal var key: String!
    
    @IBAction func sliderMoved(sender: UISlider) {
        sender.setValue(Float(lroundf(sender.value)), animated: true)
    }
    
    static func create(question: String, key: String) -> SliderQuestion {
        let sliderQuestion = NSBundle.mainBundle().loadNibNamed("SliderQuestion", owner: self, options: nil).first as! SliderQuestion
        
        sliderQuestion.promptLabel.text = question
        sliderQuestion.answerSlider.value = (AppState.sharedInstance.surveyList[key] as? Float)!
        sliderQuestion.key = key
        
        return sliderQuestion
    }
}
