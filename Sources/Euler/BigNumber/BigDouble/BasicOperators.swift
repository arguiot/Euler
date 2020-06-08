//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2019-12-07.
//

import Foundation


//
//
//    MARK: - BigDouble Operators
//    ————————————————————————————————————————————————————————————————————————————————————————————
//    ||||||||        BigDouble more Operators        ||||||||||||||||||||||||||||||||||||||||||||||
//    ————————————————————————————————————————————————————————————————————————————————————————————
//
//
//

/**
 * Returns the absolute value of the given number.
 * - parameter x: a big double
 */
public func abs(_ x: BigDouble) -> BigDouble {
    return BigDouble(
        sign: false,
        numerator: x.numerator,
        denominator: x.denominator
    )
}

/**
 * round to largest BigNumber value not greater than base
 */
public func floor(_ base: BigDouble) -> BigInt {
    if base.isZero() {
        return BigInt(0)
    }
    
    var div = BigInt(limbs: base.numerator.dividing(base.denominator))
    div.sign = base.sign
    
    var diff = base - div
    diff.sign = false
    
    if diff > 0 && base.sign == true {
        return div - 1
    }
    return div
}

/**
 * round to smallest BigNumber value not less than base
 */
public func ceil(_ base: BigDouble) -> BigInt {
    if base.isZero() {
        return BigInt(0)
    }
    var div = BigInt(limbs: base.numerator.dividing(base.denominator))
    let diff = base - div
    
    div.sign = base.sign
    if diff > 0 {
        return div + 1
    }
    return div
}

/**
 * Returns a BigDouble number raised to a given power.
 * - warning: This may take a while
 */
public func pow(_ base : BigDouble, _ exp : Int) -> BigDouble {
    return base**exp
}

/**
 * Returns a BigDouble number raised to a given power.
 * - warning: This may take a while
 */
public func pow(_ base : BigDouble, _ exp : BigInt) -> BigDouble {
    return base**exp
}

/**
 * - warning: This may take a while. This is only precise up until precision. When comparing results after `pow` or `** ` use` nearlyEqual`
 */
public func pow(_ base : BigDouble, _ exp : BigDouble) -> BigDouble {
    return base**exp
}

/**
 * Returns the BigDouble that is the smallest
 */
public func min(_ lhs: BigDouble, _ rhs: BigDouble) -> BigDouble {
    if lhs <= rhs {
        return lhs
    }
    return rhs
}

/**
 * Returns the BigDouble that is largest
 */
public func max(_ lhs: BigDouble, _ rhs: BigDouble) -> BigDouble {
    if lhs >= rhs {
        return lhs
    }
    return rhs
}
