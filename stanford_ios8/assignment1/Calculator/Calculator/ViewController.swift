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
    
    @IBAction func appendDigit(sender: UIButton) {
        if userIsInTheMiddleOfEntering {
            // place the decimal check here so that the user can start entering by pressing "."
            if sender.currentTitle! == "." && display.text!.rangeOfString(".") != nil { return }
            display.text! = display.text! + sender.titleLabel!.text!
        } else {
            display.text! = sender.titleLabel!.text!
            userIsInTheMiddleOfEntering = true
        }
    }
    
    var operandStack = [Double]()
    
    @IBAction func enter() {
        operandStack.append(currentValue!)
        appendLineToHistoryDisplay(String(format: "%.15g", currentValue!))
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
        appendLineToHistoryDisplay(sender.currentTitle!)
        switch sender.titleLabel!.text! {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "π": performOperation { M_PI }
        case "+/−": performOperation { -$0 }
        default: break
        }
    }
    
    var currentValue: Double? {
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
                clear()
            }
            userIsInTheMiddleOfEntering = false // may be unnecessary for now
        }
    }
    
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            currentValue = operation(operandStack.removeLast(), operandStack.removeLast())
//            enter() // changed to the lines below to add "=" before results
            operandStack.append(currentValue!)
            appendLineToHistoryDisplay(String(format: "=%.15g", currentValue!))
        }
    }
    
    // add private to avoid exposure of possible Objective-C calling which does not support overloading
    // Swift 1.2 checks Objective-C interopablity by disabling public overloading in swift class
    // See http://stackoverflow.com/a/29670644
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            currentValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: () -> Double) {
        currentValue = operation()
        enter()
    }
    
    @IBAction func clear() {
        currentValue = 0
        historyDisplay.text! = ""
        operandStack.removeAll()
    }
    
    @IBOutlet weak var historyDisplay: UITextView!
    
    private func appendLineToHistoryDisplay(line: String) {
        // There are other methods like scrollRectToVisible to do auto scrolling but it didn't work or I didn't know how
        // Using this method every time the text view is scrolling from the top
        // The solution is to disable and enable scrolling before and after changing the text
        // http://stackoverflow.com/questions/24453108/smooth-uitextview-auto-scroll-to-bottom-of-frame-solved
        historyDisplay.scrollEnabled = false
        historyDisplay.text! = historyDisplay.text! + "\n" + line
        historyDisplay.scrollEnabled = true
        // String counting changed in Swift 2.0
        historyDisplay.scrollRangeToVisible(NSMakeRange(historyDisplay.text!.characters.count, 0))
    }
    
    @IBAction func backspace() {
        if display.text!.characters.count > 1 {
            display.text! = String(dropLast(display.text!.characters))
            if display.text! == "-" {
                currentValue = 0
            }
        } else {
            currentValue = 0
        }
    }
}

