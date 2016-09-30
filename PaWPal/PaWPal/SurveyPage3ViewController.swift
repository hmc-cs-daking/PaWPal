//
//  SurveyPage3ViewController.swift
//  PaWPal
//
//  Created by Amelia Sheppard on 9/28/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit

class SurveyPage3ViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var Page3StackView: UIStackView!
    
    //array of questions
    var page3Questions = [SliderQuestion]()
    
    var question1 = SliderQuestion()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Page3StackView.addSubview(question1)
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
