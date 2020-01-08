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
    
    /// Return the next prime number
    mutating public func next() -> BigInt? {
        n += 1
        while !n.isPrime {
            n += 1
        }
        return n
    }
}
