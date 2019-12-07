//
//  combinations.swift
//  
//
//  Created by Arthur Guiot on 2019-12-07.
//

import Foundation

/// Permutations: `n! / (n-k)!`
///
/// Order matters, repetition allowed.
public func permutations(_ n: Int, _ k: Int) -> BigInt {
    // n! / (n-k)!
    return BigInt(n).factorial() / BigInt(n - k).factorial()
}

/// Permutations with repetition: `n ** k`
///
/// Order matters, repetition allowed.
public func permutationsWithRepitition(_ n: Int, _ k: Int) -> BigInt {
    // n ** k
    return BigInt(n) ** k
    
}

/// Combinations: `(n + k - 1)! / (k! * (n - 1)!)`
///
/// Order matters, repetition allowed.
public func combinations(_ n: Int, _ k: Int) -> BigInt {
    // (n + k - 1)! / (k! * (n - 1)!)
    return BigInt(n + k - 1).factorial() / (BigInt(k).factorial() * BigInt(n - 1).factorial())
}

/// Combinations with repetitions: `(n + k - 1)! / (k! * (n - 1)!)`
///
/// Order matters, repetition allowed.
public func combinationsWithRepitition(_ n: Int, _ k: Int) -> BigInt {
    // n! / (k! * (n - k)!)
    return BigInt(n).factorial() / (BigInt(k).factorial() * BigInt(n - k).factorial())
}
