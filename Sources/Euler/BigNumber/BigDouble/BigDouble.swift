//
//  BigDouble.swift
//  
//
//  Created by Arthur Guiot on 2019-12-07.
//

import Foundation

//
//
//    MARK: - BigDouble
//    ————————————————————————————————————————————————————————————————————————————————————————————
//    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ||||||||        BigDouble        |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ————————————————————————————————————————————————————————————————————————————————————————————
//
//
//
public struct BigDouble:
    ExpressibleByIntegerLiteral,
    ExpressibleByFloatLiteral,
    CustomStringConvertible,
    SignedNumeric,
    Comparable,
    Hashable
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
    
    var sign = Bool()
    var numerator = Limbs()
    var denominator = Limbs()
    
    public typealias Magnitude = Double
    public var magnitude: Double = 0.0
    
    //
    //
    //    MARK: - Initializers
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        Initializers        ||||||||||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    public init?<T>(exactly source: T) where T : BinaryInteger {
        let i = BigInt(source)
        self.init(i)
    }
    
    public init(_ src: BigInt) {
        self.init(src, over: BigInt(1))
    }
    
    /**
     Inits a BigDouble with two Limbs as numerator and denominator
     
     - Parameters:
     - numerator: The upper part of the fraction as Limbs
     - denominator: The lower part of the fraction as Limbs
     
     Returns: A new BigDouble
     */
    public init(sign: Bool, numerator: Limbs, denominator: Limbs) {
        precondition(
            !denominator.equalTo(0) && denominator != [] && numerator != [],
            "Denominator can't be zero and limbs can't be []"
        )
        
        self.sign = sign
        self.numerator = numerator
        self.denominator = denominator
        
        self.minimize()
    }
    
    public init(_ numerator: BigInt, over denominator: BigInt) {
        self.init(
            sign:            numerator.sign != denominator.sign,
            numerator:        numerator.limbs,
            denominator:    denominator.limbs
        )
    }
    
    public init(_ numerator: Int, over denominator: Int) {
        self.init(
            sign: (numerator < 0) != (denominator < 0),
            numerator: [UInt64(abs(numerator))],
            denominator: [UInt64(abs(denominator))]
        )
    }
    
    public init?(_ numerator: String, over denominator: String) {
        if let n = BigInt(numerator) {
            if let d = BigInt(denominator) {
                self.init(n, over: d)
                return
            }
        }
        return nil
    }
    
    public init?(_ nStr: String) {
        if let bi = BigInt(nStr) {
            self.init(bi, over: 1)
        } else {
            if let exp = nStr.firstIndex(of: "e")?.utf16Offset(in: nStr) {
                let beforeExp = String(Array(nStr)[..<exp].filter{ $0 != "." })
                var afterExp = String(Array(nStr)[(exp + 1)...])
                var sign = false
                
                if let neg = afterExp.firstIndex(of: "-")?.utf16Offset(in: afterExp) {
                    afterExp = String(Array(afterExp)[(neg + 1)...])
                    sign = true
                }
                
                if sign {
                    if var safeAfterExp = Int(afterExp) {
                        if beforeExp.starts(with: "+") || beforeExp.starts(with: "-") {
                            safeAfterExp = safeAfterExp - beforeExp.count + 2
                        } else {
                            safeAfterExp = safeAfterExp - beforeExp.count + 1
                        }
                        guard safeAfterExp > 0 else { return nil }
                        let den = ["1"] + [Character](repeating: "0", count: safeAfterExp)
                        self.init(beforeExp, over: String(den))
                        return
                    }
                    return nil
                } else {
                    if var safeAfterExp = Int(afterExp) {
                        if beforeExp.starts(with: "+") || beforeExp.starts(with: "-") {
                            safeAfterExp = safeAfterExp - beforeExp.count + 2
                        } else {
                            safeAfterExp = safeAfterExp - beforeExp.count + 1
                        }
                        let num = beforeExp + String([Character](repeating: "0", count: safeAfterExp))
                        self.init(num, over: "1")
                        return
                    }
                    return nil
                }
            }
            
            if let io = nStr.firstIndex(of: ".") {
                let beforePoint = String(nStr[..<io])
                let afterPoint  = String(nStr[nStr.index(io, offsetBy: 1)...])
                
                if afterPoint == "0" {
                    self.init(beforePoint, over: "1")
                }
                else {
                    let den = ["1"] + [Character](repeating: "0", count: afterPoint.count)
                    self.init(beforePoint + afterPoint, over: String(den))
                }
            } else {
                return nil
            }
        }
    }
    
    /// Create an instance initialized to a string with the value of mathematical numerical system of the specified radix (base).
    /// So for example, to get the value of hexadecimal string radix value must be set to 16.
    public init?(_ nStr: String, radix: Int) {
        if radix == 10 {
            // regular string init is faster
            // see metrics
            self.init(nStr)
            return
        }
        
        var useString = nStr
        if radix == 16 {
            if useString.hasPrefix("0x") {
                useString = String(nStr.dropFirst(2))
            }
        }
        
        if radix == 8 {
            if useString.hasPrefix("0o") {
                useString = String(nStr.dropFirst(2))
            }
        }
        
        if radix == 2 {
            if useString.hasPrefix("0b") {
                useString = String(nStr.dropFirst(2))
            }
        }
        
        let BigNumber16 = BigDouble(radix)
        
        var total = BigDouble(0)
        var exp = BigDouble(1)
        
        for c in useString.reversed() {
            let int = Int(String(c), radix: radix)
            if int != nil {
                let value =  BigDouble(int!)
                total = total + (value * exp)
                exp = exp * BigNumber16
            } else {
                return nil
            }
        }
        
        self.init(String(describing:total))
        
    }
    
    public init(_ z: Int) {
        self.init(z, over: 1)
    }
    
    public init(_ d: Double, withPrecision eps: Double = 1.0E-15) {
        var x = d
        var a = floor(x)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)

        while x - a > eps * Double(k) * Double(k) {
            x = 1.0/(x - a)
            a = floor(x)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        self.init(h, over: k)
    }
    
    public init(integerLiteral value: Int) {
        self.init(value)
    }
    public init(floatLiteral value: Double) {
        self.init(value)
    }
    
    public init(constant: Constant) {
        self.init(constant.rawValue)!
    }
    //
    //
    //    MARK: - Descriptions
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        Descriptions        ||||||||||||||||||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    
    /**
     * returns the current value in a fraction format
     */
    public var description: String {
        return self.fractionDescription
    }
    
    /**
     * returns the current value in a fraction format
     */
    public var fractionDescription : String {
        var res = (self.sign ? "-" : "")
        
        res.append(self.numerator.decimalRepresentation)
        
        if self.denominator != [1] {
            res.append("/".appending(self.denominator.decimalRepresentation))
        }
        
        return res
    }
    
    static private var _precision = 4
    /**
     * the global percision for all newly created values
     */
    static public var precision : Int {
        get {
            return _precision
        } set {
            var nv = newValue
            if nv < 0 {
                nv = 0
            }
            _precision = nv
        }
    }
    private var _precision : Int = BigDouble.precision
    
    /**
     * the precision for the current value
     */
    public var precision : Int {
        get
        {
            return _precision
        }
        set
        {
            var nv = newValue
            if nv < 0 {
                nv = 0
            }
            _precision = nv
        }
    }
    
    /**
     * returns the current value in decimal format with the current precision
     */
    public var decimalDescription : String {
        return self.decimalExpansion(precisionAfterDecimalPoint: self.precision)
    }
    
    /**
     Returns the current value in decimal format (always with a decimal point).
     - parameter precision: the precision after the decimal point
     - parameter rounded: whether or not the return value's last digit will be rounded up
     */
    public func decimalExpansion(precisionAfterDecimalPoint precision: Int, rounded : Bool = true) -> String {
        var currentPrecision = precision
        
        if(rounded && precision > 0) {
            currentPrecision = currentPrecision + 1
        }
        
        let multiplier = [10].exponentiating(currentPrecision)
        let limbs = self.numerator.multiplyingBy(multiplier).divMod(self.denominator).quotient
        var res = BigInt(limbs: limbs).description
        
        if currentPrecision <= res.count {
            res.insert(".", at: res.index(res.startIndex, offsetBy: res.count - currentPrecision))
            if res.hasPrefix(".") { res = "0" + res }
            else if res.hasSuffix(".") { res += "0" }
        } else {
            res = "0." + String(repeating: "0", count: currentPrecision - res.count) + res
        }
        
        var retVal = self.isNegative() && !limbs.equalTo(0) ? "-" + res : res
        
        if(rounded && precision > 0) {
            
            let lastDigit = Int(retVal.suffix(1))! // this should always be a number
            let secondDigit = retVal.suffix(2).prefix(1) // this could be a decimal
            
            retVal = String(retVal.prefix(retVal.count-2))
            if (secondDigit != ".") {
                if lastDigit >= 5 {
                    retVal = retVal + String(Int(secondDigit)! + 1)
                } else {
                    retVal = retVal + String(Int(secondDigit)!)
                }
            } else {
                retVal = retVal + "." + String(lastDigit)
            }
        }
        
        return retVal
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine("\(self.sign)\(self.numerator)\(self.denominator)")
    }
    
    /**
     * Returns the size of the BigDouble in bits.
     */
    public var size: Int {
        return 1 + ((self.numerator.count + self.denominator.count) * MemoryLayout<Limb>.size * 8)
    }
    
    /**
     * Returns a formated human readable string that says how much space
     * (in bytes, kilobytes, megabytes, or gigabytes) the BigDouble occupies
     */
    public var sizeDescription: String {
        // One bit for the sign, plus the size of the numerator and denominator.
        let bits = self.size
        
        if bits < 8_000 {
            return String(format: "%.1f b", Double(bits) / 8.0)
        }
        if bits < 8_000_000 {
            return String(format: "%.1f kb", Double(bits) / 8_000.0)
        }
        if UInt64(bits) < UInt64(8_000_000_000.0) {
            return String(format: "%.1f mb", Double(bits) / 8_000_000.0)
        }
        return String(format: "%.1f gb", Double(bits) / 8_000_000_000.0)
    }
    
    public func rawData() -> (sign: Bool, numerator: [UInt64], denominator: [UInt64]) {
        return (self.sign, self.numerator, self.denominator)
    }
    
    /**
     * - returns: `True` if positive, `False` otherwise
     */
    public func isPositive() -> Bool { return !self.sign }
    /**
     * - returns: `True` if negative, `False` otherwise
     */
    public func isNegative() -> Bool { return self.sign }
    /**
     * - returns: `True` if 0, `False` otherwise
     */
    public func isZero() -> Bool { return self.numerator.equalTo(0) }
    
    public mutating func minimize() {
        if self.numerator.equalTo(0)
        {
            self.denominator = [1]
            return
        }
        
        let gcd = steinGcd(self.numerator, self.denominator)
        
        if gcd[0] > 1 || gcd.count > 1
        {
            self.numerator = self.numerator.divMod(gcd).quotient
            self.denominator = self.denominator.divMod(gcd).quotient
        }
    }
    
    /**
     * If the right side of the decimal is greater than 0.5 then it will round up (ceil),
     * otherwise round down (floor) to the nearest BigNumber
     */
    public func rounded() -> BigInt {
        if self.isZero() {
            return BigInt(0)
        }
        let digits = 3
        let multiplier = [10].exponentiating(digits)
        
        let rawRes = abs(self).numerator.multiplyingBy(multiplier).divMod(self.denominator).quotient
        
        let res = BigInt(limbs: rawRes).description
        
        let offset = res.count - digits
        let rhs = Double("0." + res.suffix(res.count - offset))!
        let lhs = res.prefix(offset)
        var retVal = BigInt(String(lhs))!
        
        if self.isNegative()
        {
            retVal = -retVal
            if rhs > 0.5 {
                retVal = retVal - BigInt(1)
            }
        } else {
            if rhs > 0.5
            {
                retVal = retVal + 1
            }
        }
        
        return retVal
    }
    
    /**
     * The power of 1/root
     *
     * - warning: This may take a while. This is only precise up until precision. When comparing results after this function ` use` nearlyEqual`
     */
    public func nthroot(_ root: Int) -> BigDouble {
        return self ** BigDouble(BigInt(1), over: BigInt(root))
    }
    
    /**
     * The square root
     *
     * - warning: This may take a while. This is only precise up until precision. When comparing results after this function ` use` nearlyEqual`
     */
    public func squareRoot() -> BigDouble {
        return self ** BigDouble(BigInt(1), over: BigInt(2))
    }
    
    /// Returns BigNumber's value as an integer. Conversion only works when self has only one limb
    /// that's within the range of the type "Int".
    public func asDouble(precision: BigInt = 10) -> Double? {
        let powed = self * 10 ** precision
        let rounded = powed.rounded()
        guard let integer = rounded.asInt() else { return nil }
        guard let pre = precision.asInt() else { return nil }
        let double = Double(integer) / pow(10, Double(pre))
        return double
    }
}
