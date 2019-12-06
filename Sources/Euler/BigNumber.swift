//
//  BigNumber.swift
//  
//
//  Created by Arthur Guiot on 2019-12-04.
//
import Foundation

public class BigNumber: Equatable {
    
    /// See `BigNumber.config` (alias `BigNumber.set`) and `BigNumber.clone`
    struct Config {
        /**
        * An integer, 0 to 1e+9. Default value: 20.
        *
        * The maximum number of decimal places of the result of operations involving division, i.e.
        * division, square root and base conversion operations, and exponentiation when the exponent is
        * negative.
        *
        * ```swift
        * BigNumber.config({ DECIMAL_PLACES: 5 })
        * BigNumber.set({ DECIMAL_PLACES: 5 })
        * ```
        */
        var DECIMAL_PLACES = 20
        /**
        * The alphabet used for base conversion. The length of the alphabet corresponds to the maximum
        * value of the base argument that can be passed to the BigNumber constructor or `toString`.
        *
        * Default value: `'0123456789abcdefghijklmnopqrstuvwxyz'`.
        *
        * There is no maximum length for the alphabet, but it must be at least 2 characters long,
        * and it must not contain whitespace or a repeated character, or the sign indicators '+' and
        * '-', or the decimal separator '.'.
        *
        * ```ts
        * // duodecimal (base 12)
        * BigNumber.config({ ALPHABET: '0123456789TE' })
        * x = new BigNumber('T', 12)
        * x.toString()                // '10'
        * x.toString(12)              // 'T'
        * ```
        */
        var ALPHABET: String? = "0123456789abcdefghijklmnopqrstuvwxyz"
    }
    
    public var c = [Int]()
    public var e: Int
    public var s: Int
    public init(_ n: Int) {
        s = n / Swift.abs(n)
        var buffer = Double(Swift.abs(n))
        
        e = Int(log10(buffer).rounded(.towardZero))
        
        while buffer > 1e14 {
            buffer = buffer / 1e14
            let approx = buffer.rounded(.towardZero)
            c.insert(Int(approx), at: 0)
        }
        let approx = buffer.rounded(.towardZero)
        c.insert(Int(approx), at: 0)
    }
    public init(_ n: Float) {
        s = Int(n / fabsf(n))
        let integer = fabsf(n).rounded(.towardZero)
        let decimals = fabsf(n) - integer
        var buffer = integer - decimals
        
        e = Int(log10(buffer).rounded(.towardZero))
        
        while buffer > 1e14 {
            buffer = buffer / 1e14
            let approx = buffer.rounded(.towardZero)
            c.insert(Int(approx), at: 0)
        }
        let approx = buffer.rounded(.towardZero)
        c.insert(Int(approx), at: 0)
    }
    public init(_ n: Double) {
        s = Int(n / fabs(n))
        let integer = fabs(n).rounded(.towardZero)
        let decimals = Swift.abs(n) - integer
        var buffer = integer - decimals
        
        e = Int(log10(buffer).rounded(.towardZero))
        
        while buffer > 1e14 {
            buffer = buffer / 1e14
            let approx = buffer.rounded(.towardZero)
            c.insert(Int(approx), at: 0)
        }
        let approx = buffer.rounded(.towardZero)
        c.insert(Int(approx), at: 0)
    }
    
    
    /// Return a new BigNumber whose value is the absolute value of this BigNumber.
    public func abs() -> BigNumber {
        s = 1
        return self
    }
    
    public static func == (lhs: BigNumber, rhs: BigNumber) -> Bool {
        return lhs.c == rhs.c && lhs.e == rhs.e && lhs.s == rhs.s
    }
}
