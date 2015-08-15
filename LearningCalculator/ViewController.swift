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
    var dataEntryInProgress = false
    
    let mathConstants = ["π": M_PI]
    
    private var brain = CalculatorBrain()
    
    @IBAction func numberButtonClicked(sender: UIButton) {
        let digit = sender.currentTitle!
        if(dataEntryInProgress) {
            if (NSNumberFormatter().numberFromString(calculationResult.text! + digit) != nil) {
                calculationResult.text = calculationResult.text! + digit
            }
        } else {
            calculationResult.text = digit
            dataEntryInProgress = true
        }
    }
    
    @IBAction func addConstantOperand(sender: UIButton) {
        let mathKey = sender.currentTitle!
        if dataEntryInProgress {
            enter()
        }
        displayValue = mathConstants[mathKey]!
        enter()
    }
    
    @IBAction func operate(sender: UIButton) {
        if dataEntryInProgress {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            }
        }
    }
    
    @IBAction func enter() {
        dataEntryInProgress = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            // add error handling, which also involves converting displayValue to an Optional
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(calculationResult.text!)!.doubleValue
        }
        set {
            calculationResult.text = "\(newValue)"
            dataEntryInProgress = false
        }
    }
}

