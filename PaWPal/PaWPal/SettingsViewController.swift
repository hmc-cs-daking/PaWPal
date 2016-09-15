//
//  SettingsViewController.swift
//  PaWPal
//
//  Created by cs laptop on 9/12/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var wakeTextField: UITextField!
    @IBOutlet weak var sleepTextField: UITextField!
    var wakeTimePicker = UIDatePicker();
    var sleepTimePicker = UIDatePicker();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let wakeToolBar = createToolBar(#selector(SettingsViewController.wakeDonePressed));
        wakeTextField.inputAccessoryView = wakeToolBar;
        wakeTextField.inputView = wakeTimePicker;
        let sleepToolBar = createToolBar(#selector(SettingsViewController.sleepDonePressed));
        sleepTextField.inputAccessoryView = sleepToolBar;
        sleepTextField.inputView = sleepTimePicker;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func wakeDonePressed(sender: UIBarButtonItem) {
        wakeTextField.text = wakeTimePicker.date.description;
        wakeTextField.resignFirstResponder()
        
    }
    
    func sleepDonePressed(sender: UIBarButtonItem) {
        sleepTextField.text = sleepTimePicker.date.description;
        sleepTextField.resignFirstResponder();
    }
    
    func createToolBar(pressedFunc: Selector) -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
    
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
    
        toolBar.barStyle = UIBarStyle.BlackTranslucent
    
        toolBar.tintColor = UIColor.whiteColor()
    
        toolBar.backgroundColor = UIColor.blackColor()
    
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: pressedFunc)
    
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
    
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
    
        label.font = UIFont(name: "Helvetica", size: 12)
    
        label.backgroundColor = UIColor.clearColor()
    
        label.textColor = UIColor.whiteColor()
    
        label.textAlignment = NSTextAlignment.Center
    
        let textBtn = UIBarButtonItem(customView: label)
    
        toolBar.setItems([flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        return toolBar;
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
