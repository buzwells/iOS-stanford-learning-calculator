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
    
    // true if the user has started entering a number
    var dataEntryInProgress : Bool = false
    
    @IBAction func numberButtonClicked(sender: UIButton) {
        println(sender.currentTitle!)
        if(dataEntryInProgress) {
            calculationResult.text = calculationResult.text! + sender.currentTitle!
        } else {
            calculationResult.text = sender.currentTitle!
            dataEntryInProgress = true
        }
    }
}

