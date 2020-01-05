//
//  OperationsBigInt.swift
//  
//
//  Created by Arthur Guiot on 2019-12-07.
//

import Foundation

public extension BigInt {
    //
    //
    //    MARK: - BigNumber Addition
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        BigNumber Addition        |||||||||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    prefix static func +(x: BigInt) -> BigInt {
        return x
    }
    
    // Required by protocol Numeric
    static func +=(lhs: inout BigInt, rhs: BigInt) {
        if lhs.sign == rhs.sign
        {
            lhs.limbs.addLimbs(rhs.limbs)
            return
        }
        
        let rhsIsMin = rhs.limbs.lessThan(lhs.limbs)
        lhs.limbs.difference(rhs.limbs)
        lhs.sign = (rhs.sign && !rhsIsMin) || (lhs.sign && rhsIsMin) // DNF minimization
        
        if lhs.isZero() { lhs.sign = false }
    }
    
    // Required by protocol Numeric
    static func +(lhs: BigInt, rhs: BigInt) -> BigInt {
        var lhs = lhs
        lhs += rhs
        return lhs
    }
    
    static func +(lhs:  Int, rhs: BigInt) -> BigInt { return BigInt(lhs) + rhs }
    static func +(lhs: BigInt, rhs:  Int) -> BigInt { return lhs + BigInt(rhs) }
    
    static func +=(lhs: inout  Int, rhs: BigInt) { lhs += (BigInt(lhs) + rhs).asInt()! }
    static func +=(lhs: inout BigInt, rhs:  Int) { lhs +=  BigInt(rhs)                 }
    
    //
    //
    //    MARK: - BigNumber Negation
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        BigNumber Negation        |||||||||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    // Required by protocol SignedNumeric
    mutating func negate() {
        if self.isNotZero() { self.sign = !self.sign }
    }
    
    // Required by protocol SignedNumeric
    static prefix func -(n: BigInt) -> BigInt {
        var n = n
        n.negate()
        return n
    }
    
    //
    //
    //    MARK: - BigNumber Subtraction
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        BigNumber Subtraction        ||||||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    // Required by protocol Numeric
    static func -(lhs: BigInt, rhs: BigInt) -> BigInt {
        return lhs + -rhs
    }
    
    static func -(lhs:  Int, rhs: BigInt) -> BigInt { return BigInt(lhs) - rhs }
    static func -(lhs: BigInt, rhs:  Int) -> BigInt { return lhs - BigInt(rhs) }
    
    // Required by protocol Numeric
    static func -=(lhs: inout BigInt, rhs: BigInt) { lhs += -rhs                        }
    static func -=(lhs: inout  Int, rhs: BigInt)  { lhs  = (BigInt(lhs) - rhs).asInt()! }
    static func -=(lhs: inout BigInt, rhs:  Int)  { lhs -= BigInt(rhs)                  }
    
    //
    //
    //    MARK: - BigNumber Multiplication
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        BigNumber Multiplication        |||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    // Required by protocol Numeric
    static func *(lhs: BigInt, rhs: BigInt) -> BigInt {
        let sign = !(lhs.sign == rhs.sign || lhs.isZero() || rhs.isZero())
        return BigInt(sign: sign, limbs: lhs.limbs.multiplyingBy(rhs.limbs))
    }
    
    static func *(lhs: Int, rhs: BigInt) -> BigInt { return BigInt(lhs) * rhs }
    static func *(lhs: BigInt, rhs: Int) -> BigInt { return lhs * BigInt(rhs) }
    
    // Required by protocol SignedNumeric
    static func *=(lhs: inout BigInt, rhs: BigInt) { lhs = lhs * rhs           }
    static func *=(lhs: inout  Int, rhs: BigInt) { lhs = (BigInt(lhs) * rhs).asInt()! }
    static func *=(lhs: inout BigInt, rhs:  Int) { lhs = lhs * BigInt(rhs)            }
    
    //
    //
    //    MARK: - BigNumber Exponentiation
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        BigNumber Exponentiation        |||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    static func **(lhs: BigInt, rhs: Int) -> BigInt {
        precondition(rhs >= 0, "BigNumbers can't be exponentiated with exponents < 0")
        return BigInt(sign: lhs.sign && (rhs % 2 != 0), limbs: lhs.limbs.exponentiating(rhs))
    }
    
    func factorial() -> BigInt {
        precondition(!self.sign, "Can't calculate the factorial of an negative number")
        
        return BigInt(limbs: Limbs.recursiveMul(0, Limb(self.asInt()!)))
    }
    
    //
    //
    //    MARK: - BigNumber Division
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        BigNumber Division        |||||||||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    ///    Returns the quotient and remainder of this value divided by the given value.
    func quotientAndRemainder(dividingBy rhs: BigInt) -> (quotient: BigInt, remainder: BigInt) {
        let limbRes = self.limbs.divMod(rhs.limbs)
        return (BigInt(limbs: limbRes.quotient), BigInt(limbs: limbRes.remainder))
    }
    
    static func /(lhs: BigInt, rhs:BigInt) -> BigInt {
        let limbs = lhs.limbs.divMod(rhs.limbs).quotient
        let sign = (lhs.sign != rhs.sign) && !limbs.equalTo(0)
        
        return BigInt(sign: sign, limbs: limbs)
    }
    
    static func /(lhs:  Int, rhs: BigInt) -> BigInt { return BigInt(lhs) / rhs }
    static func /(lhs: BigInt, rhs:  Int) -> BigInt { return lhs / BigInt(rhs) }
    
    static func /=(lhs: inout BigInt, rhs: BigInt) { lhs = lhs / rhs }
    static func /=(lhs: inout BigInt, rhs:  Int) { lhs = lhs / BigInt(rhs)  }
    //
    //
    //    MARK: - BigNumber Modulus
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        BigNumber Modulus        ||||||||||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    static func %(lhs: BigInt, rhs: BigInt) -> BigInt {
        let limbs = lhs.limbs.divMod(rhs.limbs).remainder
        let sign = lhs.sign && !limbs.equalTo(0)
        
        return BigInt(sign: sign, limbs: limbs)
    }
    
    static func %(lhs:  Int, rhs: BigInt) -> BigInt { return BigInt(lhs) % rhs  }
    static func %(lhs: BigInt, rhs:  Int) -> BigInt { return lhs  % BigInt(rhs) }
    
    static func %=(lhs: inout BigInt, rhs: BigInt)  { lhs = lhs % rhs }
    static func %=(lhs: inout BigInt, rhs:  Int)  { lhs = lhs % BigInt(rhs)  }
    
    //
    //
    //    MARK: - BigNumber Comparing
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        BigNumber Comparing        ||||||||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    // Required by protocol Equatable
    static func ==(lhs: BigInt, rhs: BigInt) -> Bool {
        if lhs.sign != rhs.sign { return false }
        return lhs.limbs == rhs.limbs
    }
    
    static func ==<T: BinaryInteger>(lhs: BigInt, rhs: T) -> Bool {
        if lhs.limbs.count != 1 { return false }
        return lhs.limbs[0] == rhs
    }
    
    static func ==<T: BinaryInteger>(lhs:  T, rhs: BigInt) -> Bool { return rhs == lhs }
    
    static func !=(lhs: BigInt, rhs: BigInt) -> Bool {
        if lhs.sign != rhs.sign { return true }
        return lhs.limbs != rhs.limbs
    }
    
    static func !=<T: BinaryInteger>(lhs: BigInt, rhs: T) -> Bool {
        if lhs.limbs.count != 1 { return true }
        return lhs.limbs[0] != rhs
    }
    
    static func !=<T: BinaryInteger>(lhs: T, rhs: BigInt) -> Bool { return rhs != lhs }
    
    // Required by protocol Comparable
    static func <(lhs: BigInt, rhs: BigInt) -> Bool {
        if lhs.sign != rhs.sign { return lhs.sign }
        
        if lhs.sign { return rhs.limbs.lessThan(lhs.limbs) }
        return lhs.limbs.lessThan(rhs.limbs)
    }
    
    static func <<T: BinaryInteger>(lhs: BigInt, rhs: T) -> Bool {
        if lhs.sign != (rhs < 0) { return lhs.sign }
        
        if lhs.sign {
            if lhs.limbs.count != 1 { return true }
            return rhs < lhs.limbs[0]
        } else {
            if lhs.limbs.count != 1 { return false }
            return lhs.limbs[0] < rhs
        }
        
    }
    
    static func <(lhs:  Int, rhs: BigInt) -> Bool { return BigInt(lhs) < rhs }
    static func <(lhs: BigInt, rhs:  Int) -> Bool { return lhs < BigInt(rhs) }
    
    // Required by protocol Comparable
    static func >(lhs: BigInt, rhs: BigInt) -> Bool { return rhs < lhs }
    static func >(lhs:  Int, rhs: BigInt) -> Bool { return BigInt(lhs) > rhs  }
    static func >(lhs: BigInt, rhs:  Int) -> Bool { return lhs > BigInt(rhs)  }
    
    // Required by protocol Comparable
    static func <=(lhs: BigInt, rhs: BigInt) -> Bool { return !(rhs < lhs) }
    static func <=(lhs:  Int, rhs: BigInt) -> Bool { return !(rhs < BigInt(lhs))  }
    static func <=(lhs: BigInt, rhs:  Int) -> Bool { return !(BigInt(rhs) < lhs)  }
    
    // Required by protocol Comparable
    static func >=(lhs: BigInt, rhs: BigInt) -> Bool { return !(lhs < rhs) }
    static func >=(lhs:  Int, rhs: BigInt) -> Bool { return !(BigInt(lhs) < rhs)  }
    static func >=(lhs: BigInt, rhs:  Int) -> Bool { return !(lhs < BigInt(rhs))  }
}
