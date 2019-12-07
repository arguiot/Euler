//
//  BinaryBigInt.swift
//  
//
//  Created by Arthur Guiot on 2019-12-07.
//

import Foundation

extension BigInt {
    //
    //
    //    MARK: - BigNumber Shifts
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        BigNumber Shifts        |||||||||||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    public static func <<<T: BinaryInteger>(lhs: BigInt, rhs: T) -> BigInt {
        if rhs < 0 { return lhs >> rhs }
        
        let limbs = lhs.limbs.shiftingUp(Int(rhs))
        let sign = lhs.isNegative() && !limbs.equalTo(0)
        
        return BigInt(sign: sign, limbs: limbs)
    }
    
    public static func <<=<T: BinaryInteger>(lhs: inout BigInt, rhs: T) {
        lhs.limbs.shiftUp(Int(rhs))
    }
    
    public static func >><T: BinaryInteger>(lhs: BigInt, rhs: T) -> BigInt {
        if rhs < 0 { return lhs << rhs }
        return BigInt(sign: lhs.sign, limbs: lhs.limbs.shiftingDown(Int(rhs)))
    }
    
    public static func >>=<T: BinaryInteger>(lhs: inout BigInt, rhs: T) {
        lhs.limbs.shiftDown(Int(rhs))
    }
    
    //
    //
    //    MARK: - BigNumber Bitwise AND
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        BigNumber BigNumber Bitwise AND        |||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    ///    Returns the result of performing a bitwise AND operation on the two given values.
    public static func &(lhs: BigInt, rhs: BigInt) -> BigInt {
        var res: Limbs = [0]
        
        for i in 0..<(64 * Swift.max(lhs.limbs.count, rhs.limbs.count)) {
            let newBit = lhs.limbs.getBit(at: i) && rhs.limbs.getBit(at: i)
            res.setBit(at: i, to: newBit)
        }
        
        return BigInt(sign: lhs.sign && rhs.sign, limbs: res)
    }
    
    //    static func &(lhs: Int, rhs: BigNumber) -> BigNumber
    //    static func &(lhs: BigNumber, rhs: Int) -> BigNumber
    
    ///    Stores the result of performing a bitwise AND operation on the two given values in the
    ///    left-hand-side variable.
    public static func &=(lhs: inout BigInt, rhs: BigInt) {
        let res = lhs & rhs
        lhs = res
    }
    
    //    static func &=(inout lhs: Int, rhs: BigNumber)
    //    static func &=(inout lhs: BigNumber, rhs: Int)
    
    //
    //
    //    MARK: - BigNumber Bitwise OR
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        BigNumber Bitwise OR        |||||||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    public static func |(lhs: BigInt, rhs: BigInt) -> BigInt {
        var res: Limbs = [0]
        
        for i in 0..<(64 * Swift.max(lhs.limbs.count, rhs.limbs.count)) {
            let newBit = lhs.limbs.getBit(at: i) || rhs.limbs.getBit(at: i)
            res.setBit(at: i, to: newBit)
        }
        
        return BigInt(sign: lhs.sign || rhs.sign, limbs: res)
    }
    
    //    static func |(lhs: Int, rhs: BigNumber) -> BigNumber
    //    static func |(lhs: BigNumber, rhs: Int) -> BigNumber
    //
    public static func |=(lhs: inout BigInt, rhs: BigInt) {
        let res = lhs | rhs
        lhs = res
    }
    //    static func |=(inout lhs: Int, rhs: BigNumber)
    //    static func |=(inout lhs: BigNumber, rhs: Int)
    
    //
    //
    //    MARK: - BigNumber Bitwise OR
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        BigNumber Bitwise XOR        ||||||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    public static func ^(lhs: BigInt, rhs: BigInt) -> BigInt {
        var res: Limbs = [0]
        
        for i in 0..<(64 * Swift.max(lhs.limbs.count, rhs.limbs.count))
        {
            let newBit = lhs.limbs.getBit(at: i) != rhs.limbs.getBit(at: i)
            res.setBit(at: i, to: newBit)
        }
        
        return BigInt(sign: lhs.sign != rhs.sign, limbs: res)
    }
    
    public static func ^=(lhs: inout BigInt, rhs: BigInt) {
        let res = lhs ^ rhs
        lhs = res
    }
    
    //
    //
    //    MARK: - BigNumber Bitwise NOT
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        BigNumber Bitwise NOT        ||||||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    public prefix static func ~(x: BigInt) -> BigInt {
        var res = x.limbs
        for i in 0..<(res.bitWidth)
        {
            res.setBit(at: i, to: !res.getBit(at: i))
        }
        
        while res.last! == 0 && res.count > 1 { res.removeLast() }
        
        return BigInt(sign: !x.sign, limbs: res)
    }
}
