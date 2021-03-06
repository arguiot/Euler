//
//  Limbs.swift
//  
//
//  Created by Arthur Guiot on 2019-12-07.
//

import Foundation

//
//
//    MARK: - Limbs extension
//    ————————————————————————————————————————————————————————————————————————————————————————————
//    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ||||||||        Limbs extension        |||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ————————————————————————————————————————————————————————————————————————————————————————————
//
//
//
// Extension to Limbs type
internal extension Array where Element == Limb {
    //
    //
    //    MARK: - Limbs bitlevel
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        Limbs bitlevel        ||||||||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    /// Returns the number of bits that contribute to the represented number, ignoring all
    /// leading zeros.
    var bitWidth: Int {
        var lastBits = 0
        var last = self.last!
        
        while last != 0 {
            last >>= 1
            lastBits += 1
        }
        
        return ((self.count - 1) * 64) + lastBits
    }
    
    ///    Get bit i of limbs.
    func getBit(at i: Int) -> Bool {
        let limbIndex = Int(Limb(i) >> 6)
        
        if limbIndex >= self.count { return false }
        
        let bitIndex = Limb(i) & 0b111_111
        
        return (self[limbIndex] & (1 << bitIndex)) != 0
    }
    
    /// Set bit i of limbs to b. b must be 0 for false, and everything else for true.
    mutating func setBit(
        at i: Int,
        to bit: Bool
    ){
        let limbIndex = Int(Limb(i) >> 6)
        
        if limbIndex >= self.count && !bit { return }
        
        let bitIndex = Limb(i) & 0b111_111
        
        while limbIndex >= self.count { self.append(0) }
        
        if bit {
            self[limbIndex] |= (1 << bitIndex)
        }
        else {
            self[limbIndex] &= ~(1 << bitIndex)
        }
    }
    
    //
    //
    //    MARK: - Limbs Shifting
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        Limbs Shifting        ||||||||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    mutating func shiftUp(_ shift: Int) {
        // No shifting is required in this case
        if shift == 0 || self.equalTo(0) { return }
        
        let limbShifts =  shift >> 6
        let bitShifts = Limb(shift) & 0x3f
        
        if bitShifts != 0
        {
            var previousCarry = Limb(0)
            var carry = Limb(0)
            var ele = Limb(0) // use variable to minimize array accesses
            
            for i in 0..<self.count
            {
                ele = self[i]
                
                carry = ele >> (64 - bitShifts)
                
                ele <<= bitShifts
                ele |= previousCarry // carry from last step
                previousCarry = carry
                
                self[i] = ele
            }
            
            if previousCarry != 0 { self.append(previousCarry) }
        }
        
        if limbShifts != 0
        {
            self.insert(contentsOf: Limbs(repeating: 0, count: limbShifts), at: 0)
        }
    }
    
    func shiftingUp(_ shift: Int) -> Limbs {
        var res = self
        res.shiftUp(shift)
        return res
    }
    
    mutating func shiftDown(_ shift: Int) {
        if shift == 0 || self.equalTo(0) { return }
        
        let limbShifts =  shift >> 6
        let bitShifts = Limb(shift) & 0x3f
        
        if limbShifts >= self.count {
            self = [0]
            return
        }
        
        self.removeSubrange(0..<limbShifts)
        
        if bitShifts != 0 {
            var previousCarry = Limb(0)
            var carry = Limb(0)
            var ele = Limb(0) // use variable to minimize array accesses
            
            var i = self.count - 1 // use while for high performance
            while i >= 0 {
                ele = self[i]
                
                carry = ele << (64 - bitShifts)
                
                ele >>= bitShifts
                ele |= previousCarry
                previousCarry = carry
                
                self[i] = ele
                
                i -= 1
            }
        }
        
        if self.last! == 0 && self.count != 1 { self.removeLast() }
    }
    
    func shiftingDown(_ shift: Int) -> Limbs {
        var res = self
        res.shiftDown(shift)
        return res
    }
    
    //
    //
    //    MARK: - Limbs Addition
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        Limbs Addition        ||||||||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    mutating func addLimbs(_ addend: Limbs) {
        let (sc, ac) = (self.count, addend.count)
        
        var (newLimb, ovfl) = (Limb(0), false)
        
        let minCount = Swift.min(sc, ac)
        
        var i = 0
        while i < minCount {
            if ovfl {
                (newLimb, ovfl) =  self[i].addingReportingOverflow(addend[i])
                newLimb = newLimb &+ 1
                
                ovfl = ovfl || newLimb == 0
            }
            else {
                (newLimb, ovfl) = self[i].addingReportingOverflow(addend[i])
            }
            
            self[i] = newLimb
            i += 1
        }
        
        while ovfl {
            if i < sc {
                if i < ac {
                    (newLimb, ovfl) = self[i].addingReportingOverflow(addend[i])
                    newLimb = newLimb &+ 1
                    ovfl = ovfl || newLimb == 0
                }
                else {
                    (newLimb, ovfl) = self[i].addingReportingOverflow(1)
                }
                
                self[i] = newLimb
            }
            else {
                if i < ac {
                    (newLimb, ovfl) = addend[i].addingReportingOverflow(1)
                    self.append(newLimb)
                }
                else {
                    self.append(1)
                    return
                }
            }
            
            i += 1
        }
        
        if self.count < ac {
            self.append(contentsOf: addend.suffix(from: i))
        }
    }
    
    /// Adding Limbs and returning result
    func adding(_ addend: Limbs) -> Limbs {
        var res = self
        res.addLimbs(addend)
        return res
    }
    
    // CURRENTLY NOT USED:
    ///    Add the addend to Limbs, while using a padding at the lower end.
    ///    Every zero is a Limb, that means one padding zero equals 64 padding bits
    mutating func addLimbs(
        _ addend: Limbs,
        padding paddingZeros: Int
    ){
        let sc = self.count
        
        if paddingZeros >  sc { self += Digits(repeating: 0, count: paddingZeros &- sc) }
        if paddingZeros >= sc { self += addend; return }
        
        // Now, i < sc
        let ac = addend.count &+ paddingZeros
        
        var (newLimb, ovfl) = (Limb(0), false)
        
        let minCount = Swift.min(sc, ac)
        
        var i = paddingZeros
        while i < minCount {
            if ovfl {
                (newLimb, ovfl) = self[i].addingReportingOverflow(addend[i &- paddingZeros])
                newLimb = newLimb &+ 1
                self[i] = newLimb
                ovfl = ovfl || newLimb == 0
            }
            else {
                (self[i], ovfl) = self[i].addingReportingOverflow(addend[i &- paddingZeros])
            }
            
            i += 1
        }
        
        while ovfl {
            if i < sc {
                let adding = i < ac ? addend[i &- paddingZeros] &+ 1 : 1
                (self[i], ovfl) = self[i].addingReportingOverflow(adding)
                ovfl = ovfl || adding == 0
            }
            else {
                if i < ac {
                    (newLimb, ovfl) = addend[i &- paddingZeros].addingReportingOverflow(1)
                    self.append(newLimb)
                }
                else {
                    self.append(1)
                    return
                }
            }
            
            i += 1
        }
        
        if self.count < ac {
            self.append(contentsOf: addend.suffix(from: i &- paddingZeros))
        }
    }
    
    mutating func addOneLimb(
        _ addend: Limb,
        padding paddingZeros: Int
    ){
        let sc = self.count
        
        if paddingZeros >  sc { self += Digits(repeating: 0, count: paddingZeros &- sc) }
        if paddingZeros >= sc { self.append(addend); return }
        
        // Now, i < lhc
        var i = paddingZeros
        
        var ovfl: Bool
        (self[i], ovfl) = self[i].addingReportingOverflow(addend)
        
        while ovfl {
            i += 1
            if i == sc { self.append(1); return }
            (self[i], ovfl) = self[i].addingReportingOverflow(1)
        }
    }
    
    /// Basically self.addOneLimb([addendLow, addendHigh], padding: paddingZeros), but faster
    mutating func addTwoLimb(
        _ addendLow: Limb,
        _ addendHigh: Limb,
        padding paddingZeros: Int)
    {
        let sc = self.count
        
        if paddingZeros >  sc { self += Digits(repeating: 0, count: paddingZeros &- sc) }
        if paddingZeros >= sc { self += [addendLow, addendHigh]; return }
        
        // Now, i < sc
        var i = paddingZeros
        var newLimb: Limb
        
        var ovfl1: Bool
        (self[i], ovfl1) =  self[i].addingReportingOverflow(addendLow)
        i += 1
        
        if i == sc {
            newLimb = addendHigh &+ (ovfl1 ? 1 : 0)
            self.append(newLimb)
            if newLimb == 0 { self.append(1) }
            return
        }
        
        // Still, i < sc
        var ovfl2: Bool
        (self[i], ovfl2) = self[i].addingReportingOverflow(addendHigh)
        
        if ovfl1 {
            self[i] = self[i] &+ 1
            if self[i] == 0 { ovfl2 = true }
        }
        
        while ovfl2 {
            i += 1
            if i == sc { self.append(1); return }
            (self[i], ovfl2) = self[i].addingReportingOverflow(1)
        }
    }
    
    //
    //
    //    MARK: - Limbs Subtraction
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        Limbs Subtraction        |||||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    /// Calculates difference between Limbs in left limb
    mutating func difference(_ subtrahend: Limbs) {
        var subtrahend = subtrahend
        // swap to get difference
        if self.lessThan(subtrahend) { swap(&self, &subtrahend) }
        
        let rhc = subtrahend.count
        var ovfl = false
        
        var i = 0
        
        // skip first zeros
        while i < rhc && subtrahend[i] == 0 { i += 1 }
        
        while i < rhc {
            if ovfl {
                (self[i], ovfl) = self[i].subtractingReportingOverflow(subtrahend[i])
                self[i] = self[i] &- 1
                ovfl = ovfl || self[i] == Limb.max
            }
            else {
                (self[i], ovfl) = self[i].subtractingReportingOverflow(subtrahend[i])
            }
            
            i += 1
        }
        
        while ovfl {
            if i >= self.count {
                self.append(Limb.max)
                break
            }
            
            (self[i], ovfl) = self[i].subtractingReportingOverflow(1)
            
            i += 1
        }
        
        if self.count > 1 && self.last! == 0 {// cut excess zeros if required {
            var j = self.count - 2
            while j >= 1 && self[j] == 0 { j -= 1 }
            
            self.removeSubrange((j + 1)..<self.count)
        }
    }
    
    func differencing(_ subtrahend: Limbs) -> Limbs {
        var res = self
        res.difference(subtrahend)
        return res
    }
    
    //
    //
    //    MARK: - Limbs Multiplication
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        Limbs Multiplication        |||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    mutating func addProductOf(
        multiplier: Limbs,
        multiplicand: Limbs
    ){
        let (mpc, mcc) = (multiplier.count, multiplicand.count)
        
        self.reserveCapacity(mpc + mcc)
        
        // Minimize array subscript calls
        var l, r, mulHi, mulLo: Limb
        
        for i in 0..<mpc {
            l = multiplier[i]
            if l == 0 { continue }
            
            for j in 0..<mcc {
                r = multiplicand[j]
                if r == 0 { continue }
                
                (mulHi, mulLo) = l.multipliedFullWidth(by: r)
                
                if mulHi != 0 { self.addTwoLimb(mulLo, mulHi, padding: i + j) }
                else          { self.addOneLimb(mulLo,        padding: i + j) }
            }
        }
    }
    
    // Perform res += (lhs * r)
    mutating func addProductOf(
        multiplier: Limbs,
        multiplicand: Limb
    ){
        if multiplicand < 2 {
            if multiplicand == 1 { self.addLimbs(multiplier) }
            // If r == 0 then do nothing with res
            return
        }
        
        // Minimize array subscript calls
        var l, mulHi, mulLo: Limb
        
        for i in 0..<multiplier.count {
            l = multiplier[i]
            if l == 0 { continue }
            
            (mulHi, mulLo) = l.multipliedFullWidth(by: multiplicand)
            
            if mulHi != 0 { self.addTwoLimb(mulLo, mulHi, padding: i) }
            else          { self.addOneLimb(mulLo,        padding: i) }
        }
    }
    
    func multiplyingBy(_ multiplicand: Limbs) -> Limbs {
        var res: Limbs = [0]
        res.addProductOf(multiplier: self, multiplicand: multiplicand)
        return res
    }
    
    func squared() -> Limbs {
        var res: Limbs = [0]
        res.reserveCapacity(2 * self.count)
        
        // Minimize array subscript calls
        var l, r, mulHi, mulLo: Limb
        
        for i in 0..<self.count {
            l = self[i]
            if l == 0 { continue }
            
            for j in 0...i {
                r = self[j]
                if r == 0 { continue }
                
                (mulHi, mulLo) = l.multipliedFullWidth(by: r)
                
                if mulHi != 0 {
                    if i != j { res.addTwoLimb(mulLo, mulHi, padding: i + j) }
                    res.addTwoLimb(mulLo, mulHi, padding: i + j)
                }
                else {
                    if i != j { res.addOneLimb(mulLo, padding: i + j) }
                    res.addOneLimb(mulLo, padding: i + j)
                }
            }
        }
        
        return res
    }
    
    //
    //
    //    MARK: - Limbs Exponentiation
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        Limbs Exponentiation        ||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    // Exponentiation by squaring
    func exponentiating(_ exponent: Int) -> Limbs {
        if exponent == 0 { return [1] }
        if exponent == 1 { return self }
        
        var base = self
        var exponent = exponent
        var y: Limbs = [1]
        
        while exponent > 1 {
            if exponent & 1 != 0 { y = y.multiplyingBy(base) }
            base = base.squared()
            exponent >>= 1
        }
        
        return base.multiplyingBy(y)
    }
    
    /// Calculate (n + 1) * (n + 2) * ... * (k - 1) * k
    static func recursiveMul(_ n: Limb, _ k: Limb) -> Limbs {
        if n >= k - 1 { return [k] }
        
        let m = (n + k) >> 1
        
        return recursiveMul(n, m).multiplyingBy(recursiveMul(m, k))
    }
    
    func factorial(_ base: Int) -> BigInt {
        return BigInt(limbs: Limbs.recursiveMul(0, Limb(base)))
    }
    
    //
    //
    //    MARK: - Limbs Division and Modulo
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        Limbs Division and Modulo        |||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    /// An O(n^2) division algorithm that returns quotient and remainder.
    func divMod(_ divisor: Limbs) -> (quotient: Limbs, remainder: Limbs) {
        precondition(!divisor.equalTo(0), "Division or Modulo by zero not allowed")
        
        // Handle the case of a divisor greater than the dividend.  The fast
        // test of limb counts is based on Euler maintaining limbs without
        // leading zeros.
        if divisor.count > self.count
            || (divisor.count == self.count && self.lessThan(divisor))
        {
            return (quotient: [0], remainder: self)
        }
        
        guard divisor.count > 1 else
        {
            // Knuth's algorithm requires at least 2 divisor digits, so handle
            // that case specially.
            var q = Limbs(repeating: 0, count: self.count)
            let r = divide(self, by: divisor.first!, result: &q)
            while q.count > 1 && q.last! == 0 { q.removeLast() }
            return (quotient: q, remainder: [r])
        }

        /*
         The actual algorithm starts here.  The variable names, u, v, m, and n
         are based on the names published in Knuth's Alogirthm D in his The Art
         of Computer Programming, and are maintained so that anyone following
         the algorithm from TAOCP can identify them in this code.  For
         everyone else, here's a legend:
         
                u = the normalized dividend that is transformed into the
                    remainder (initially a normalized copy of self).
                v = the normalized divisor
                m = the number of limbs in the dividend
                n = the number of limbs in the divisor
         */
        let maxQuotientSize = self.count - divisor.count + 1
        var quotient = Limbs(repeating: 0, count: maxQuotientSize)

        typealias TwoLimbs = (high: UInt64, low: UInt64)
        let digitWidth = Digit.bitWidth
        let m = self.count
        let n = divisor.count
        
        // Normalize divisor so its most significant bit is 1.
        let shift = divisor.last!.leadingZeroBitCount
        var v = Limbs(repeating: 0, count: n)
        leftShift(divisor, by: shift, into: &v)
        
        // Normalize dividend by the same amount so its ratio with the divisor
        // is maintained.
        var u = Limbs(repeating: 0, count: m + 1)
        u[m] = self[m - 1] >> (digitWidth - shift)
        leftShift(self, by: shift, into: &u)
        
        let vLast: UInt64 = v.last!
        let vNextToLast: UInt64 = v[n - 2]
        let partialDividendDelta: TwoLimbs = (high: vLast, low: 0)

        for j in (0...(m - n)).reversed()
        {
            let jPlusN = j &+ n
            
            let dividendHead: TwoLimbs = (high: u[jPlusN], low: u[jPlusN &- 1])
            
            // Compute estimated quotient digit, q̂, and partial remainder, r̂
            // These are tuple arithemtic operations.  `/%` is custom combined
            // division and remainder operator.
            var (q̂, r̂) = dividendHead /% vLast
            var partialProduct = q̂ * vNextToLast
            var partialDividend:TwoLimbs = (high: r̂.low, low: u[jPlusN &- 2])
            
            // Revise estimated q̂ based on the first two digits of the divisor
            // and first two digits of the dividend.  It corrects most of the
            // cases when q̂ is one too big, and all of the cases when q̂ is two
            // too big.
            // Corresponds to Step D3 in TAOCP
            while true
            {
                if (UInt8(q̂.high != 0) | (partialProduct > partialDividend)) == 1
                {
                    q̂ -= 1
                    r̂ += vLast
                    partialProduct -= vNextToLast
                    partialDividend += partialDividendDelta
                    
                    if r̂.high == 0 { continue }
                }
                break
            }

            // Set quotient digit, and compute an updated remainder
            quotient[j] = q̂.low
            if subtractReportingBorrow(v[0..<n], times: q̂.low, from: &u[j...jPlusN])
            {
                // If the subtraction borrowed out of the high limb, then q̂
                // was still one too big, so decrement it and adjust the
                // updated remainder.  Because of the above while loop, this is
                // rare, but possible.
                quotient[j] &-= 1
                u[j...jPlusN] += v[0..<n] // Limbs subsequence addition!
            }
        }
        
        // Quotient is already correct, but remainder needs denormalization
        rightShift(&u[0..<n], by: shift)

        // The division algorithm is done, but now we clean up the results for
        // Euler's requirements. quotient and remainder both may have leading
        // zeros that need removing.
        while quotient.count > 1 && quotient.last! == 0 {
            quotient.removeLast()
        }
        while u.count > 1 && u.last! == 0 { u.removeLast() }
        
        return (quotient, u)
    }
    
    /// Old divMod
    func divMod_ShiftSubtract(_ divisor: Limbs) -> (quotient: Limbs, remainder: Limbs) {
        let dividend = self
        
        if dividend.equalTo(0) { return ([0], [0]) }
        
        if dividend.lessThan(divisor) { return ([0], dividend) }
        
        var (quotient, remainder): (Limbs, Limbs) = ([0], [0])
        var (previousCarry, carry, ele): (Limb, Limb, Limb) = (0, 0, 0)
        
        // bits of lhs minus one bit
        var i = (64 * (dividend.count - 1)) + Int(log2(Double(dividend.last!)))
        
        while i >= 0
        {
            // shift remainder by 1 to the left
            for r in 0..<remainder.count
            {
                ele = remainder[r]
                carry = ele >> 63
                ele <<= 1
                ele |= previousCarry // carry from last step
                previousCarry = carry
                remainder[r] = ele
            }
            if previousCarry != 0 { remainder.append(previousCarry) }
            
            remainder.setBit(at: 0, to: dividend.getBit(at: i))
            
            if !remainder.lessThan(divisor) {
                remainder.difference(divisor)
                quotient.setBit(at: i, to: true)
            }
            
            i -= 1
        }
        
        return (quotient, remainder)
    }
    
    /// Division with limbs, result is floored to nearest whole number.
    func dividing(_ divisor: Limbs) -> Limbs {
        return self.divMod(divisor).quotient
    }
    
    /// Modulo with limbs, result is floored to nearest whole number.
    func modulus(_ divisor: Limbs) -> Limbs {
        return self.divMod(divisor).remainder
    }
    
    //
    //
    //    MARK: - Limbs Comparing
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        Limbs Comparing        |||||||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    //    Note:
    //    a < b iff b > a
    //    a <= b iff b >= a
    //    but:
    //    a < b iff !(a >= b)
    //    a <= b iff !(a > b)
    
    func lessThan(_ compare: Limbs) -> Bool {
        let lhsc = self.count
        let rhsc = compare.count
        
        if lhsc != rhsc {
            return lhsc < rhsc
        }
        
        var i = lhsc - 1
        while i >= 0 {
            if self[i] != compare[i] { return self[i] < compare[i] }
            i -= 1
        }
        
        return false // lhs == rhs
    }
    
    func equalTo(_ compare: Limb) -> Bool {
        return self[0] == compare && self.count == 1
    }

}
