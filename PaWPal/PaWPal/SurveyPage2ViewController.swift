//
//  SurveyPage2ViewController.swift
//  PaWPal
//
//  Created by Tiffany Fong on 9/27/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit

class SurveyPage2ViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        
        // MULTI SLIDER
        if let multiSliderQuestionView = NSBundle.mainBundle().loadNibNamed("MultiSliderQuestion", owner: self, options: nil).first as? MultiSliderQuestion {
            contentView.addSubview(multiSliderQuestionView)
            
            multiSliderQuestionView.promptLabel.text = "Multi sliders!"
            multiSliderQuestionView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":multiSliderQuestionView]))
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":multiSliderQuestionView]))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
