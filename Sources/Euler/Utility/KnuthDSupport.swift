//
//  KnuthDSupport.swift
//  Euler
//
//  Created by Chip Jarred on 9/9/20.
//

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
 Subtract two `FixedWidthInteger`s, `x`, and `y`, storing the result back to
 `y`. (ie. `x -= y`)
 
 - Parameters:
    - x: The minuend and recipient of the resulting difference.
    - y: The subtrahend
 
 - Returns: Borrow out of the difference.
 */
@usableFromInline @inline(__always)
func subtractReportingBorrow<T: FixedWidthInteger>(_ x: inout T, _ y: T) -> T
{
    let b: Bool
    (x, b) = x.subtractingReportingOverflow(y)
    return T(b)
}

// -------------------------------------
/**
 Add two `FixedWidthInteger`s, `x`, and `y`, storing the result back to `x`.
 (ie. `x += y`)
 
 - Parameters:
    - x: The first addend and recipient of the resulting sum.
    - y: The second addend
 
 - Returns: Carry out of the sum.
 */
@usableFromInline @inline(__always)
func addReportingCarry<T: FixedWidthInteger>(_ x: inout T, _ y: T) -> T
{
    let c: Bool
    (x, c) = x.addingReportingOverflow(y)
    return T(c)
}

// -------------------------------------
/**
 Compute `y = y - x * k`
 
 - Parameters:
    - x: A multiprecision number with the least signficant digit
        stored at index 0 (ie. little endian).  It is multiplied by the "digit",
        `k`, with the resulting product being subtracted from `y`
    - k: Scalar multiple to apply to `x` prior to subtraction
    - y: Both the number being subtracted from, and the storage for the result,
        represented as a collection of digits with the least signficant digits
        at index 0.
 
 - Returns: The borrow out of the most signficant digit of `y`.
 */
@usableFromInline @inline(__always)
func subtractReportingBorrow<T, U>(
    _ x: T,
    times k: T.Element,
    from y: inout U) -> Bool
    where T: RandomAccessCollection,
    T.Element == UInt64,
    T.Element.Magnitude == T.Element,
    T.Index == Int,
    U: RandomAccessCollection,
    U: MutableCollection,
    U.Element == T.Element,
    U.Index == T.Index
{
    assert(x.count + 1 <= y.count)
    
    var i = x.startIndex
    var j = y.startIndex

    var borrow: T.Element = 0
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
    - x: The first addend as a collection digits with the least signficant
        digit at index 0 (ie. little endian).
    - y: The second addend and the storage for the resulting sum as a
        collection of digits with the the least signficant digit at index 0
        (ie. little endian).
 */
@usableFromInline @inline(__always)
func += <T, U>(left: inout U, right: T )
    where T: RandomAccessCollection,
    T.Element == UInt64,
    T.Index == Int,
    U: RandomAccessCollection,
    U: MutableCollection,
    U.Element == T.Element,
    U.Index == T.Index
{
    assert(right.count + 1 == left.count)
    var carry: T.Element = 0
    
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
        collection of digits with the least signficant digit stored at index 0.
        (ie. little endian)
    - shift: the number of bits to shift `x` by.
    - y: Storage for the resulting shift of `x`.  May alias `x`.
 */
@usableFromInline @inline(__always)
func leftShift<T, U>(_ x: T, by shift: Int, into y: inout U)
    where
    T: RandomAccessCollection,
    T.Element == UInt64,
    T.Index == Int,
    U: RandomAccessCollection,
    U: MutableCollection,
    U.Element == T.Element,
    U.Index == T.Index
{
    assert(y.count >= x.count)
    assert(y.startIndex == x.startIndex)
    
    let bitWidth = MemoryLayout<T.Element>.size * 8
    
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
        collection of digits with the least signficant digit stored at index 0.
        (ie. little endian)
    - shift: the number of bits to shift `x` by.
    - y: Storage for the resulting shift of `x`.  May alias `x`.
 */
@usableFromInline @inline(__always)
func rightShift<T, U>(_ x: T, by shift: Int, into y: inout U)
    where
    T: RandomAccessCollection,
    T.Element:BinaryInteger,
    T.Index == Int,
    U: RandomAccessCollection,
    U: MutableCollection,
    U.Element == T.Element,
    U.Index == T.Index
{
    assert(y.count == x.count)
    assert(y.startIndex == x.startIndex)
    let bitWidth = MemoryLayout<T.Element>.size * 8
    
    let lastElemIndex = x.count - 1
    for i in 0..<lastElemIndex {
        y[i] = (x[i] >> shift) | (x[i + 1] << (bitWidth - shift))
    }
    y[lastElemIndex] = x[lastElemIndex] >> shift
}

// -------------------------------------
/**
 Divide the multiprecision number stored in `x`, by the "digit",`y.`
 
 - Parameters:
    - x: The dividend as a multiprecision number with the least signficant digit
        stored at index 0 (ie. little endian).
    - y: The single digit divisor (where digit is the same radix as digits of
        `x`).
    - z: storage to receive the quotient on exit.  Must be same size as `x`

- Returns: A single digit remainder.
 */
@usableFromInline @inline(__always)
func divide<T, U>(_ x: T, by y: T.Element, result z: inout U) -> T.Element
    where T: RandomAccessCollection,
    T.Element == UInt64,
    T.Index == Int,
    U: RandomAccessCollection,
    U: MutableCollection,
    U.Element == T.Element,
    U.Index == T.Index
{
    assert(x.count == z.count)
    assert(x.startIndex == z.startIndex)
    
    var r: T.Element = 0
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
The operators in this file implement the tuple operations for the 2-digit
arithmetic needed for Knuth's Algorithm D, and *only* those operations.
There is no attempt to be a complete set. They are meant to make the code that
uses them more readable than if the operations they express were written out
directly.
*/

// -------------------------------------
/// Multiply a tuple of digits by 1 digit
@usableFromInline @inline(__always)
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
/// Divide a tuple of digits by 1 digit obtaining both quotient and remainder
@usableFromInline @inline(__always)
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

@usableFromInline @inline(__always)
internal func > (
    left: (high: UInt64, low: UInt64),
    right: (high: UInt64, low: UInt64)) -> UInt8
{
    return UInt8(left.high > right.high)
        | (UInt8(left.high == right.high) & UInt8(left.low > right.low))
}

// -------------------------------------
/// Add a digit to a tuple's low part, carrying to the high part.
@usableFromInline @inline(__always)
func += (left: inout (high: UInt64, low: UInt64), right: UInt64) {
    left.high &+= addReportingCarry(&left.low, right)
}

// -------------------------------------
/// Add one tuple to another tuple
@usableFromInline @inline(__always)
func += (
    left: inout (high: UInt64, low: UInt64),
    right: (high: UInt64, low: UInt64))
{
    left.high &+= addReportingCarry(&left.low, right.low)
    left.high &+= right.high
}

// -------------------------------------
/// Subtract a digit from a tuple, borrowing the high part if necessary
@usableFromInline @inline(__always)
func -= (left: inout (high: UInt64, low: UInt64), right: UInt64) {
    left.high &-= subtractReportingBorrow(&left.low, right)
}
