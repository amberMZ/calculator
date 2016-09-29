//
//  ViewController.swift
//  calculator
//
//  Created by Mingyu Zhang on 9/1/16.
//  Copyright (c) 2016 Mingyu Zhang. All rights reserved.
//

import UIKit


extension Double {
    var isInteger: Bool {return rint(self) == self}
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateDisplay(displayValue: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func numberPressed(_ sender: CalculatorButton) {
        
        resetHighlights()
        continousOperation = false
        
        if finalOperation {
            clear()
            finalOperation = false
        }
        
        let value = Double(sender.calButtonValue)
        
        if usingLeftOperand
        {
            let negative : Bool = leftOperand < 0 || isNegative
            
            if (fractionalIndex != 0)
            {
                leftOperand = leftOperand + value  * pow(10, -1 * fractionalIndex) * (negative ? -1 : 1)
                fractionalIndex += 1
                updateDisplay(displayValue: leftOperand)
            }
            else
            {
                leftOperand = leftOperand * 10 + value * (negative ? -1 : 1)
                updateDisplay(displayValue: leftOperand)
            }

        }
        else
        {
            let negative : Bool = rightOperand < 0 || isNegative

            if (fractionalIndex != 0)
            {
                rightOperand = rightOperand + value  * pow(10, -1 * fractionalIndex) * (negative ? -1 : 1)
                fractionalIndex += 1
                updateDisplay(displayValue: rightOperand)
            }
            else
            {
                rightOperand = rightOperand * 10 + value * (negative ? -1 : 1)
                updateDisplay(displayValue: rightOperand)
            }
        }
        
    }
    
    @IBAction func operationPressed(_ sender: CalculatorButton) {
        
        if sender._buttonValue == CalculatorButton.CalButtonValue.clear {
            resetHighlights()
            clear()
            return
        }
        
        if sender._buttonValue == CalculatorButton.CalButtonValue.equal {
            resetHighlights()
            if cachedRightOperand != 0 {
                rightOperand = cachedRightOperand
            } else {
                cachedRightOperand = rightOperand
            }
            
            if continousOperation {
                rightOperand = leftOperand
            }
            
            calculate()
            usingLeftOperand = true
            finalOperation = true
            return
        }

        cachedRightOperand = 0
        
        if sender._buttonValue == CalculatorButton.CalButtonValue.negative {
            isNegative = !isNegative
            if usingLeftOperand {
                leftOperand *= -1
                updateDisplay(displayValue: leftOperand)
            } else {
                rightOperand *= -1
                updateDisplay(displayValue: rightOperand)
            }
            return
        }
        
        if sender._buttonValue == CalculatorButton.CalButtonValue.percent {
            if usingLeftOperand {
                leftOperand /= 100
                updateDisplay(displayValue: leftOperand)
            } else {
                rightOperand /= 100
                updateDisplay(displayValue: rightOperand)
            }
            
            finalOperation = true
            return
        }
        
        if sender._buttonValue == CalculatorButton.CalButtonValue.dot {
            if fractionalIndex != 0 {
                return
            }

            fractionalIndex = 1
            if usingLeftOperand {
                updateDisplay(displayValue: leftOperand)
            } else {
                updateDisplay(displayValue: rightOperand)
            }
            return
        }
        
        resetHighlights()
        sender.highlight()
        
        if continousOperation && sender._buttonValue.IsSecondaryOperator() && !lastOperation.IsSecondaryOperator() {
            if sender._buttonValue == CalculatorButton.CalButtonValue.minus {
                secondarySignNegativeB = true
            }
            return
        }
        
        if continousOperation && !sender._buttonValue.IsSecondaryOperator() {
            lastOperation = sender._buttonValue
            return
        }
        
        if sender._buttonValue.IsBasicOperator() {
            continousOperation = true
        }
        
        
        if !sender._buttonValue.IsSecondaryOperator() {
            if !usingLeftOperand && lastOperation.IsSecondaryOperator() {
                memory = leftOperand
                leftOperand = rightOperand
                rightOperand = 0
                usingLeftOperand = true
                
                if lastOperation == CalculatorButton.CalButtonValue.minus {
                    secondarySignNegativeB = true
                }
                
                updateDisplay(displayValue: leftOperand)
            }
        }
        
        
        if !usingLeftOperand
        {
            calculate()
        }
        
        fractionalIndex = 0
        usingLeftOperand = false
        finalOperation = false
        isNegative = false
        lastOperation = sender._buttonValue
        
    }
    
    @IBOutlet weak var numberDisplayLabel: UILabel!
    
    
    var leftOperand : Double = 0
    var rightOperand : Double = 0
    var cachedRightOperand : Double = 0
    var isNegative : Bool = false
    var usingLeftOperand : Bool = true
    var lastOperation : CalculatorButton.CalButtonValue = CalculatorButton.CalButtonValue.undefined
    var fractionalIndex : Double = 0
    var finalOperation : Bool = false
    var continousOperation : Bool = false
    
    func updateDisplay(displayValue: Double) {
        
        if displayValue.isInteger {
            numberDisplayLabel.text! = "\(Int(displayValue))"
            if (fractionalIndex != 0)
            {
                numberDisplayLabel.text! += "."
            }
        } else {
            numberDisplayLabel.text! = "\(displayValue)"
        }
    }
    
    
    var memory : Double = 0
    var secondarySignNegativeB = false
    
    func calculate() {
        
        switch lastOperation {
        case CalculatorButton.CalButtonValue.add:
            leftOperand += rightOperand
            rightOperand = 0
            updateDisplay(displayValue: leftOperand)
            
        case CalculatorButton.CalButtonValue.minus:
            leftOperand -= rightOperand
            rightOperand = 0
            updateDisplay(displayValue: leftOperand)
            
        case CalculatorButton.CalButtonValue.multiply:
            leftOperand = leftOperand * rightOperand * (secondarySignNegativeB ? -1 : 1) + memory
            memory = 0
            rightOperand = 0
            secondarySignNegativeB = false
            updateDisplay(displayValue: leftOperand)
            
        case CalculatorButton.CalButtonValue.divide:
            leftOperand = leftOperand / rightOperand * (secondarySignNegativeB ? -1 : 1) + memory
            memory = 0
            rightOperand = 0
            secondarySignNegativeB = false
            updateDisplay(displayValue: leftOperand)
            
        default:
            break
        }
    }
    
    func clear()
    {
        lastOperation = CalculatorButton.CalButtonValue.undefined
        fractionalIndex = 0
        usingLeftOperand = true
        memory = 0
        leftOperand = 0
        rightOperand = 0
        cachedRightOperand = 0
        isNegative = false
        secondarySignNegativeB = false
        continousOperation = false
        finalOperation = false
        updateDisplay(displayValue: 0)
    }
    
    func resetHighlights() {
        let buttons = self.view.subviews.filter{$0 is CalculatorButton} as! [CalculatorButton]
        for button : CalculatorButton in buttons {
            button.resetHighlight()
        }
    }
}

