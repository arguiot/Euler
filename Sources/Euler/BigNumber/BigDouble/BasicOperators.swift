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
    
    let digits = 3
    let multiplier = [10].exponentiating(digits)
    
    let rawRes = abs(base).numerator.multiplyingBy(multiplier).divMod(base.denominator).quotient
    
    let res = BigInt(limbs: rawRes).description
    
    let offset = res.count - digits
    let lhs = res.prefix(offset).description
    let rhs = Double("0." + res.suffix(res.count - offset))!
    
    var ans = BigInt(String(lhs))!
    if base.isNegative() {
        ans = -ans
        if rhs > 0.0 {
            ans = ans - BigInt(1)
        }
    }
    
    return ans
}

/**
 * round to smallest BigNumber value not less than base
 */
public func ceil(_ base: BigDouble) -> BigInt {
    if base.isZero() {
        return BigInt(0)
    }
    let digits = 3
    let multiplier = [10].exponentiating(digits)
    
    let rawRes = abs(base).numerator.multiplyingBy(multiplier).divMod(base.denominator).quotient
    
    let res = BigInt(limbs: rawRes).description
    
    let offset = res.count - digits
    let rhs = Double("0." + res.suffix(res.count - offset))!
    let lhs = res.prefix(offset)
    
    var retVal = BigInt(String(lhs))!
    
    if base.isNegative() {
        retVal = -retVal
    } else {
        if rhs > 0.0 {
            retVal += 1
        }
    }
    
    return retVal
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
