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
    var expression: String?
    
    /// Initialize a Tables object in order to execute a single expression
    /// - Parameter expr: The expression you want to execute
    init(_ expr: String) {
        self.expression = expr
    }
    /// Regular init
    init() {}
    
    public enum TablesError: Error {
        case REF
        case NULL
        case DivisionByZero
        case Overflow
        case ParsingError
        case Arguments
    }
}
