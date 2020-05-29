//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-01-30.
//

import Foundation

/// Returns the natural logarithm of a number. Natural logarithms are based on the constant e (2.71828182845904)
///
/// LN is the inverse of the EXP function.
/// - Parameters:
///   - n: The positive real number for which you want the natural logarithm.
///   - precision: The precision you want to use (number of cycles). Higher precision means better result, but slower compute time
public func ln(_ n: BigDouble, precision: Int = 15) -> BigDouble {
    if let a = n.asDouble() {
        return BigDouble(log(a))
    }
    let numerator = BigInt(limbs: n.numerator)
    let denominator = BigInt(limbs: n.denominator)
    
    return ln(numerator) - ln(denominator)
}

public func ln(_ n: BigInt) -> BigDouble {
    let s = n.asString(radix: 10)
    let p = s.count
    guard let d = Double("0.\(s)") else { return 0 }
    let lg = Double(p) * log(Double(10)) + log(d)
    return BigDouble(lg)
}
