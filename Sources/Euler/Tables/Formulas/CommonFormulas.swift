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
    /// - Parameter number: Any `BigDouble` less than 2pi
    func ACOSH(_ number: BigNumber) -> BigNumber {
        let mod = number % (2 * pi) // TODO: Make this for number larger than 2pi
        let tentimes = mod * 10
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
    /// - Parameter number: Any `BigDouble` less than 2pi
    func ACOTH(_ number: BigNumber) -> BigNumber {
        let mod = number % (2 * pi) // TODO: Make this for number larger than 2pi
        let tentimes = mod * 10
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
    /// - Parameter number: Any `BigDouble` less than 2pi
    func ASINH(_ number: BigNumber) -> BigNumber {
        let mod = number % (2 * pi) // TODO: Make this for number larger than 2pi
        let tentimes = mod * 10
        let intPart = tentimes.rounded()
        let doubleExpressible = BigDouble(intPart) / BigDouble(10)
        let double = Double(doubleExpressible.description) ?? 0.0
        return BigDouble(asinh(double))
    }
}
