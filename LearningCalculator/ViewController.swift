//
//  ViewController.swift
//  LearningCalculator
//
//  Created by Joel Wells on 8/4/15.
//  Copyright (c) 2015 Joel Wells. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var calculationResult: UILabel!
    
    @IBAction func numberButtonClicked(sender: UIButton) {
        println(sender.currentTitle!)
        if(calculationResult.text == "0") {
            calculationResult.text = sender.currentTitle!
            
        } else {
            calculationResult.text = calculationResult.text! + sender.currentTitle!
        }
    }
}

