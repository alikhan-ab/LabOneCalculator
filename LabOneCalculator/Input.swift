//
//  Input.swift
//  LabOneCalculator
//
//  Created by Alikhan Abutalipov on 12/22/20.
//

import Foundation
struct Input: CustomStringConvertible {
    
    static let zero: Input = Input()
    
    private var stringSign: String {
        return isNegative ? "-" : ""
    }
    
    private var stringInteger = "0"
    private var stringNonInteger: String?
    private(set) var isDecimalMode = false
    private var isNegative = false
    
    private var currentDouble: Double?
    
    internal init(stringInteger: String = "0", stringNonInteger: String? = nil, isDecimalMode: Bool = false, isNegative: Bool = false, currentDouble: Double? = nil) {
        self.stringInteger = stringInteger
        self.stringNonInteger = stringNonInteger
        self.isDecimalMode = isDecimalMode
        self.isNegative = isNegative
        self.currentDouble = currentDouble
    }
    
    
    init(currentDouble: Double) {
        self.init()
        self.currentDouble = currentDouble
    }
    
    
    /// Counts how many usable digits are in the input
    func countDigits() -> Int {
        let integerCount = stringInteger.count
        let nonIntegerCount = stringNonInteger?.count ?? 0
    
        return integerCount + nonIntegerCount
    }
    
    
    /// Appends an intiger to the end of the integer part of the Input
    /// - parameters:
    ///     - integer: integer to add to the integer part of the Input
    mutating func append(integer: Int) {
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
        stringNonInteger = (stringNonInteger ?? "") + String(nonInteger)
    }
    
    mutating func negate() {
        isNegative = !isNegative
        currentDouble?.negate()
    }
    
    mutating func enterDecimalMode() {
        isDecimalMode = true
    }
    
//    mutating func punchInDouble() {
//        let integer = Int(stringInteger)!
//        let nonInteger = Int(stringNonInteger ?? "0" )!
//
//        currentDouble = getCurrentDouble()
//    }
    
    
    // MARK: - Arithmetical Operations
    
    func add(input: Input) -> Input? {
        
        guard let currentDouble = getCurrentDouble() else { return Input(currentDouble: .nan)}
        guard let inputDouble = input.getCurrentDouble() else { return Input(currentDouble: .nan)}
        
        return Input(currentDouble: currentDouble + inputDouble)
    }
    
    func subtract(input: Input) -> Input? {
        
        guard let currentDouble = getCurrentDouble() else { return Input(currentDouble: .nan)}
        guard let inputDouble = input.getCurrentDouble() else { return Input(currentDouble: .nan)}
        
        return Input(currentDouble: currentDouble - inputDouble)
    }
    
    func multiply(by input: Input) -> Input? {
        guard let currentDouble = getCurrentDouble() else { return Input(currentDouble: .nan)}
        guard let inputDouble = input.getCurrentDouble() else { return Input(currentDouble: .nan)}
        
        return Input(currentDouble: currentDouble * inputDouble)
    }
    
    func divide(by input: Input) -> Input? {
        guard let currentDouble = getCurrentDouble() else { return Input(currentDouble: .nan)}
        guard let inputDouble = input.getCurrentDouble() else { return Input(currentDouble: .nan)}
        
        return Input(currentDouble: currentDouble / inputDouble)
    }
    
    private func getCurrentDouble() -> Double? {
        if currentDouble != nil {
            return currentDouble
        } else {
            return Double(stringSign+stringInteger + "." + (stringNonInteger ?? "0"))
        }
    }
    
    // MARK: -
    
    var description: String {
        if currentDouble != nil {
            return getDescriptionFromDouble()
        } else {
            return getDescriptionFromString()
        }
    }
    
    private func getDescriptionFromDouble() -> String {
        guard let currentDouble = currentDouble else { return "Error" }
        
        let numberForamtter = NumberFormatter()
        numberForamtter.locale = .current
        
        if abs(currentDouble) > 999_999_999  || abs(currentDouble) < 0.000_000_01 {
            numberForamtter.numberStyle = .scientific
        } else {
            numberForamtter.numberStyle = .decimal
        }
    
        numberForamtter.maximumSignificantDigits = 9
        return numberForamtter.string(for: currentDouble) ?? "Error"
    }
    
    
    private func getDescriptionFromString() -> String {
        var result = ""
        if isNegative {
            result.append("-")
        }
        result.append(stringInteger.group())
        
        if isDecimalMode {
            result.append(",")
            result.append(stringNonInteger ?? "")
        }
        return result
    }
}

extension String
{
    func group(by groupSize:Int=3, separator:String=" ") -> String
    {
        if self.count <= groupSize   { return self }
        
        let splitSize = count - groupSize
        let splitIndex = index(startIndex, offsetBy: splitSize)
        
        return String(self[..<splitIndex]).group()
            + separator
            + String(self[splitIndex...])
    }
}
