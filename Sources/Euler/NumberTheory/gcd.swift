//
//  gcd.swift
//  
//
//  Created by Arthur Guiot on 2019-12-07.
//

import Foundation

internal func euclid(_ a: Limbs, _ b: Limbs) -> Limbs {
    var (a, b) = (a, b)
    while !b.equalTo(0) {
        (a, b) = (b, a.divMod(b).remainder)
    }
    return a
}

internal func gcdFactors(_ lhs: Limbs, rhs: Limbs) -> (ax: Limbs, bx: Limbs) {
    let gcd = steinGcd(lhs, rhs)
    return (lhs.divMod(gcd).quotient, rhs.divMod(gcd).quotient)
}

/// The binary GCD algorithm, also known as Stein's algorithm, is an algorithm that computes the greatest common divisor of two nonnegative integers. Stein's algorithm uses simpler arithmetic operations than the conventional Euclidean algorithm; it replaces division with arithmetic shifts, comparisons, and subtraction.
/// - Parameters:
///   - a: Any limbs Number
///   - b: Any limbs Numbers
/// - Returns: GCD of a and b as a Limbs
///
public func steinGcd(_ a: Limbs, _ b: Limbs) -> Limbs {
    if a == [0] { return b }
    if b == [0] { return a }
    
    // Trailing zeros
    var (za, zb) = (0, 0)
    
    while !a.getBit(at: za) { za += 1 }
    while !b.getBit(at: zb) { zb += 1 }
    
    let k = min(za, zb)
    
    var (a, b) = (a, b)
    a.shiftDown(za)
    b.shiftDown(k)
    
    while b != [0] {
        zb = 0
        while !b.getBit(at: zb) { zb += 1 }
        b.shiftDown(zb)
        
        if b.lessThan(a) { (a, b) = (b, a) }
        // At this point, b >= a
        b.difference(a)
    }
    
    return a.shiftingUp(k)
}

/// greatest common divisor.
/// - Parameters:
///   - a: BigInt
///   - b: BigInt
public func gcd(_ a: BigInt, _ b: BigInt) -> BigInt {
    let limbRes = steinGcd(a.limbs, b.limbs)
    return BigInt(sign: a.sign && !limbRes.equalTo(0), limbs: limbRes)
}

/// Do not use this, extremely slow. Only for testing purposes.
/// - Parameters:
///   - a: Any  BigInt
///   - b: Any BigInt
/// - Returns: GCD of a and b as a BigInt
public func gcdEuclid(_ a: BigInt, _ b: BigInt) -> BigInt {
    let limbRes = euclid(a.limbs, b.limbs)
    return BigInt(sign: a.sign && !limbRes.equalTo(0), limbs: limbRes)
}

internal func lcmPositive(_ a: Limbs, _ b: Limbs) -> Limbs {
    return a.divMod(steinGcd(a, b)).quotient.multiplyingBy(b)
}

/// lowest (or least) common multiple.
/// - Parameters:
///   - a: BigInt
///   - b: BigInt
public func lcm(_ a:BigInt, _ b:BigInt) -> BigInt {
    return BigInt(limbs: lcmPositive(a.limbs, b.limbs))
}

/// Returns the [multiplicative inverse of this integer in modulo `modulus` arithmetic][inverse],
/// or `nil` if there is no such number.
///
/// [inverse]: https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm#Modular_integers
///
/// - Returns: If `gcd(self, modulus) == 1`, the value returned is an integer `a < modulus` such that `(a * self) % modulus == 1`. If `self` and `modulus` aren't coprime, the return value is `nil`.
/// - Requires: modulus > 1
/// - Complexity: O(count^3)
public func inverse(_ base: BigInt, _ modulus: BigInt) -> BigInt? {
    precondition(modulus > 1)
    var t1 = BigInt(0)
    var t2 = BigInt(1)
    var r1 = modulus
    var r2 = base
    while !r2.isZero() {
        let quotient = r1 / r2
        (t1, t2) = (t2, t1 - quotient * t2)
        (r1, r2) = (r2, r1 - quotient * r2)
    }
    if r1 > 1 { return nil }
    if t1.sign == true { return modulus - t1 }
    return t1
}
