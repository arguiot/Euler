//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-01-23.
//

import Foundation

/// A class for developing Excel-like software / parser.
public class Tables {
    public enum TablesError: Error {
        case REF
        case NULL
        case DivisionByZero
        case Overflow
        case ParsingError
        case Arguments
    }
}
