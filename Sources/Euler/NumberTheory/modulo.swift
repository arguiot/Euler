//
//  modulo.swift
//  
//
//  Created by Arthur Guiot on 2019-12-07.
//

import Foundation

/// Quick exponentiation/modulo algorithm
/// FIXME: for security, this should use the constant-time Montgomery algorithm to thwart timing attacks
///
/// - Parameters:
///   - b: base
///   - p: power
///   - m: modulus
/// - Returns: pow(b, p) % m
public func mod_exp(_ b: BigInt, _ p: BigInt, _ m: BigInt) -> BigInt {
    precondition(m != 0, "modulus needs to be non-zero")
    precondition(p >= 0, "exponent needs to be non-negative")
//    var b = b
//    var e = p
//    var result = BigInt(1)
//    if 1 & e != 0 {
//        result = b
//    }
//    while e != 0 {
//        e >>= 1
//        b = (b * b) % m
//        if e & 1 != 0 {
//            result = (result * b) % m
//        }
//    }
//    return result
    var base = b % m
    var exponent = p
    var result = BigInt(1)
    while exponent > 0 {
        if exponent.limbs[0] % 2 != 0 {
            result = result * base % m
        }
        exponent.limbs.shiftDown(1)
        base *= base
        base %= m
    }
    return result
}

/// Non-negative modulo operation
///
/// - Parameters:
///   - a: left hand side of the module operation
///   - m: modulus
/// - Returns: r := a % b such that 0 <= r < abs(m)
public func nnmod(_ a: BigInt, _ m: BigInt) -> BigInt {
    let r = a % m
    guard r.isNegative() else { return r }
    let p = m.isNegative() ? r - m : r + m
    return p
}

/// Convenience function combinding addition and non-negative modulo operations
///
/// - Parameters:
///   - a: left hand side of the modulo addition
///   - b: right hand side of the modulo addition
///   - m: modulus
/// - Returns: nnmod(a + b, m)
public func mod_add(_ a: BigInt, _ b: BigInt, _ m: BigInt) -> BigInt {
    return nnmod(a + b, m)
}

extension BigDouble {
    /// Simple modulo operation on `BigDouble` using Donald Knuth's algorithm
    /// - Parameters:
    ///   - rhs: The right hand side
    ///   - lhs: The left hand side
    static func %(lhs: BigDouble, rhs: BigDouble) -> BigDouble {
        if let lhs = lhs.asDouble(), let rhs = rhs.asDouble() {
            return BigDouble(lhs.truncatingRemainder(dividingBy: rhs))(1)
        }
        let div = lhs / rhs
        let int = floor(div)
        let floatRest = rhs * int
        let rest = lhs - floatRest
        return rest
    }
}
