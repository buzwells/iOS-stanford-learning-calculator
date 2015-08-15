//
//  CalculatorBrain.swift
//  LearningCalculator
//
//  Created by Joel Wells on 8/15/15.
//  Copyright (c) 2015 Joel Wells. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    /*
    * So many neat things here! The enum is so flexible, allowing simple doubles and operations
    * of varying degrees of complexity to be declared as cases. Also, note the "Printable" protocol
    * implemented by the enum by defining "description". This will control how the enum renders as
    * a string (not unlike the Java toString() method).
    */
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description:String {
            get{
                // can switch on itself
                switch self {
                // note the dot notation, since these are cases of the enum - also note how the arguments can be named for use in the switch logic
                case .Operand(let operand):
                    return "\(operand)"
                // the empty underline (underbar) indicates something to be ignored - love this simple, elegant language feature
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    //Swift's economical Array declaration and initialization
    private var opStack = [Op]()
    //Swift's economical dictionary declaration and initialization
    private var knownOps = [String: Op]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") { $1 - $0})
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
    }
    
    // recursive function that takes a stack of operations and returns a result after drilling into the stack
    // the result is an Optional, since the stack could be empty or the contents may not otherwise evaluate properly
    private func evaluate(ops : [Op] ) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            // many neat things in this compact recursion, but it seems brittle to me. 
            // if the user enters things in an unexpected sequence, the evaluation stops or fails
            // perhaps we should prevent the user from doing silly things like entering two operations in a row or
            // if we only support a max of binary ops, entering three operands in a row. Perhaps it's because I'm 
            // not familiar with using this sort of calculator
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let opEvaluation = evaluate(remainingOps)
                if let operand = opEvaluation.result {
                    return (operation(operand), opEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let( result, remainder ) = evaluate(opStack)
        println("opStack \(opStack) evaluates to \(result) with a remaining stack of \(remainder)")
        return result
    }
    
    func pushOperand(operand : Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol : String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}