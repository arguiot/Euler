//
//  BigNumber.swift
//  BigNumber
//
//  Created by Arthur Guiot on 2019-12-04.
//  Copyright © 2019 Euler. All rights reserved.
//
//    ——————————————————————————————————————————— v1.0 ———————————————————————————————————————————
//    - Initial Release.
//
//    ——————————————————————————————————————————— v1.1 ———————————————————————————————————————————
//    - Improved String conversion, now about 45x faster, uses base 10^9 instead
//    of base 10.
//    - bytes renamed to limbs.
//    - Uses typealias for limbs and digits.
//
//    ——————————————————————————————————————————— v1.2 ———————————————————————————————————————————
//    - Improved String conversion, now about 10x faster, switched from base 10^9
//    to 10^18 (biggest possible decimal base).
//    - Implemented karatsuba multiplication algorithm, about 5x faster than the
//    previous algorithm.
//    - Addition is 1.3x faster.
//    - Addtiton and subtraction omit trailing zeros, algorithms need less
//    operations now.
//    - Implemented exponentiation by squaring.
//    - New storage (BStorage) for often used results.
//    - Uses uint_fast64_t instead of UInt64 for Limbs and Digits.
//
//    ——————————————————————————————————————————— v1.3 ———————————————————————————————————————————
//    - Huge Perfomance increase by skipping padding zeros and new multiplication
//    algotithms.
//    - Printing is now about 10x faster, now on par with GMP.
//    - Some operations now use multiple cores.
//
//    ——————————————————————————————————————————— v1.4 ———————————————————————————————————————————
//    - Reduced copying by using more pointers.
//    - Multiplication is about 50% faster.
//    - String to BigNumber conversion is 2x faster.
//    - BigNumber to String also performs 50% better.
//
//    ——————————————————————————————————————————— v1.5 ———————————————————————————————————————————
//    - Updated for full Swift 3 compatibility.
//    - Various optimizations:
//        - Multiplication is about 2x faster.
//        - BigNumber to String conversion is more than 3x faster.
//        - String to BigNumber conversion is more than 2x faster.
//
//    ——————————————————————————————————————————— v1.6 ———————————————————————————————————————————
//    - Code refactored into modules.
//    - Renamed the project to SMP (Swift Multiple Precision).
//    - Added arbitrary base conversion.
//
//    ——————————————————————————————————————————— v2.0 ———————————————————————————————————————————
//    - Updated for full Swift 4 compatibility.
//    - Big refactor, countless optimizations for even better performance.
//    - BigNumber conforms to SignedNumeric and BinaryInteger, this makes it very easy to write
//      generic code.
//    - BigDouble also conforms to SignedNumeric and has new functionalities.
//
//
//
//    ————————————————————————————————————————————————————————————————————————————————————————————
//    ||||||||||||||||                         Evolution                          ||||||||||||||||
//    ————————————————————————————————————————————————————————————————————————————————————————————
//
//
//
//    Planned features of BigNumber v3.0:
//    - Implement some basic cryptography functions.
//    - General code cleanup, better documentation.
//    - More extensive tests.
//    - Please contact me if you have any suggestions for new features!
//
//
//
//    ————————————————————————————————————————————————————————————————————————————————————————————
//    ||||||||||||||||              Basic Project syntax conventions              ||||||||||||||||
//    ————————————————————————————————————————————————————————————————————————————————————————————
//
//    Indentation: Tabs
//
//    Align: Spaces
//
//    Style: allman
//    func foo(...)
//    {
//        ...
//    }
//
//    Single line if-statement:
//    if condition { code }
//
//    Maximum line length: 96 characters
//
//    ————————————————————————————————————————————————————————————————————————————————————————————
//    MARK: - Imports
//    ————————————————————————————————————————————————————————————————————————————————————————————
//    ||||||||        Imports        |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ————————————————————————————————————————————————————————————————————————————————————————————

import Foundation

//    MARK: - Typealiases
//    ————————————————————————————————————————————————————————————————————————————————————————————
//    ||||||||        Typealiases        |||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ————————————————————————————————————————————————————————————————————————————————————————————

///    Limbs are basically single Digits in base 2^64. Each slot in an Limbs array stores one
///    Digit of the number. The least significant digit is stored at index 0, the most significant
///    digit is stored at the last index.
public typealias Limbs  = [UInt64]
/// Single limb
public typealias Limb   =  UInt64

///    A digit is a number in base 10^18. This is the biggest possible base that
///    fits into an unsigned 64 bit number while maintaining the propery that the square root of
///    the base is a whole number and a power of ten . Digits are required for printing BigNumber
///    numbers. Limbs are converted into Digits first, and then printed.
public typealias Digits = [UInt64]
/// Single digit
public typealias Digit  =  UInt64

//    MARK: - Imports
//    ————————————————————————————————————————————————————————————————————————————————————————————
//    ||||||||        Operators        |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ————————————————————————————————————————————————————————————————————————————————————————————

precedencegroup ExponentiationPrecedence {
    associativity: left
    higherThan: MultiplicationPrecedence
    lowerThan: BitwiseShiftPrecedence
}

// Exponentiation operator
infix operator ** : ExponentiationPrecedence

//    MARK: - BigNumber
//    ————————————————————————————————————————————————————————————————————————————————————————————
//    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ||||||||        BigNumber        |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ————————————————————————————————————————————————————————————————————————————————————————————
///    BigNumber is an arbitrary precision integer value type. It stores a number in base 2^64 notation
///    as an array.
///
///    Each element of the array is called a limb, which is of type UInt64, the whole
///    array is called limbs and has the type [UInt64]. A boolean sign variable determines if the
///    number is positive or negative. If sign == true, then the number is smaller than 0,
///    otherwise it is greater or equal to 0. It stores the 64 bit digits in little endian, that
///    is, the least significant digit is stored in the array index 0:
///
///        limbs == [] := undefined, should throw an error
///        limbs == [0], sign == false := 0, defined as positive
///        limbs == [0], sign == true := undefined, should throw an error
///        limbs == [n] := n if sign == false, otherwise -n, given 0 <= n < 2^64
///
///        limbs == [l0, l1, l2, ..., ln] :=
///        (l0 * 2^(0*64)) +
///        (11 * 2^(1*64)) +
///        (12 * 2^(2*64)) +
///        ... +
///        (ln * 2^(n*64))
public struct BigInt:
    SignedNumeric, // Implies Numeric, Equatable, ExpressibleByIntegerLiteral
    BinaryInteger, // Implies Hashable, CustomStringConvertible, Strideable, Comparable
    ExpressibleByFloatLiteral
{
    //
    //
    //    MARK: - Internal data
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        Internal data        |||||||||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    /// Stores the sign of the number represented by the BigNumber. "true" means that the number is
    /// less than zero, "false" means it's more than or equal to zero.
    internal var sign  = false
    /// Stores the absolute value of the number represented by the BigNumber. Each element represents
    /// a "digit" of the number in base 2^64 in an acending order, where the first element is
    /// the least significant "digit". This representations is the most efficient one for
    /// computations, however it also means that the number is stored in a non-human-readable
    /// fashion. To make it readable as a decimal number, BigNumber offers the required functions.
    internal var limbs = Limbs()
    
    // Required by the protocol "Numeric".
    public typealias Magnitude = UInt64
    
    // Required by the protocol "Numeric". It's pretty useless because the magnitude of a BigNumber won't
    // fit into a UInt64 generally, so we just return the first limb of the BigNumber.
    public var magnitude: UInt64
    {
        return self.limbs[0]
    }
    
    // Required by the protocol "BinaryInteger".
    public typealias Words = [UInt]
    
    // Required by the protocol "BinaryInteger".
    public var words: BigInt.Words
    {
        return self.limbs.map{ UInt($0) }
    }
    
    /// Returns the size of the BigNumber in bits.
    public var size: Int
    {
        return 1 + (self.limbs.count * MemoryLayout<Limb>.size * 8)
    }
    
    /// Returns a formated human readable string that says how much space (in bytes, kilobytes, megabytes, or gigabytes) the BigNumber occupies.
    public var sizeDescription: String
    {
        // One bit for the sign, plus the size of the limbs.
        let bits = self.size
        
        if bits < 8_000
        {
            return String(format: "%.1f b", Double(bits) / 8.0)
        }
        if bits < 8_000_000
        {
            return String(format: "%.1f kb", Double(bits) / 8_000.0)
        }
        if UInt64(bits) < UInt64(8_000_000_000.0)
        {
            return String(format: "%.1f mb", Double(bits) / 8_000_000.0)
        }
        return String(format: "%.1f gb", Double(bits) / 8_000_000_000.0)
    }
    
    //
    //
    //    MARK: - Initializers
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        Initializers        ||||||||||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    ///    Root initializer for all other initializers. Because no sign is provided, the new
    ///    instance is positive by definition.
    internal init(limbs: Limbs)
    {
        precondition(limbs != [], "BigNumber can't be initialized with limbs == []")
        self.limbs = limbs
    }
    
    /// Create an instance initialized with a sign and a limbs array.
    internal init(sign: Bool, limbs: Limbs)
    {
        self.init(limbs: limbs)
        self.sign = sign
    }
    
    /// Create an instance initialized with the value 0.
    init()
    {
        self.init(limbs: [0])
    }
    
    /// Create an instance initialized to an integer value.
    public init(_ z: Int)
    {
        //    Since abs(Int.min) > Int.max, it is necessary to handle
        //    z == Int.min as a special case.
        if z == Int.min
        {
            self.init(sign: true, limbs: [Limb(Int.max) + 1])
            return
        }
        else
        {
            self.init(sign: z < 0, limbs: [Limb(abs(z))])
        }
    }
    
    /// Create an instance initialized to an unsigned integer value.
    public init(_ n: UInt)
    {
        self.init(limbs: [Limb(n)])
    }
    
    /// Create an instance initialized to a string value.
    public init?(_ str: String)
    {
        var (str, sign, base, limbs) = (str, false, [Limb(1)], [Limb(0)])
        
        limbs.reserveCapacity(Int(Double(str.count) / log10(pow(2.0, 64.0))))
        
        if str.hasPrefix("-")
        {
            str.remove(at: str.startIndex)
            sign = str != "0"
        }
        
        for chunk in String(str.reversed()).split(19).map({ String($0.reversed()) })
        {
            if let num = Limb(String(chunk))
            {
                limbs.addProductOf(multiplier: base, multiplicand: num)
                base = base.multiplyingBy([10_000_000_000_000_000_000])
            }
            else
            {
                return nil
            }
        }
        
        self.init(sign: sign, limbs: limbs)
    }
    
    /// Create an instance initialized to a string with the value of mathematical numerical
    /// system of the specified radix (base). So for example, to get the value of hexadecimal
    /// string radix value must be set to 16.
    public init?(_ number: String, radix: Int)
    {
        if radix == 10
        {
            // Regular string init is faster for decimal numbers.
            self.init(number)
            return
        }
        
        let chars: [Character] = [
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g",
            "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x",
            "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
            "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
        ]
        
        var (number, sign, base, limbs) = (number, false, [Limb(1)], [Limb(0)])
        
        if number.hasPrefix("-")
        {
            number.remove(at: number.startIndex)
            sign = number != "0"
        }
        
        for char in number.reversed()
        {
            if let digit = chars.firstIndex(of: char), digit < radix
            {
                limbs.addProductOf(multiplier: base, multiplicand: Limb(digit))
                base = base.multiplyingBy([Limb(radix)])
            }
            else
            {
                return nil
            }
        }
        
        self.init(sign: sign, limbs: limbs)
    }
    
    /// Create an instance initialized to a string with the value of mathematical numerical
    /// system of the specified radix (base). You have to specify the base as a prefix, so for
    /// example, "0b100101010101110" is a vaild input for a binary number. Currently,
    /// hexadecimal (0x), octal (0o) and binary (0b) are supported.
    public init?(prefixedNumber number: String)
    {
        if number.hasPrefix("0x")
        {
            self.init(String(number.dropFirst(2)), radix: 16)
        }
        if number.hasPrefix("0o")
        {
            self.init(String(number.dropFirst(2)), radix: 8)
        }
        if number.hasPrefix("0b")
        {
            self.init(String(number.dropFirst(2)), radix: 2)
        }
        else
        {
            return nil
        }
    }
    
    //    Requierd by protocol ExpressibleByFloatLiteral.
    public init(floatLiteral value: Double)
    {
        self.init(sign: value < 0.0, limbs: [Limb(value)])
    }
    
    //    Required by protocol ExpressibleByIntegerLiteral.
    public init(integerLiteral value: Int)
    {
        self.init(value)
    }
    
    // Required by protocol Numeric
    public init?<T>(exactly source: T) where T : BinaryInteger
    {
        self.init(Int(source))
    }
    
    ///    Creates an integer from the given floating-point value, rounding toward zero.
    public init<T>(_ source: T) where T : BinaryFloatingPoint
    {
        self.init(Int(source))
    }
    
    ///    Creates a new instance from the given integer.
    public init<T>(_ source: T) where T : BinaryInteger
    {
        self.init(Int(source))
    }
    
    ///    Creates a new instance with the representable value that’s closest to the given integer.
    public init<T>(clamping source: T) where T : BinaryInteger
    {
        self.init(Int(source))
    }
    
    ///    Creates an integer from the given floating-point value, if it can be represented
    ///    exactly.
    public init?<T>(exactly source: T) where T : BinaryFloatingPoint
    {
        self.init(source)
    }
    
    ///    Creates a new instance from the bit pattern of the given instance by sign-extending or
    ///    truncating to fit this type.
    public init<T>(truncatingIfNeeded source: T) where T : BinaryInteger
    {
        self.init(source)
    }
    
    //
    //
    //    MARK: - Struct functions
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        Struct functions        ||||||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    // Required by protocol CustomStringConvertible.
    public var description: String {
        return (self.sign ? "-" : "").appending(self.limbs.decimalRepresentation)
    }
    // Locale used to format numbers
    public var locale = Locale(identifier: "en_US")
    
    /**
     * returns the current value in scientific notation
     */
    public var scientificDescription: String {
        var d = self.limbs.decimalRepresentation
        let power = d.count - 1
        let precision = BN.precision
        if precision + 2 > d.count {
            d.append(String(repeating: "0", count: precision + 4 - d.count))
        }
        var significant = d.prefix(precision)
        let lasts = d.substring(with: Range(precision...precision + 2))
        let rounded = Int(round(Double(lasts)! / 100))
        significant.append(contentsOf: String(rounded))
        if significant.count > 1 {
            significant.insert(contentsOf: locale.decimalSeparator ?? ".", at: significant.index(after: significant.startIndex))
        }
        let str = exponentize(str: "\(significant)×10^\(power)")
        return (self.sign ? "-" : "").appending(str)
    }
    
    private func exponentize(str: String) -> String {
        let supers = [
            "0": "\u{2070}",
            "1": "\u{00B9}",
            "2": "\u{00B2}",
            "3": "\u{00B3}",
            "4": "\u{2074}",
            "5": "\u{2075}",
            "6": "\u{2076}",
            "7": "\u{2077}",
            "8": "\u{2078}",
            "9": "\u{2079}",
            "-": "\u{207B}"]
        
        var newStr = ""
        var isExp = false
        for (_, char) in str.enumerated() {
            if char == "^" {
                isExp = true
            } else {
                if isExp {
                    let key = String(char)
                    if supers.keys.contains(key) {
                        newStr.append(Character(supers[key]!))
                    } else {
                        isExp = false
                        newStr.append(char)
                    }
                } else {
                    newStr.append(char)
                }
            }
        }
        return newStr
    }
    
    /// Returns the BigNumber's value in the given base (radix) as a string.
    public func asString(radix: Int) -> String
    {
        let chars: [Character] = [
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g",
            "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x",
            "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
            "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
        ]
        
        var (limbs, res) = (self.limbs, "")
        
        while !limbs.equalTo(0)
        {
            let divmod = limbs.divMod([Limb(radix)])
            
            if let r = divmod.remainder.first, r < radix
            {
                res.append(chars[Int(r)])
                limbs = divmod.quotient
            }
            else
            {
                fatalError("BigNumber.asString: Base too big, should be between 2 and 62")
            }
        }
        
        if res == "" { return "0" }
        return (self.sign ? "-" : "").appending(String(res.reversed()))
    }
    
    ///    Returns BigNumber's value as an integer. Conversion only works when self has only one limb
    /// that's within the range of the type "Int".
    func asInt() -> Int?
    {
        if self.limbs.count != 1 { return nil }
        
        let number = self.limbs[0]
        
        if number <= Limb(Int.max)
        {
            return self.sign ? -Int(number) : Int(number)
        }
        
        if number == (Limb(Int.max) + 1) && self.sign
        {
            // This is a special case where self == Int.min
            return Int.min
        }
        
        return nil
    }
    
    var rawValue: (sign: Bool, limbs: [UInt64])
    {
        return (self.sign, self.limbs)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine("\(self.sign)\(self.limbs)")
    }
    
    // Required by the protocol "BinaryInteger". A Boolean value indicating whether this type is a
    // signed integer type.
    public static var isSigned: Bool
    {
        return true
    }
    
    // Required by the protocol "BinaryInteger". The number of bits in the current binary
    // representation of this value.
    public var bitWidth: Int
    {
        return self.limbs.bitWidth
    }
    
    
    ///    Returns -1 if this value is negative and 1 if it’s positive; otherwise, 0.
    public func signum() -> BigInt
    {
        if self.isZero() { return BigInt(0) }
        else if self.isPositive() { return BigInt(1) }
        else { return BigInt(-1) }
    }
    
    func isPositive() -> Bool { return !self.sign }
    func isNegative() -> Bool { return  self.sign }
    func isZero()     -> Bool { return self.limbs[0] == 0 && self.limbs.count == 1 }
    func isNotZero()  -> Bool { return self.limbs[0] != 0 || self.limbs.count >  1 }
    func isOdd()      -> Bool { return self.limbs[0] & 1 == 1 }
    func isEven()     -> Bool { return self.limbs[0] & 1 == 0 }
    
    ///    The number of trailing zeros in this value’s binary representation.
    public var trailingZeroBitCount: Int
    {
        var i = 0
        while true
        {
            if self.limbs.getBit(at: i) { return i }
            i += 1
        }
    }
}
