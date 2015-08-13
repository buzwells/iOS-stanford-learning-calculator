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
    
    var operands = Array<Double>()
    
    let mathConstants = ["π": M_PI]
    
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
        let operation = sender.currentTitle!
        if dataEntryInProgress {
            enter()
        }
        switch operation {
            case "×": performOperation { $0 * $1 }
            case "÷": performOperation { $1 / $0 }
            case "+": performOperation { $0 + $1 }
            case "−": performOperation { $1 - $0 }
            case "√": performSingleOperation { sqrt($0) }
            case "sin": performSingleOperation { sin($0) }
            case "cos": performSingleOperation { cos($0) }
            default: break
        }
    }
    
    func performOperation(operation: (Double, Double ) -> Double) {
        if operands.count > 1 {
            displayValue = operation(operands.removeLast(), operands.removeLast())
            enter()
        }
    }
    
    /* the lecture tried to demonstrate that Swift tolerates 
       methods with the same name and return value but a different
       number of args, but new compiler issues an error b/c this
       class inherits from an Obj-C class, which is not so tolerant.
       Makes this technique unsafe - so changed name of method.
     */
    func performSingleOperation(operation: Double -> Double) {
        if operands.count > 0 {
            displayValue = operation(operands.removeLast())
            enter()
        }
    }
    
    @IBAction func enter() {
        dataEntryInProgress = false
        operands.append(displayValue)
        println(operands)
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

