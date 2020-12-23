//
//  Input.swift
//  LabOneCalculator
//
//  Created by Alikhan Abutalipov on 12/22/20.
//

import Foundation
struct Input: CustomStringConvertible {
    
    static let zero: Input = Input()
    
    
    private(set) var decimal = Decimal()
    
    private var integer: Int = 0
    private var nonInteger: Int? {
        didSet {
            if nonInteger == nil {
                isDecimal = false
            } else {
                isDecimal = true
            }
        }
    }
    
    private var isDecimal: Bool = false
    var isDecimalMode = false
    

    
    /// Counts how many usable digits are in the input
    func countDigits() -> Int {
        var digitCount = String(integer).count
        if let nonInteger = nonInteger {
            digitCount += String(nonInteger).count
        }
        if integer < 0 {
            digitCount -= 1
        }
    
        return digitCount
    }
    
    
    /// Appends an intiger to the end of the integer part of the Input
    /// - parameters:
    ///     - integer: integer to add to the integer part of the Input
    mutating func append(integer: Int) {
        decimal = decimal * 10 + Decimal(integer)
        
        self.integer = self.integer * 10 + integer
    }
    
    /// Appends an intiger to the end of the non-integer part of the Input
    /// - parameters:
    ///     - nonInteger: integer to add to the non-integer part of the Input
    mutating func append(nonInteger: Int) {
        
        let exponent = decimal.exponent
        let toAdd = Decimal(sign: decimal.sign, exponent: exponent - 1, significand: Decimal(nonInteger))
        decimal += toAdd
        print(decimal)
        
        self.nonInteger = (self.nonInteger ?? 0) * 10 + nonInteger
    }
    
    mutating func negate() {
        integer = -integer
        decimal.negate()
    }
    
    
    // MARK: - Arithmetical Operations
    
    func add(input: Input) -> Input {
        return decimal + input.decimal
    }
    
    
    
    
    
    // MARK: -
    
    var description: String {
        
        
        // TODO: - Check if the result is longer than 9 digits
        
        
        var stringInput = String(integer)
        
        if isDecimalMode {
            stringInput += ","
        }
        
        if let nonInteger = nonInteger {
            stringInput += "\(nonInteger)"
        }
        
        return stringInput
    }
}
