//
//  SurveyPage1ViewController.swift
//  PaWPal
//
//  Created by Tiffany Fong on 9/27/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit

class SurveyPage1ViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        
        // MULTI CHECKBOX VIEW
        if let multiCheckQuestionView = NSBundle.mainBundle().loadNibNamed("MultiCheckQuestion", owner: self, options: nil).first as? MultiCheckQuestion {
            contentView.addSubview(multiCheckQuestionView)
            
            multiCheckQuestionView.promptLabel.text = "hello"
            multiCheckQuestionView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":multiCheckQuestionView]))
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":multiCheckQuestionView]))
        }

        
        // TEXT QUESTION VIEW
//        if let textQuestionView = NSBundle.mainBundle().loadNibNamed("TextQuestion", owner: self, options: nil).first as? TextQuestion {
//            contentView.addSubview(textQuestionView)
//            
//            textQuestionView.promptLabel.text = "hello"
//            textQuestionView.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":textQuestionView]))
//            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":textQuestionView]))
//        }

        // Do any additional setup after loading the view.
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
