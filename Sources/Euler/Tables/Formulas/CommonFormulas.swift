//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-01-23.
//

import Foundation

public extension Tables {
    /// Absolute value of a number
    /// - Parameter number: A `BigDouble`
    func ABS(_ number: BigNumber) -> BigNumber {
        return abs(number)
    }
    
    /// Arc-Cosinus of a number.
    /// - Parameter number: Any `BigDouble` less than 2pi
    func ACOS(_ number: BigNumber) -> BigNumber {
        let mod = number % (2 * pi)
        let tentimes = mod * 10
        let intPart = tentimes.rounded()
        let doubleExpressible = BigDouble(intPart) / BigDouble(10)
        let double = Double(doubleExpressible.description) ?? 0.0
        return BigDouble(acos(double))
    }
    /// Hyperbolic Arc-Cosinus of a number.
    /// - Parameter number: Any `BigDouble`
    func ACOSH(_ number: BigNumber) -> BigNumber {
        let tentimes = number * 10
        let intPart = tentimes.rounded()
        let doubleExpressible = BigDouble(intPart) / BigDouble(10)
        let double = Double(doubleExpressible.description) ?? 0.0
        return BigDouble(acosh(double))
    }
    
    /// Arc-Cotangent of a number.
    /// - Parameter number: Any `BigDouble` less than 2pi
    func ACOT(_ number: BigNumber) -> BigNumber {
        let mod = number % (2 * pi)
        let tentimes = mod * 10
        let intPart = tentimes.rounded()
        let doubleExpressible = BigDouble(intPart) / BigDouble(10)
        let double = Double(doubleExpressible.description) ?? 0.0
        return BigDouble(atan(1 / double))
    }
    
    /// Hyperbolic Arc-Cotangent of a number.
    /// - Parameter number: Any `BigDouble`
    func ACOTH(_ number: BigNumber) -> BigNumber {
        let tentimes = number * 10
        let intPart = tentimes.rounded()
        let doubleExpressible = BigDouble(intPart) / BigDouble(10)
        let double = Double(doubleExpressible.description) ?? 0.0
        return BigDouble(0.5 * log(double + 1) / (double - 1))
    }
    
    /// Arc-Sinus of a number.
    /// - Parameter number: Any `BigDouble` less than 2pi
    func ASIN(_ number: BigNumber) -> BigNumber {
        let mod = number % (2 * pi)
        let tentimes = mod * 10
        let intPart = tentimes.rounded()
        let doubleExpressible = BigDouble(intPart) / BigDouble(10)
        let double = Double(doubleExpressible.description) ?? 0.0
        return BigDouble(asin(double))
    }
    
    /// Hyperbolic Arc-Sinus of a number.
    /// - Parameter number: Any `BigDouble`
    func ASINH(_ number: BigNumber) -> BigNumber {
        let tentimes = number * 10
        let intPart = tentimes.rounded()
        let doubleExpressible = BigDouble(intPart) / BigDouble(10)
        let double = Double(doubleExpressible.description) ?? 0.0
        return BigDouble(asinh(double))
    }
    /// Arc-Tangent of a number.
    /// - Parameter number: Any `BigDouble`
    func ATAN(_ number: BigNumber) -> BigNumber {
        let tentimes = number * 10
        let intPart = tentimes.rounded()
        let doubleExpressible = BigDouble(intPart) / BigDouble(10)
        let double = Double(doubleExpressible.description) ?? 0.0
        return BigDouble(atan(double))
    }
    
    /// ATAN2(Y,X) returns the four-quadrant inverse tangent (tan-1) of Y and X, which must be real. The atan2 function follows the convention that atan2(x,x) returns 0 when x is mathematically zero (either 0 or -0).
    /// - Parameters:
    ///   - n1: X coordinate
    ///   - n2: Y coordinate
    func ATAN2(_ n1: BigNumber, _ n2: BigNumber) -> BigNumber {
        let tentimes1 = n1 * 10
        let ip1 = tentimes1.rounded()
        let de1 = BigDouble(ip1) / BigDouble(10)
        let d1 = Double(de1.description) ?? 0.0
        let tentimes2 = n2 * 10
        let ip2 = tentimes2.rounded()
        let de2 = BigDouble(ip2) / BigDouble(10)
        let d2 = Double(de2.description) ?? 0.0
        
        return BigDouble(atan2(d1, d2))
    }
    
    /// Hyperbolic Arc-Tangent of a number.
    /// - Parameter number: Any `BigDouble`
    func ATANH(_ number: BigNumber) -> BigNumber {
        let tentimes = number * 10
        let intPart = tentimes.rounded()
        let doubleExpressible = BigDouble(intPart) / BigDouble(10)
        let double = Double(doubleExpressible.description) ?? 0.0
        return BigDouble(asinh(double))
    }
    
    /// Convert number to any base
    /// - Parameters:
    ///   - number: The number you want to use
    ///   - radix: The base / radix
    func BASE(_ number: BigInt, _ radix: BigInt) -> String {
        return number.asString(radix: radix.asInt() ?? 10)
    }
    
    /// Returns number rounded up, away from zero, to the nearest multiple of significance.
    ///
    /// For example, if you want to avoid using pennies in your prices and your product is priced at $4.42, use the formula `=CEILING(4.42,0.05)` to round prices up to the nearest nickel.
    /// - Parameters:
    ///     - number: The number you want to use
    ///     - significance: The multiple to which you want to round.
    func CEILING(_ number: BigDouble, significance: BigDouble = 1) -> BigDouble {
        return ceil(number / significance) * significance
    }
}
