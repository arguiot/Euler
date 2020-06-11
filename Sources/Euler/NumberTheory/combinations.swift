//
//  combinations.swift
//  
//
//  Created by Arthur Guiot on 2019-12-07.
//

import Foundation

/// Permutations: `$\frac{n!}{(n-k)!}`
///
/// Order matters, repetition allowed.
public func permutations(_ n: Int, _ k: Int) -> BigInt {
    // n! / (n-k)!
    guard n - k != 0 else { return .zero }
    return factorial(BigInt(n)) / factorial(BigInt(n - k))
}

/// Permutations with repetition: `$n^k$`
///
/// Order matters, repetition allowed.
public func permutationsWithRepitition(_ n: Int, _ k: Int) -> BigInt {
    // n ** k
    return BigInt(n) ** k
    
}

/// Combinations with repetitions: `$\frac{(n + k - 1)!}{k! * (n - 1)!}$`.
///
/// Order matters, repetition allowed.
public func combinationsWithRepetitions(_ n: Int, _ k: Int) -> BigInt {
    // (n + k - 1)! / (k! * (n - 1)!)
    guard k != 0 && n != 1 else { return .zero }
    return factorial(BigInt(n + k - 1)) / factorial(BigInt(k)) * factorial(BigInt(n - 1))
}

/// Combinations: `$\frac{n!}{k! * (n - k)!}$`.
///
/// See `combinationsWithRepitition` for the other method.
///
/// Order matters, repetition allowed.
public func combinations(_ n: Int, _ k: Int) -> BigInt {
    // n! / (k! * (n - k)!)
    guard n - k != 0 else { return .zero }
    return factorial(BigInt(n)) / factorial(BigInt(k)) * factorial(BigInt(n - k))
}
