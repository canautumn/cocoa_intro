//
//  ViewController.swift
//  Calculator
//
//  Created by Can on 6/22/15.
//  Copyright © 2015 Can. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!

    var userIsInTheMiddleOfEntering = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        if userIsInTheMiddleOfEntering {
            // place the decimal check here so that the user can start entering by pressing "."
            if sender.currentTitle! == "." && display.text!.rangeOfString(".") != nil { return }
            display.text! = display.text! + sender.currentTitle!
        } else {
            display.text! = sender.currentTitle!
            userIsInTheMiddleOfEntering = true
        }
    }
    
    @IBAction func enter() {
        if let operand = displayValue {
            appendLineToHistoryDisplay(String(format: "%.15g", displayValue!))
            if let result = brain.pushOperand(operand) {
                displayValue = result
            } else {
                displayValue = 0
                appendLineToHistoryDisplay("ERROR")
            }
        }

        userIsInTheMiddleOfEntering = false
    }

    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfEntering {
            if sender.currentTitle! == "+/−" {
                if String(prefix(display.text!.characters, 1)) == "-" {
                    display.text! = String(dropFirst(display.text!.characters))
                } else {
                    display.text! = "-" + display.text!
                }
                return
            }
            enter()
        }

        if let operation = sender.currentTitle {
            appendLineToHistoryDisplay(operation)
            if let result = brain.performOperation(operation) {
                displayValue = result
                appendLineToHistoryDisplay("=" + display.text!)
            } else {
                displayValue = 0
                appendLineToHistoryDisplay("ERROR")
            }
        }
    }
    
    var displayValue: Double? {
        get {
            if let number = NSNumberFormatter().numberFromString(display.text!) {
                return number.doubleValue
            } else {
                return nil
            }
        }
        set(newValue) {
            if let doubleValue = newValue {
                // using %.g formatting avoids trailing zeros (e.g., 0.0)
                display.text! = String(format: "%.15g", doubleValue)
            } else {
                display.text! = "0" // should it clear the stack?
            }
            userIsInTheMiddleOfEntering = false // may be unnecessary for now
        }
    }
    
    @IBAction func clear() {
        displayValue = 0
        historyDisplay.text! = ""
        // TODO
//        operandStack.removeAll()
    }
    
    @IBOutlet weak var historyDisplay: UITextView!
    
    private func appendLineToHistoryDisplay(line: String) {
        historyDisplay.scrollEnabled = false
        historyDisplay.text! = historyDisplay.text! + "\n" + line
        historyDisplay.scrollEnabled = true
        historyDisplay.scrollRangeToVisible(NSMakeRange(historyDisplay.text!.characters.count, 0))
    }
    
    @IBAction func backspace() {
        if display.text!.characters.count > 1 {
            display.text! = String(dropLast(display.text!.characters))
            if display.text! == "-" {
                displayValue = 0
            }
        } else {
            displayValue = 0
        }
    }
}

