//
//  CalculatorButton.swift
//  calculator
//
//  Created by Mingyu Zhang on 9/28/16.
//  Copyright © 2016 Mingyu Zhang. All rights reserved.
//

import Foundation
import UIKit

class CalculatorButton: UIButton {
    
    @IBInspectable var calButtonType : Int = 0 {
        didSet {
            _buttonType = CalButtonType(rawValue: calButtonType)!
        }
    }
    
    
    @IBInspectable var calButtonValue : Int = 0 {
        didSet {
            _buttonValue = CalButtonValue(rawValue: calButtonValue)!
        }
    }
    
    var _buttonType : CalButtonType = CalButtonType.Operation
    var _buttonValue : CalButtonValue = CalButtonValue.zero

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    enum CalButtonType: Int {
        case Operation = 0
        case Number
    }
    
    enum CalButtonValue: Int {
        case undefined = -1
        case zero = 0, one, two, three, four, five, six, seven, eight, nine
        case clear = 10, negative, percent, divide, multiply, minus, add, equal, dot
        
        func IsSecondaryOperator() -> Bool {
            switch self {
                case .divide:
                    return false
                case .multiply:
                    return false
                default:
                    return true
            }
        }
        
        func IsBasicOperator() -> Bool {
            switch self {
                case .divide:
                    return true
                case .multiply:
                    return true
                case .add:
                    return true
                case .minus:
                    return true
                case .equal:
                return true
                default:
                    return false
            }
        }
        
        func IsFunctionalOperator() -> Bool {
            switch self {
                case .clear:
                    return true
                case .negative:
                    return true
                case .percent:
                    return true
                case .dot:
                    return true
                default:
                    return false
            }
        }
    }
    
    func highlight() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.green.cgColor
    }
    
    func resetHighlight() {
        self.layer.borderWidth = 0
    }
        
}
