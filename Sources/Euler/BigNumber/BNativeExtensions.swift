//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2019-12-07.
//

import Foundation

//
//
//    MARK: - String operations
//    ————————————————————————————————————————————————————————————————————————————————————————————
//    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ||||||||        String operations        |||||||||||||||||||||||||||||||||||||||||||||||||||
//    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ————————————————————————————————————————————————————————————————————————————————————————————
//
//
//

internal extension String
{
    // Splits the string into equally sized parts (exept for the last one).
    func split(_ count: Int) -> [String] {
        return stride(from: 0, to: self.count, by: count).map { i -> String in
            let start = index(startIndex, offsetBy: i)
            let end = index(start, offsetBy: count, limitedBy: endIndex) ?? endIndex
            return String(self[start..<end])
        }
    }
}

internal let DigitBase:     Digit = 1_000_000_000_000_000_000
internal let DigitHalfBase: Digit =             1_000_000_000
internal let DigitZeros           =                        18

internal extension Array where Element == Limb{
    var decimalRepresentation: String {
        // First, convert limbs to digits
        var digits: Digits = [0]
        var power: Digits = [1]
        
        for limb in self {
            let digit = (limb >= DigitBase)
                ? [limb % DigitBase, limb / DigitBase]
                : [limb]
            
            digits.addProductOfDigits(digit, power)
            
            var nextPower: Digits = [0]
            nextPower.addProductOfDigits(power, [446_744_073_709_551_616, 18])
            power = nextPower
        }
        
        // Then, convert digits to string
        var res = String(digits.last!)
        
        if digits.count == 1 { return res }
        
        for i in (0..<(digits.count - 1)).reversed() {
            let str = String(digits[i])
            
            let leadingZeros = String(repeating: "0", count: DigitZeros - str.count)
            
            res.append(leadingZeros.appending(str))
        }
        
        return res
    }
}
internal extension Digit {
    mutating func addReportingOverflowDigit(_ addend: Digit) -> Bool {
        self = self &+ addend
        if self >= DigitBase { self -= DigitBase; return true }
        return false
    }
    
    func multipliedFullWidthDigit(by multiplicand: Digit) -> (Digit, Digit) {
        let (lLo, lHi) = (self % DigitHalfBase, self / DigitHalfBase)
        let (rLo, rHi) = (multiplicand % DigitHalfBase, multiplicand / DigitHalfBase)
        
        let K = (lHi * rLo) + (rHi * lLo)
        
        var resLo = (lLo * rLo) + ((K % DigitHalfBase) * DigitHalfBase)
        var resHi = (lHi * rHi) + (K / DigitHalfBase)
        
        if resLo >= DigitBase {
            resLo -= DigitBase
            resHi += 1
        }
        
        return (resLo, resHi)
    }
}
internal extension Array where Element == Digit {
    mutating func addOneDigit(
        _ addend: Limb,
        padding paddingZeros: Int
    ){
        let sc = self.count
        
        if paddingZeros >  sc { self += Digits(repeating: 0, count: paddingZeros &- sc) }
        if paddingZeros >= sc { self.append(addend); return }
        
        // Now, i < sc
        var i = paddingZeros
        
        let ovfl = self[i].addReportingOverflowDigit(addend)
        
        while ovfl {
            i += 1
            if i == sc { self.append(1); return }
            self[i] += 1
            if self[i] != DigitBase { return }
            self[i] = 0
        }
    }
    
    mutating func addTwoDigit(
        _ addendLow: Limb,
        _ addendHigh: Limb,
        padding paddingZeros: Int)
    {
        let sc = self.count
        
        if paddingZeros >  sc { self += Digits(repeating: 0, count: paddingZeros &- sc) }
        if paddingZeros >= sc { self += [addendLow, addendHigh]; return }
        
        // Now, i < sc
        var i = paddingZeros
        var newDigit: Digit
        
        let ovfl1 = self[i].addReportingOverflowDigit(addendLow)
        i += 1
        
        if i == sc {
            newDigit = (addendHigh &+ (ovfl1 ? 1 : 0)) % DigitBase
            self.append(newDigit)
            if newDigit == 0 { self.append(1) }
            return
        }
        
        // Still, i < sc
        var ovfl2 = self[i].addReportingOverflowDigit(addendHigh)
        if ovfl1 {
            self[i] += 1
            if self[i] == DigitBase { self[i] = 0; ovfl2 = true }
        }
        
        while ovfl2 {
            i += 1
            if i == sc { self.append(1); return }
            self[i] += 1
            if self[i] != DigitBase { return }
            self[i] = 0
        }
    }
    
    mutating func addProductOfDigits(_ multiplier: Digits, _ multiplicand: Digits) {
        let (mpc, mcc) = (multiplier.count, multiplicand.count)
        self.reserveCapacity(mpc &+ mcc)
        
        var l, r, resLo, resHi: Digit
        
        for i in 0..<mpc {
            l = multiplier[i]
            if l == 0 { continue }
            
            for j in 0..<mcc {
                r = multiplicand[j]
                if r == 0 { continue }
                
                (resLo, resHi) = l.multipliedFullWidthDigit(by: r)
                
                if resHi == 0 {
                    self.addOneDigit(resLo, padding: i + j)
                }
                else {
                    self.addTwoDigit(resLo, resHi, padding: i + j)
                }
            }
        }
    }
}
