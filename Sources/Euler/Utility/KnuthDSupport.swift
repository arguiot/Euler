//
//  KnuthDSupport.swift
//  Euler
//
//  Created by Chip Jarred on 9/9/20.
//
import Foundation

// -------------------------------------
internal extension FixedWidthInteger
{
    // -------------------------------------
    /// Fast creation of an integer from a Bool
    @usableFromInline @inline(__always) init(_ source: Bool)
    {
        assert(unsafeBitCast(source, to: UInt8.self) & 0xfe == 0)
        self.init(unsafeBitCast(source, to: UInt8.self))
    }
}

// -------------------------------------
/**
 Subtract two `UInt64`s, `x`, and `y`, storing the result back to
 `y`. (ie. `x -= y`)
 
 - Parameters:
    - x: The minuend and recipient of the resulting difference.
    - y: The subtrahend
 
 - Returns: Borrow out of the difference.
 */
internal func subtractReportingBorrow(_ x: inout UInt64, _ y: UInt64) -> UInt64
{
    let b: Bool
    (x, b) = x.subtractingReportingOverflow(y)
    return UInt64(b)
}

// -------------------------------------
/**
 Add two `UInt64`s, `x`, and `y`, storing the result back to `x`.
 (ie. `x += y`)
 
 - Parameters:
    - x: The first addend and recipient of the resulting sum.
    - y: The second addend
 
 - Returns: Carry out of the sum.
 */
internal func addReportingCarry(_ x: inout UInt64, _ y: UInt64) -> UInt64
{
    let c: Bool
    (x, c) = x.addingReportingOverflow(y)
    return UInt64(c)
}

// -------------------------------------
/**
 Compute `y = y - x * k`
 
 - Parameters:
    - x: A multiprecision number with the least signficant limb
        stored at index 0 (ie. little endian).  It is multiplied by the "limb",
        `k`, with the resulting product being subtracted from `y`
    - k: Scalar multiple to apply to `x` prior to subtraction
    - y: Both the number being subtracted from, and the storage for the result,
        represented as a collection of limbs with the least signficant limbs
        at index 0.
 
 - Returns: The borrow out of the most signficant limb of `y`.
 */
internal func subtractReportingBorrow(
    _ x: Limbs.SubSequence,
    times k: UInt64,
    from y: inout Limbs.SubSequence) -> Bool
{
    assert(x.count + 1 <= y.count)
    
    var i = x.startIndex
    var j = y.startIndex

    var borrow: UInt64 = 0
    while i < x.endIndex
    {
        borrow = subtractReportingBorrow(&y[j], borrow)
        let (pHi, pLo) = k.multipliedFullWidth(by: x[i])
        borrow &+= pHi
        borrow &+= subtractReportingBorrow(&y[j], pLo)
        
        i &+= 1
        j &+= 1
    }
    
    return 0 != subtractReportingBorrow(&y[j], borrow)
}

// -------------------------------------
/**
 Add two multiprecision numbers.
 
 - Parameters:
    - x: The first addend as a collection limbs with the least signficant
        limb at index 0 (ie. little endian).
    - y: The second addend and the storage for the resulting sum as a
        collection of limbs with the the least signficant limb at index 0
        (ie. little endian).
 */
internal func += (left: inout Limbs.SubSequence, right: Limbs.SubSequence)
{
    assert(right.count + 1 == left.count)
    var carry: UInt64 = 0
    
    var i = right.startIndex
    var j = left.startIndex
    while i < right.endIndex
    {
        carry = addReportingCarry(&left[j], carry)
        carry &+= addReportingCarry(&left[j], right[i])
        
        i &+= 1
        j &+= 1
    }
    
    left[j] &+= carry
}

// -------------------------------------
/**
 Shift the multiprecision unsigned integer, `x`, left by `shift` bits.
 
 - Parameters:
    - x: The mutliprecision unsigned integer to be left-shfited, stored as a
        collection of limbs with the least signficant limb stored at index 0.
        (ie. little endian)
    - shift: the number of bits to shift `x` by.
    - y: Storage for the resulting shift of `x`.  May alias `x`.
 */
internal func leftShift(_ x: Limbs, by shift: Int, into y: inout Limbs)
{
    assert(y.count >= x.count)
    assert(y.startIndex == x.startIndex)
    
    let bitWidth = UInt64.bitWidth

    for i in (1..<x.count).reversed() {
        y[i] = (x[i] << shift) | (x[i - 1] >> (bitWidth - shift))
    }
    y[0] = x[0] << shift
}

// -------------------------------------
/**
 Shift the multiprecision unsigned integer,`x`, right by `shift` bits.
 
 - Parameters:
    - x: The mutliprecision unsigned integer to be right-shfited, stored as a
        collection of limbs with the least signficant limb stored at index 0.
        (ie. little endian)
    - shift: the number of bits to shift `x` by.
    - y: Storage for the resulting shift of `x`.  May alias `x`.
 */
internal func rightShift(_ x: inout Limbs.SubSequence, by shift: Int)
{
    let bitWidth = UInt64.bitWidth
    
    let lastElemIndex = x.count - 1
    for i in 0..<lastElemIndex {
        x[i] = (x[i] >> shift) | (x[i + 1] << (bitWidth - shift))
    }
    x[lastElemIndex] = x[lastElemIndex] >> shift
}

// -------------------------------------
/**
 Divide the multiprecision number stored in `x`, by the "limb",`y.`
 
 - Parameters:
    - x: The dividend as a multiprecision number with the least signficant limb
        stored at index 0 (ie. little endian).
    - y: The single limb divisor (where limb is the same radix as limbs of
        `x`).
    - z: storage to receive the quotient on exit.  Must be same size as `x`

- Returns: A single limb remainder.
 */
internal func divide(_ x: Limbs, by y: UInt64, result z: inout Limbs) -> UInt64
{
    assert(x.count == z.count)
    assert(x.startIndex == z.startIndex)
    
    var r: UInt64 = 0
    var i = x.count - 1
    
    (z[i], r) = x[i].quotientAndRemainder(dividingBy: y)
    i -= 1
    
    while i >= 0
    {
        (z[i], r) = y.dividingFullWidth((r, x[i]))
        i -= 1
    }
    return r
}

// MARK:- Tuple Arithmetic Operations
/*
The operators in this file implement the tuple operations for the 2-limb
arithmetic needed for Knuth's Algorithm D, and *only* those operations.
There is no attempt to be a complete set. They are meant to make the code that
uses them more readable than if the operations they express were written out
directly.
*/

// -------------------------------------
/// Multiply a tuple of limbs by 1 limb
internal func * (left: (high: UInt64, low: UInt64), right: UInt64)
    -> (high: UInt64, low: UInt64)
{
    var product = left.low.multipliedFullWidth(by: right)
    let productHigh = left.high.multipliedFullWidth(by: right)
    assert(productHigh.high == 0, "multiplication overflow")
    let c = addReportingCarry(&product.high, productHigh.low)
    assert(c == 0, "multiplication overflow")
    
    return product
}

infix operator /% : MultiplicationPrecedence

// -------------------------------------
/// Divide a tuple of limbs by 1 limb obtaining both quotient and remainder
internal func /% (left: (high: UInt64, low: UInt64), right: UInt64)
    -> (
        quotient: (high: UInt64, low: UInt64),
        remainder: (high: UInt64, low: UInt64)
    )
{
    var r: UInt64
    let q: (high: UInt64, low: UInt64)
    (q.high, r) = left.high.quotientAndRemainder(dividingBy: right)
    (q.low, r) = right.dividingFullWidth((high: r, low: left.low))
    
    return (q, (high: 0, low: r))
}

// -------------------------------------
/**
 Tests if  the typle, `left`, is greater than tuple, `right`.
 
 - Returns: `UInt8` that has the value of 1 if `left` is greater than right;
    otherwise, 0.  This is done in place of returning a boolean as part of an
    optimization to avoid hidden conditional branches in boolean expressions.
 */

internal func > (
    left: (high: UInt64, low: UInt64),
    right: (high: UInt64, low: UInt64)) -> UInt8
{
    return UInt8(left.high > right.high)
        | (UInt8(left.high == right.high) & UInt8(left.low > right.low))
}

// -------------------------------------
/// Add a limb to a tuple's low part, carrying to the high part.
internal func += (left: inout (high: UInt64, low: UInt64), right: UInt64) {
    left.high &+= addReportingCarry(&left.low, right)
}

// -------------------------------------
/// Add one tuple to another tuple
internal func += (
    left: inout (high: UInt64, low: UInt64),
    right: (high: UInt64, low: UInt64))
{
    left.high &+= addReportingCarry(&left.low, right.low)
    left.high &+= right.high
}

// -------------------------------------
/// Subtract a limb from a tuple, borrowing the high part if necessary
internal func -= (left: inout (high: UInt64, low: UInt64), right: UInt64) {
    left.high &-= subtractReportingBorrow(&left.low, right)
}

// -------------------------------------
internal func sameResultsAsShiftSubtract(
    dividend: Limbs,
    divisor: Limbs,
    quotient: Limbs,
    remainder: Limbs) -> Bool
{
    #if DEBUG
    func divMod_ShiftSubtract(_ dividend: Limbs, _ divisor: Limbs) -> (quotient: Limbs, remainder: Limbs)
    {
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
    
    let (q2, r2) = divMod_ShiftSubtract(dividend, divisor)
    
    return quotient == q2 && remainder == r2
    #endif
}
