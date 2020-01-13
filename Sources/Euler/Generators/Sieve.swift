//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-01-07.
//

import Foundation

/// A generator for finding prime numbers
///
/// A prime sieve or prime number sieve is a fast type of algorithm for finding primes. It does so by iterating over the natural integers, and returning every number that is indeed prime.
///
public struct Sieve: IteratorProtocol {
    /// The current Prime number
    var n = BigInt(1)
    
    /// Creates a Sieve `IteratorProtocol` / `Sequence`
    public init() {}
    
    /// Return the next prime number
    mutating public func next() -> BigInt? {
        n += 1
        while !n.isPrime {
            n += 1
        }
        return n
    }
    /// Makes Sieve conforming to the `Sequence` protocol
    public func makeIterator() -> Sieve {
        return self
    }
    
    /// Gives the nth prime
    /// - Parameter n: The nth prime in the list
    public static func nthPrime(n: BigInt) -> BigInt? {
        guard n >= 1 else { return nil }
        var iterator = Sieve()
        var prevPrime = iterator.next()
        var i = 1
        while i < n {
            prevPrime = iterator.next()
            i += 1
        }
        return prevPrime
    }
}
