//
//  SurveyViewController.swift
//  PaWPal
//
//  Created by cs laptop on 9/9/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit


class SurveyViewController: UIViewController {

    @IBOutlet weak var QuestionLabel: UILabel!
    
    @IBOutlet weak var AnswerButton1: UIButton!
    @IBOutlet weak var AnswerButton2: UIButton!
    @IBOutlet weak var AnswerButton3: UIButton!
    @IBOutlet weak var AnswerButton4: UIButton!
    
    var questions: [String] = ["Question 1", "Question 2", "Question 3", "Question 4", "Question 5", "Question 6"];
    
    var a1on:Bool = false;
    var a2on:Bool = false;
    var a3on:Bool = false;
    var a4on:Bool = false;
    
    func nextQuestion(num: Int){
        
        QuestionLabel.text = questions[num];
        AnswerButton1.setTitle("A1", forState:UIControlState.Normal);
        AnswerButton2.setTitle("A2", forState: UIControlState.Normal);
        AnswerButton3.setTitle("A3", forState: UIControlState.Normal);
        AnswerButton4.setTitle("A4", forState: UIControlState.Normal);
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func AnswerButton1Action(sender: AnyObject) {
        if a1on{
            AnswerButton1.backgroundColor = UIColor.cyanColor();
            a1on = false;
        }
        else{
            AnswerButton1.backgroundColor = UIColor.blueColor();
            a1on = true;
        }
    }

    @IBAction func AnswerButton2Action(sender: AnyObject) {
        if a2on{
            AnswerButton2.backgroundColor = UIColor.cyanColor();
            a2on = false;
        }
        else{
            AnswerButton2.backgroundColor = UIColor.blueColor();
            a2on = false;
        }
    }
    
    @IBAction func AnswerButton3Action(sender: AnyObject) {
        if a3on{
            AnswerButton3.backgroundColor = UIColor.cyanColor();
            a3on = false;
        }
        else{
            AnswerButton3.backgroundColor = UIColor.blueColor();
            a3on = true;
        }
    }
    
    @IBAction func AnswerButton4Action(sender: AnyObject) {
        if a4on{
            AnswerButton4.backgroundColor = UIColor.cyanColor();
            a4on = false;
        }
        else{
            AnswerButton4.backgroundColor = UIColor.blueColor();
            a4on = true;
        }
    }
}

