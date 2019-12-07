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
