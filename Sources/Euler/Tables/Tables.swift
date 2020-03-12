//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-01-23.
//

import Foundation

/// A class for developing Excel-like software / parser.
public class Tables {
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
