//
//  Input.swift
//  LabOneCalculator
//
//  Created by Alikhan Abutalipov on 12/22/20.
//

import Foundation
struct Input: CustomStringConvertible {
    
    static let zero: Input = Input()
    
    
//    var decimal: Decimal {
//
//        let exponent = nonInteger
//
//        return Decimal()
//    }
    
    
    private var stringSign: String {
        return isNegative ? "-" : ""
    }
    
    private var stringInteger = "0"
    private var stringNonInteger: String?
    
    private var integer: Int = 0
    private var nonInteger: Int?
    private(set) var isDecimalMode = false
    private var isNegative = false
    
    
    init() {}
    
    init(decimal: Decimal) {
        
        if decimal.sign == .minus {
            isNegative = true
        }
        
        let exponent = decimal.exponent
        if exponent < 0 {
            isDecimalMode = true
        }
        
        let integer = decimal
        
    }

    
    /// Counts how many usable digits are in the input
    func countDigits() -> Int {
        
        
        let integerCount = stringInteger.count
        let nonIntegerCount = stringNonInteger?.count ?? 0
        
        
        var digitCount = String(integer).count
        if let nonInteger = nonInteger {
            digitCount += String(nonInteger).count
        }
        if integer < 0 {
            digitCount -= 1
        }
    
        return integerCount + nonIntegerCount
    }
    
    
    /// Appends an intiger to the end of the integer part of the Input
    /// - parameters:
    ///     - integer: integer to add to the integer part of the Input
    mutating func append(integer: Int) {
        self.integer = self.integer * 10 + integer
        
        if stringInteger == "0" && integer != 0 {
            stringInteger = "\(integer)"
        } else if stringInteger != "0"{
            stringInteger.append(String(integer))
        }
    }
    
    /// Appends an intiger to the end of the non-integer part of the Input
    /// - parameters:
    ///     - nonInteger: integer to add to the non-integer part of the Input
    mutating func append(nonInteger: Int) {
        self.nonInteger = (self.nonInteger ?? 0) * 10 + nonInteger
        
        stringNonInteger = (stringNonInteger ?? "") + String(nonInteger)
    }
    
    mutating func negate() {
        isNegative = !isNegative
    }
    
    mutating func enterDecimalMode() {
        isDecimalMode = true
    }
    
    
    // MARK: - Arithmetical Operations
    
//    func add(input: Input) -> Input {
//        return decimal + input.decimal
//    }
    
    
    func percent() -> Input {
        
        
        
        
        
    }
    
    
    
    
    
    // MARK: -
    
    var description: String {
        
        
        // TODO: - Check if the result is longer than 9 digits
        var result = ""
        
        if isNegative {
            result.append("-")
        }
        
        result.append(stringInteger)
        
        if isDecimalMode {
            result.append(",")
            result.append(stringNonInteger ?? "")
        }
        
        
        return result
    }
}


extension String {
    
    func countWithoutTrailingZeros() -> Int {
        
        var tempString = self
        
        while true {
            if tempString.last == "0" {
                tempString.dropLast()
            }
        }
    }
}
