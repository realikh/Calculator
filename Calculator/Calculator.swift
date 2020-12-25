//
//  Calculator.swift
//  Calculator
//
//  Created by Alikhan Khassen on 22.12.2020.
//

import Foundation


struct Calculator {
    var currentValue: Double = 0.0
    var savedValue: Double?
    var currentOperation = Operation.none
    var errorOccured = false
    
    var operations: [String: Operation] = [
        "+": .addition,
        "–": .subtraction,
        "×": .multiplication,
        "÷": .division,
        "%": .percent
    ]
    
    mutating func getResult() -> String {
        switch currentOperation {
        case .none:
            return "\(self.currentValue)"
        case .addition:
            return "\((savedValue! + currentValue).cleanString)"
        case .subtraction:
            return "\((savedValue! - currentValue).cleanString)"
        case .multiplication:
            return "\((savedValue! * currentValue).cleanString)"
        case .division:
            if currentValue == 0 { errorOccured = true}
            return currentValue != 0 ? "\((savedValue! / currentValue).cleanString)" : "Error"
        case .percent:
            return ("\(currentValue / 100)")
        }
    }
}

enum Operation {
    case addition
    case subtraction
    case multiplication
    case division
    case percent
    case none
}

extension Double {
    var cleanString: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
