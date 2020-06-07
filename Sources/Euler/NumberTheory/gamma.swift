//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-01-29.
//

import Foundation

//
//
//    MARK: - BigNumber Utility Functions
//    ————————————————————————————————————————————————————————————————————————————————————————
//    ||||||||        BigNumber Utility Functions        |||||||||||||||||||||||||||||||||||||
//    ————————————————————————————————————————————————————————————————————————————————————————
//
//
//
//

fileprivate let coefficients: [Double] = [
    676.5203681218851,
    -1259.1392167224028,
    771.32342877765313,
    -176.61502916214059,
    12.507343278686905,
    -0.13857109526572012,
    9.9843695780195716e-6,
    1.5056327351493116e-7
]

/// The gamma function (represented by Γ, the capital letter gamma from the Greek alphabet) is one commonly used extension of the factorial function to complex numbers. The gamma function is defined for all complex numbers except the non-positive integers. For any positive integer n: $ \Gamma (n)=(n-1)! $
/// - Parameter float: A BigNumber
public func gamma(_ float: BigNumber) -> BigNumber {
    if float < 0.5 {
        let piT = pi * float
        let precision15 = piT * (10 ** 15)
        let rounded = precision15.rounded()
        let double = Double(rounded.asInt() ?? 0)
        let si = sin(double)
        let y = pi / (si * gamma(1 - float))
        return y
    }
    guard let floated = (float - 1).asDouble() else {
        if float == BigDouble(float.rounded()) {
            guard let i = float.rounded().asInt() else { return .zero }
            return BigDouble(BigInt(limbs: Limbs.recursiveMul(0, Limb(i))))
        }
        return .zero
    }
    var x: Double = 0.99999999999980993
    for (i, pval) in coefficients.enumerated() {
        x += pval / (floated + Double(i) + 1)
    }
    let t = floated + Double(coefficients.count) - 0.5
    let squareroot = sqrt(2 * .pi)
    let expo = exp(-t)
    let powed = pow(t, floated + 0.5)
    let y =  squareroot * powed * expo * x
    
    if float == BigDouble(float.rounded()) {
        return BigNumber(BigNumber(y).rounded())
    }
    return BigNumber(y)
}

/// Returns the factorial of a number. The factorial of a number is equal to 1*2*3*...* number.
///
/// > This relies on Lanczos approximation, provided by `gamma`
///
/// Let's say you have six bells, each with a different tone, and you want to find the number of unique sequences in which each bell can be rung once. In this example, you are calculating the factorial of six. In general, use a factorial to count the number of ways in which a group of distinct items can be arranged (also called permutations). To calculate the factorial of a number, use this function.
/// - Parameter number: The nonnegative number for which you want the factorial. If number is not an integer, it is truncated.
public func factorial(_ number: BigInt) -> BigInt {
    let r = gamma(BigNumber(number + 1)).rounded()
    if r == 0 && number.isPositive() {
        return (1 ... number).map { BigInt($0) }.reduce(BigInt(1), *)
    }
    return r
}
