//
//  MultiCheckQuestion.swift
//  PaWPal
//
//  Created by Tiffany Fong on 10/4/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import Foundation
import UIKit

class MultiCheckQuestion: UIView {
    
    @IBOutlet weak var promptLabel: UILabel!
    
    @IBOutlet var switches: [UISwitch]!
    @IBOutlet var labels: [UILabel]!
    
    static func create(question: String, key: String) -> MultiCheckQuestion{
        let checkQuestion = NSBundle.mainBundle().loadNibNamed("MultiCheckQuestion", owner: self, options: nil).first as! MultiCheckQuestion
        
        checkQuestion.promptLabel.text = question
            
        // display the saved answers
        let answerArray: [Bool]! = AppState.sharedInstance.surveyList[key] as? [Bool]
        for i in 0..<answerArray.count{
            checkQuestion.switches[i].on = answerArray[i]
        }
        return checkQuestion
    }
    
}