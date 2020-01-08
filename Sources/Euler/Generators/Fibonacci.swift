//
//  Fibonacci.swift
//  
//
//  Created by Arthur Guiot on 2020-01-07.
//

import Foundation

/// An Iterator for the Fibonacci sequence
///
/// In mathematics, the Fibonacci numbers, commonly denoted Fn form a sequence, called the Fibonacci sequence, such that each number is the sum of the two preceding ones, starting from 0 and 1.
///
/// Since the sequence is infinite, the iterator will always return a `BigInt`.
///
public struct Fibonacci: IteratorProtocol, Sequence {
    /// F_n-2, by default, its value is -1 (for including the first 1, check the `next()` function's code to understand why)
    var prec = BigInt(-1)
    /// F_n-1, by default, its value is 1
    var curr = BigInt(1)
    
    /// Creates a Fibonacci `IteratorProtocol` / `Sequence`
    public init() {}
    
    /// Return the current number in the Fibonacci sequence.
    /// It gives F_n=F_n-1 + F_n-2
    ///
    mutating public func next() -> BigInt? {
        if prec == -1 {
            prec = 0
            return curr
        }
        let past = prec
        prec = curr
        curr = prec + past
        
        return curr
    }
    /// Makes Fibonacci conforming to the `Sequence` protocol
    public func makeIterator() -> Fibonacci {
        return self
    }
}
