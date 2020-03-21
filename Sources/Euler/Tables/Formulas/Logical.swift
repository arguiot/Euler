//
//  Logical.swift
//  
//
//  Created by Arthur Guiot on 2020-03-01.
//

import Foundation

public extension Tables {
    // MARK: Logical operators
    
    /// AND operator.
    ///
    /// If argument list contains a false statement, it returns false, otherwise it returns true
    func AND(_ b: Bool...) -> Bool {
        return !b.contains(false)
    }
    /// AND operator.
    ///
    /// If argument list contains a false statement, it returns false, otherwise it returns true
    func AND(_ b: [Bool]) -> Bool {
        return !b.contains(false)
    }
    
    /// Use CHOOSE to select one of up to 256 values based on the index number.
    ///
    /// For example, if value1 through value7 are the days of the week, CHOOSE returns one of the days when a number between 1 and 7 is used as i.
    /// - Parameters:
    ///   - i: Specifies which value argument is selected.
    ///   - b: 1 to 254 value arguments from which CHOOSE selects a value or an action to perform based on index.
    func CHOOSE<T>(_ i: Int, _ b: T...) throws -> T {
        guard b.count < i else { throw TablesError.Arguments }
        guard i > 0 && i < 256 else { throw TablesError.Arguments }
        return b[i]
    }
    /// Use CHOOSE to select one of up to 256 values based on the index number.
    ///
    /// For example, if value1 through value7 are the days of the week, CHOOSE returns one of the days when a number between 1 and 7 is used as i.
    /// - Parameters:
    ///   - i: Specifies which value argument is selected.
    ///   - b: 1 to 254 value arguments from which CHOOSE selects a value or an action to perform based on index.
    func CHOOSE<T>(_ i: Int, _ b: [T]) throws -> T {
        guard b.count < i else { throw TablesError.Arguments }
        guard i > 0 && i < 256 else { throw TablesError.Arguments }
        return b[i]
    }
    
    /// The IF function allows you to make a logical comparison between a value and what you expect by testing for a condition and returning a result if that condition is True or False.
    /// - Parameters:
    ///   - c: Condition
    ///   - a: Value to return if `c` is true
    ///   - b: Value to return if `c` is false
    func IF<T>(_ c: Bool, _ a: T, _ b: T) -> T {
        return c ? a : b
    }
    
    /// OR operator.
    ///
    /// If argument list contains at least one true statement, it returns true, otherwise it returns false
    func OR(_ b: Bool...) -> Bool {
        return b.contains(true)
    }
    /// OR operator.
    ///
    /// If argument list contains at least one true statement, it returns true, otherwise it returns false
    func OR(_ b: [Bool]) -> Bool {
        return b.contains(true)
    }
    
    /// The XOR function returns a logical Exclusive Or of all arguments.
    /// - Parameter b: Conditions
    func XOR(_ b: Bool...) -> Bool {
        guard b.contains(false) else { return false }
        return b.contains(true)
    }
    /// The XOR function returns a logical Exclusive Or of all arguments.
    /// - Parameter b: Conditions
    func XOR(_ b: [Bool]) -> Bool {
        guard b.contains(false) else { return false }
        return b.contains(true)
    }
}
