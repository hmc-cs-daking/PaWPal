//
//  UIViewController+DisplayAlert.swift
//  PaWPal
//
//  Created by Tiffany Fong on 9/17/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import Foundation
import UIKit

// This extension allows all view controllers within PaWPal to use methods like displayAlert

extension UIViewController {
    
    /*
     * displayAlert
     *
     * Params:
     *    title - String - text at top of alert
     *    message - String - main text of alert
     *    handler - function - what happens after you dismiss alert
     *
     * Usage:
     *    self.displayAlert("Alert", message: "Click ok to dismiss alert", handler: nil)
     *
     *    self.displayAlert("Dismiss VC", message: "Click ok to dismiss this view controller",
     *      handler: { action in
     *        self.dismissViewControllerAnimated(true, completion: nil)
     *      })
     */
    func displayAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "Ok", style: .Default, handler: handler)
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    /*
     * displayYesNoAlert
     *
     * Params:
     *    title - String - text at top of alert
     *    message - String - main text of alert
     *    handler - function - what happens after you click "Yes"
     *
     * Usage:
     *    self.displayYesNoAlert("Alert", message: "Are you sure you want to submit?", yesHandler: submit)
     *
     * Note: Only "Yes" has a handler, "No" merely dismisses the alert
     */
    func displayYesNoAlert(title: String, message: String, yesHandler: ((UIAlertAction) -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .Default, handler: yesHandler))
        
        alertController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    /**
     * displayQuestions
     *
     * Params:
     *    questions: [UIView] - array of question views
     *    distribution: UIStackViewDistribution - describes how questions are spaced out
     *
     * Usage:
     *    self.displayQuestions([q1, q2, q3], .FillEqually)
     *    self.displayQuestions([q1], .FillProportionally)
     */
    
    // TODO move elsewhere?
    func displayQuestions(questions: [UIView], distribution: UIStackViewDistribution) {
        let stack = UIStackView()
        
        stack.axis = .Vertical
        stack.distribution = distribution
        stack.alignment = .Fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        for q in questions {
            stack.addArrangedSubview(q)
        }
        
        self.view.addSubview(stack)
        
        //autolayout the stack view - pin 30 up 20 left 20 right 100 down
        let viewsDictionary = ["stackView":stack]
        let stackView_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[stackView]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let stackView_V = NSLayoutConstraint.constraintsWithVisualFormat("V:|-30-[stackView]-100-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        self.view.addConstraints(stackView_H)
        self.view.addConstraints(stackView_V)
    }
    
}