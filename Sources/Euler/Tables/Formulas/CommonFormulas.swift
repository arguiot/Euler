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
    
    // MARK: TODO: AGGREGATE + ARABIC
    
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
    ///     - mode: Either 0 or 1 (0 by default, flooring). It will choose between flooring or ceiling the number if it's negative.
    func CEILING(_ number: BigDouble, significance: BigDouble = 1, mode: Int = 0) -> BigDouble {
        if number.isPositive() {
            return ceil(number / significance) * significance
        }
        if mode == 0 {
            return -1 * floor(abs(number) / significance) * significance
        }
        return -1 * ceil(abs(number) / significance) * significance
    }
    
    /// Returns the number of combinations for a given number of items. Use COMBIN to determine the total possible number of groups for a given number of items.
    ///
    /// It uses combinations with repetitions: `n! / (k! * (n - k)!)`
    /// - Parameters:
    ///   - n: The number of items.
    ///   - k: The number of items in each combination.
    func COMBIN(_ n: BigInt, k: BigInt) -> BigInt {
        guard let ni = n.asInt() else { return .zero }
        guard let ki = k.asInt() else { return .zero }
        return combinations(ni, ki)
    }
    
    /// Returns the number of combinations (with repetitions) for a given number of items.
    ///
    /// It uses combinations with repetitions: `(n + k - 1)! / (k! * (n - 1)!)`
    /// - Parameters:
    ///   - n: The number of items.
    ///   - k: The number of items in each combination.
    func COMBINA(_ n: BigInt, k: BigInt) -> BigInt {
        guard let ni = n.asInt() else { return .zero }
        guard let ki = k.asInt() else { return .zero }
        return combinationsWithRepetitions(ni, ki)
    }
    
    /// Cosinus of a number.
    /// - Parameter number: Any `BigDouble` less than 2pi
    func COS(_ number: BigNumber) -> BigNumber {
        let mod = number % (2 * pi)
        let tentimes = mod * 10
        let intPart = tentimes.rounded()
        let doubleExpressible = BigDouble(intPart) / BigDouble(10)
        let double = Double(doubleExpressible.description) ?? 0.0
        return BigDouble(cos(double))
    }
    
    /// Hyperbolic Cosinus of a number.
    /// - Parameter number: Any `BigDouble`
    func COSH(_ number: BigNumber) -> BigNumber {
        let tentimes = number * 10
        let intPart = tentimes.rounded()
        let doubleExpressible = BigDouble(intPart) / BigDouble(10)
        let double = Double(doubleExpressible.description) ?? 0.0
        return BigDouble(cosh(double))
    }
    
    /// Cotangent of a number.
    /// - Parameter number: Any `BigDouble`
    func COT(_ number: BigNumber) -> BigNumber {
        let tentimes = number * 10
        let intPart = tentimes.rounded()
        let doubleExpressible = BigDouble(intPart) / BigDouble(10)
        let double = Double(doubleExpressible.description) ?? 0.0
        return BigDouble(1) / BigDouble(tan(double))
    }
    
    /// Hyperbolic Cotangent of a number.
    /// - Parameter number: Any `BigDouble`
    func COTH(_ number: BigNumber) -> BigNumber {
        let e2 = e ** (2 * number)
        
        return (e2 + 1) / (e2 - 1)
    }
    /// Cosecant of a number.
    /// - Parameter number: Any `BigDouble`
    func CSC(_ number: BigNumber) -> BigNumber {
        let tentimes = number * 10
        let intPart = tentimes.rounded()
        let doubleExpressible = BigDouble(intPart) / BigDouble(10)
        let double = Double(doubleExpressible.description) ?? 0.0
        return BigDouble(1) / BigDouble(sin(double))
    }

    /// Hyperbolic Cosecant of a number.
    /// - Parameter number: Any `BigDouble`
    func CSCH(_ number: BigNumber) -> BigNumber {
        let e1 = e ** number
        let e2 = e ** (-number)
        return BigDouble(2) / (e1 - e2)
    }
    
    /// Converts a text representation of a number in a given base into a decimal number.
    /// - Parameters:
    ///   - str: Required
    ///   - radix: Radix must be an integer.
    func DECIMAL(_ str: String, _ radix: Int) -> BigNumber {
        return BigDouble(str, radix: radix) ?? 0
    }
    
    /// Converts radians into degrees.
    /// - Parameter rad: The angle in radians that you want to convert.
    func DEGREES(_ rad: BigDouble) -> BigNumber {
        let abs = rad * 180 / pi
        let mod = abs % 360
        return mod
    }
    
    /// Returns number rounded up to the nearest even integer.
    ///
    /// You can use this function for processing items that come in twos. For example, a packing crate accepts rows of one or two items. The crate is full when the number of items, rounded up to the nearest two, matches the crate's capacity.
    /// - Parameter number: The value to round.
    func EVEN(_ number: BigDouble) -> BigInt {
        return CEILING(number, significance: -2, mode: 1).rounded()
    }
    
    /// Returns e raised to the power of number.
    /// The constant e equals 2.71828182845904, the base of the natural logarithm.
    /// - Parameter number: The exponent applied to the base e.
    func EXP(_ number: BigDouble) -> BigDouble {
        return e ** number
    }
    
    /// Returns the factorial of a number. The factorial of a number is equal to `1*2*3*...*` number.
    ///
    ///
    /// - Parameter int: The nonnegative number for which you want the factorial. If number is not an integer, it is truncated.
    func FACT(_ int: BigInt) -> BigInt {
        return factorial(int)
    }
}
