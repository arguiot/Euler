//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-01-23.
//

import Foundation

/// A class for developing Excel-like software / parser.
public class Tables {
    /// Expression as String
    ///
    /// Example:
    /// ```
    /// =SUM(A3:A5) - MIN(A3:A5)
    /// ```
    public var expression: String?
    
    /// Initialize a Tables object in order to execute a single expression
    /// - Parameter expr: The expression you want to execute
    public init(_ expr: String) {
        self.expression = expr
    }
    /// Regular init
    public init() {}
    /// A type of error made for `Tables`
    public enum TablesError: Error {
        /// Reference error
        case REF
        /// Result is null
        case NULL
        /// Division by zero (may crash the program)
        case DivisionByZero
        /// Overflow problem
        case Overflow
        /// Parsing problem
        case ParsingError
        /// When soemthing is wrong with the given arguments
        case Arguments
    }
}
