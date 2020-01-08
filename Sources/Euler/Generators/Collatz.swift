//
//  Collatz.swift
//  
//
//  Created by Arthur Guiot on 2020-01-07.
//

import Foundation


/// An Iterator for the Collatz conjecture
///
/// The Collatz conjecture is a conjecture in mathematics that concerns a sequence defined as follows: start with any positive integer n. Then each term is obtained from the previous term as follows: if the previous term is even, the next term is one half the previous term. If the previous term is odd, the next term is 3 times the previous term plus 1. The conjecture is that no matter what value of n, the sequence will always reach 1.
///
/// After it reaches 1, the iterator will return `nil`
///
public struct Collatz: IteratorProtocol, Sequence {
    /// Current value
    var n: BigInt
    
    /// Initialize the collatz sequence
    /// - Parameter n: Any `BigInt`
    public init(_ n: BigInt) {
        self.n = n
    }
    
    /// Next value
    mutating public func next() -> BigInt? {
        guard n != 1 else { return nil }
        if n % 2 == 0 {
            n = n / 2
        } else {
            n = 3 * n + 1
        }
        return n
    }
    
    /// Makes Collatz conforming to the `Sequence` protocol
    public func makeIterator() -> Collatz {
        return self
    }
}
