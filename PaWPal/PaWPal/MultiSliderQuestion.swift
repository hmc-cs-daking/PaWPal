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
    
    @IBOutlet weak var answerSlider1: UISlider!
    @IBOutlet weak var lowLabel1: UILabel!
    @IBOutlet weak var highLabel1: UILabel!
    
    @IBOutlet weak var answerSlider2: UISlider!
    @IBOutlet weak var lowLabel2: UILabel!
    @IBOutlet weak var highLabel2: UILabel!
    
    @IBOutlet weak var answerSlider3: UISlider!
    @IBOutlet weak var lowLabel3: UILabel!
    @IBOutlet weak var highLabel3: UILabel!
    
    @IBOutlet weak var answerSlider4: UISlider!
    @IBOutlet weak var lowLabel4: UILabel!
    @IBOutlet weak var highLabel4: UILabel!
    
    @IBOutlet weak var answerSlider5: UISlider!
    @IBOutlet weak var lowLabel5: UILabel!
    @IBOutlet weak var highLabel5: UILabel!
    
    @IBAction func slider1Moved(sender: UISlider) {
        sender.setValue(Float(lroundf(answerSlider1.value)), animated: true)
    }
    @IBAction func slider2Moved(sender: UISlider) {
        sender.setValue(Float(lroundf(answerSlider2.value)), animated: true)
    }
    @IBAction func slider3Moved(sender: UISlider) {
        sender.setValue(Float(lroundf(answerSlider3.value)), animated: true)
    }
    @IBAction func slider4Moved(sender: UISlider) {
        sender.setValue(Float(lroundf(answerSlider4.value)), animated: true)
    }
    @IBAction func slider5Moved(sender: UISlider) {
        sender.setValue(Float(lroundf(answerSlider5.value)), animated: true)
    }
    
}
