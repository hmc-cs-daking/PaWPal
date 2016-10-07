//
//  Question.swift
//  PaWPal
//
//  Created by Tiffany Fong on 10/6/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import Foundation
import UIKit

// Question class - subclass of UIView
// Every question has a prompt, but subclasses will determine the answer format

// Subclasses: TextQuestion, SliderQuestion, MultiCheckQuestion, MultiSliderQuestion
// Each subclass has a corresponding xib file for the UIView

class Question: UIView {
    var prompt: String
    
    init(prompt: String) {
        self.prompt = prompt
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100)) // not sure how big this turns out
    }
    
    required init?(coder aDecoder: NSCoder) { // can't make Question without this
        fatalError("init(coder:) has not been implemented");
    }
}