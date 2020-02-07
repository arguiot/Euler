//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-01-23.
//

import Foundation

public extension Tables {
    /// Absolute value of a number
    /// - Parameter number: A `BigDouble`
    func ABS(_ number: BigNumber) -> BigNumber {
        return abs(number)
    }
    
    /// Arc-Cosinus of a number.
    /// - Parameter number: Any `BigDouble` less than 2pi
    func ACOS(_ number: BigNumber) throws -> BigNumber {
        guard let double = number.asDouble() else { throw TablesError.Overflow }
        return BigDouble(acos(double))
    }
    /// Hyperbolic Arc-Cosinus of a number.
    /// - Parameter number: Any `BigDouble`
    func ACOSH(_ number: BigNumber) throws -> BigNumber {
        guard let double = number.asDouble() else { throw TablesError.Overflow }
        return BigDouble(acosh(double))
    }
    
    /// Arc-Cotangent of a number.
    /// - Parameter number: Any `BigDouble` less than 2pi
    func ACOT(_ number: BigNumber) throws -> BigNumber {
        let mod = number % (2 * BigDouble(constant: .pi))
        guard let double = mod.asDouble() else { throw TablesError.Overflow }
        return BigDouble(atan(1 / double))
    }
    
    /// Hyperbolic Arc-Cotangent of a number.
    /// - Parameter number: Any `BigDouble`
    func ACOTH(_ number: BigNumber) throws -> BigNumber {
        guard let double = number.asDouble() else { throw TablesError.Overflow }
        return BigDouble(0.5 * log(double + 1) / (double - 1))
    }
    
    // MARK: TODO: AGGREGATE + ARABIC
    
    /// Arc-Sinus of a number.
    /// - Parameter number: Any `BigDouble` less than 2pi
    func ASIN(_ number: BigNumber) throws -> BigNumber {
        let mod = number % (2 * BigDouble(constant: .pi))
        guard let double = mod.asDouble() else { throw TablesError.Overflow }
        return BigDouble(asin(double))
    }
    
    /// Hyperbolic Arc-Sinus of a number.
    /// - Parameter number: Any `BigDouble`
    func ASINH(_ number: BigNumber) throws -> BigNumber {
        guard let double = number.asDouble() else { throw TablesError.Overflow }
        return BigDouble(asinh(double))
    }
    /// Arc-Tangent of a number.
    /// - Parameter number: Any `BigDouble`
    func ATAN(_ number: BigNumber) throws -> BigNumber {
        guard let double = number.asDouble() else { throw TablesError.Overflow }
        return BigDouble(atan(double))
    }
    
    /// ATAN2(Y,X) returns the four-quadrant inverse tangent (tan-1) of Y and X, which must be real. The atan2 function follows the convention that atan2(x,x) returns 0 when x is mathematically zero (either 0 or -0).
    /// - Parameters:
    ///   - n1: X coordinate
    ///   - n2: Y coordinate
    func ATAN2(_ n1: BigNumber, _ n2: BigNumber) throws -> BigNumber {
        guard let d1 = n1.asDouble() else { throw TablesError.Overflow }
        guard let d2 = n2.asDouble() else { throw TablesError.Overflow }
        return BigDouble(atan2(d1, d2))
    }
    
    /// Hyperbolic Arc-Tangent of a number.
    /// - Parameter number: Any `BigDouble`
    func ATANH(_ number: BigNumber) throws -> BigNumber {
        guard let double = number.asDouble() else { throw TablesError.Overflow }
        return BigDouble(asinh(double))
    }
    
    /// Convert number to any base
    /// - Parameters:
    ///   - number: The number you want to use
    ///   - radix: The base / radix
    func BASE(_ number: BigInt, _ radix: BigInt) -> String {
        return number.asString(radix: radix.asInt() ?? 10)
    }
    
    /// Returns number rounded up, away from zero, to the nearest multiple of significance.
    ///
    /// For example, if you want to avoid using pennies in your prices and your product is priced at $4.42, use the formula `=CEILING(4.42,0.05)` to round prices up to the nearest nickel.
    /// - Parameters:
    ///     - number: The number you want to use
    ///     - significance: The multiple to which you want to round.
    ///     - mode: Either 0 or 1 (0 by default, flooring). It will choose between flooring or ceiling the number if it's negative.
    func CEILING(_ number: BigDouble, significance: BigDouble = 1, mode: Int = 0) -> BigDouble {
        if number.isPositive() {
            return ceil(number / significance) * significance
        }
        if mode == 0 {
            return -1 * floor(abs(number) / significance) * significance
        }
        return -1 * ceil(abs(number) / significance) * significance
    }
    
    /// Returns the number of combinations for a given number of items. Use COMBIN to determine the total possible number of groups for a given number of items.
    ///
    /// It uses combinations with repetitions: `n! / (k! * (n - k)!)`
    /// - Parameters:
    ///   - n: The number of items.
    ///   - k: The number of items in each combination.
    func COMBIN(_ n: BigInt, k: BigInt) throws -> BigInt {
        guard let ni = n.asInt() else { throw TablesError.Overflow }
        guard let ki = k.asInt() else { throw TablesError.Overflow }
        return combinations(ni, ki)
    }
    
    /// Returns the number of combinations (with repetitions) for a given number of items.
    ///
    /// It uses combinations with repetitions: `(n + k - 1)! / (k! * (n - 1)!)`
    /// - Parameters:
    ///   - n: The number of items.
    ///   - k: The number of items in each combination.
    func COMBINA(_ n: BigInt, k: BigInt) throws -> BigInt {
        guard let ni = n.asInt() else { throw TablesError.Overflow }
        guard let ki = k.asInt() else { throw TablesError.Overflow }
        return combinationsWithRepetitions(ni, ki)
    }
    
    /// Cosinus of a number.
    /// - Parameter number: Any `BigDouble` less than 2pi
    func COS(_ number: BigNumber) throws -> BigNumber {
        let mod = number % (2 * BigDouble(constant: .pi))
        guard let double = mod.asDouble() else { throw TablesError.Overflow }
        return BigDouble(cos(double))
    }
    
    /// Hyperbolic Cosinus of a number.
    /// - Parameter number: Any `BigDouble`
    func COSH(_ number: BigNumber) throws -> BigNumber {
        guard let double = number.asDouble() else { throw TablesError.Overflow }
        return BigDouble(cosh(double))
    }
    
    /// Cotangent of a number.
    /// - Parameter number: Any `BigDouble`
    func COT(_ number: BigNumber) throws -> BigNumber {
        guard let double = number.asDouble() else { throw TablesError.Overflow }
        return BigDouble(1) / BigDouble(tan(double))
    }
    
    /// Hyperbolic Cotangent of a number.
    /// - Parameter number: Any `BigDouble`
    func COTH(_ number: BigNumber) -> BigNumber {
        let e2 = exp(2 * number)
        
        return (e2 + 1) / (e2 - 1)
    }
    /// Cosecant of a number.
    /// - Parameter number: Any `BigDouble`
    func CSC(_ number: BigNumber) throws -> BigNumber {
        guard let double = number.asDouble() else { throw TablesError.Overflow }
        return BigDouble(1) / BigDouble(sin(double))
    }
    
    /// Hyperbolic Cosecant of a number.
    /// - Parameter number: Any `BigDouble`
    func CSCH(_ number: BigNumber) -> BigNumber {
        let e1 = exp(number)
        let e2 = exp(-number)
        return BigDouble(2) / (e1 - e2)
    }
    
    /// Converts a text representation of a number in a given base into a decimal number.
    /// - Parameters:
    ///   - str: Required
    ///   - radix: Radix must be an integer.
    func DECIMAL(_ str: String, _ radix: Int) -> BigNumber {
        return BigDouble(str, radix: radix) ?? 0
    }
    
    /// Converts radians into degrees.
    /// - Parameter rad: The angle in radians that you want to convert.
    func DEGREES(_ rad: BigDouble) -> BigNumber {
        let abs = rad * BigInt(180) / BigDouble(constant: .pi)
        let mod = abs % BigDouble(360)
        return mod
    }
    
    /// Returns number rounded up to the nearest even integer.
    ///
    /// You can use this function for processing items that come in twos. For example, a packing crate accepts rows of one or two items. The crate is full when the number of items, rounded up to the nearest two, matches the crate's capacity.
    /// - Parameter number: The value to round.
    func EVEN(_ number: BigDouble) -> BigInt {
        return CEILING(number, significance: -2, mode: 1).rounded()
    }
    
    /// Returns e raised to the power of number.
    /// The constant e equals 2.71828182845904, the base of the natural logarithm.
    /// - Parameter number: The exponent applied to the base e.
    func EXP(_ number: BigDouble) -> BigDouble {
        return exp(number)
    }
    
    /// Returns the factorial of a number. The factorial of a number is equal to `1*2*3*...*` number.
    ///
    ///
    /// - Parameter int: The nonnegative number for which you want the factorial. If number is not an integer, it is truncated.
    func FACT(_ int: BigInt) -> BigInt {
        return factorial(int)
    }
    /// Returns the double factorial of a number. The factorial of a number is equal to `1*2*3*...*` number.
    ///
    ///
    /// - Parameter int: The value for which to return the double factorial. If number is not an integer, it is truncated.
    func FACTDOUBLE(_ int: BigInt) -> BigInt {
        return factorial(factorial(int))
    }
    /// Rounds number down, toward zero, to the nearest multiple of significance.
    ///
    /// For example, if you want to avoid using pennies in your prices and your product is priced at $4.42, use the formula `=FLOOR(4.42,0.05)` to round prices up to the nearest nickel.
    /// - Parameters:
    ///     - number: The numeric value you want to round.
    ///     - significance: The multiple to which you want to round.
    ///     - mode: Either 0 or 1 (0 by default, ceiling). It will choose between flooring or ceiling the number if it's negative.
    func FLOOR(_ number: BigDouble, significance: BigDouble = 1, mode: Int = 0) -> BigDouble {
        if number.isPositive() {
            return floor(number / significance) * significance
        }
        if mode == 0 {
            return -1 * ceil(abs(number) / significance) * significance
        }
        return -1 * floor(abs(number) / significance) * significance
    }
    
    /// Returns the greatest common divisor of two or more integers.
    ///
    /// The greatest common divisor is the largest integer that divides both number1 and number2 without a remainder.
    /// - Parameter n: Number1 and 2 are required, subsequent numbers are optional. 1 to 255 values. If any value is not an integer, it is truncated.
    func GCD(_ n: BigInt...) throws -> BigInt {
        guard n.count >= 2 else { throw TablesError.Arguments }
        let r = n.reduce(n.first!) { (r, i) -> BigInt in
            return gcd(r, i)
        }
        return r
    }
    
    /// Rounds a number down to the nearest integer.
    /// - Parameter n: The real number you want to round down to an integer.
    func INT(_ n: BigDouble) -> BigInt {
        return FLOOR(n).rounded()
    }
    
    /// Returns the least common multiple of integers.
    /// The least common multiple is the smallest positive integer that is a multiple of all integer arguments number1, number2, and so on. Use LCM to add fractions with different denominators.
    ///
    /// - Parameter n: Number1 and 2 are required, subsequent numbers are optional. 1 to 255 values. If any value is not an integer, it is truncated.
    func LCM(_ n: BigInt...) throws -> BigInt {
        guard n.count >= 2 else { throw TablesError.Arguments }
        let r = n.reduce(n.first!) { (r, i) -> BigInt in
            return lcm(r, i)
        }
        return r
    }
    
    /// Returns the natural logarithm of a number. Natural logarithms are based on the constant e (2.71828182845904)
    ///
    /// LN is the inverse of the EXP function.
    /// - Parameter n: The positive real number for which you want the natural logarithm.
    func LN(_ n: BigDouble) -> BigDouble {
        if let a = n.asDouble() {
            return BigDouble(log(a))
        }
        return ln(n)
    }
    
    /// Returns the logarithm of a number to the base you specify.
    /// - Parameters:
    ///   - n: The positive real number for which you want the logarithm.
    ///   - base: The base of the logarithm. If base is omitted, it is assumed to be 10.
    func LOG(_ n: BigDouble, base: Int = 10) -> BigDouble {
        return LN(n) / LN(BigDouble(base))
    }
    /// Returns the logarithm base 10
    /// - Parameters:
    ///   - n: The positive real number for which you want the logarithm.
    func LOG10(_ n: BigDouble) -> BigDouble {
        return LOG(n)
    }
    // MARK: TODO MATRICES
    
    /// Returns the remainder after number is divided by divisor.
    ///
    /// The result has the same sign as divisor.
    /// - Parameters:
    ///   - a: The number for which you want to find the remainder.
    ///   - b: The number by which you want to divide number.
    func MOD(_ a: BigDouble, b: BigDouble) -> BigDouble {
        return a % b
    }
    
    /// Returns the ratio of the factorial of a sum of values to the product of factorials.
    /// - Parameter numbers: Number1 is required, subsequent numbers are optional. 1 to 255 values for which you want the multinomial.
    func MULTINOMIAL(_ numbers: BigInt...) -> BigDouble {
        let sum = numbers.reduce(BigInt.zero) { $0 + $1 }
        let upperFac = BigDouble(factorial(sum))
        let fac = BigDouble(numbers.reduce(BigInt.zero) { $0 + factorial($1) })
        let div = upperFac / fac
        return div
    }
    
    /// Returns number rounded up to the nearest odd integer.
    /// 
    /// Regardless of the sign of number, a value is rounded up when adjusted away from zero. If number is an odd integer, no rounding occurs.
    /// - Parameter n: The value to round.
    func ODD(_ n: BigDouble) -> BigInt {
        let r = ceil(abs(n))
        guard !r.isOdd() else { return BigInt(sign: n.sign, limbs: (r).limbs) }
        return BigInt(sign: n.sign, limbs: (r + 1).limbs)
    }
    
    /// Returns the mathematical constant
    ///
    /// Originally defined as the ratio of a circle’s circumference to its diameter, it now has various equivalent definitions and appears in many formulas in all areas of mathematics and physics. It is approximately equal to 3.14159. It has been represented by the Greek letter “π” since the mid-18th century, though it is also sometimes spelled out as “pi”. It is also called Archimedes’ constant.
    ///
    func PI() -> BigDouble {
        return pi
    }
    
    /// Returns the result of a number raised to a power.
    ///
    /// Let's say you want to calculate an extremely small tolerance level for a machined part or the vast distance between two galaxies. To raise a number to a power, use the POWER function.
    ///
    /// > The "^" operator can be used instead of POWER to indicate to what power the base number is to be raised, such as in 5^2.
    /// - Parameters:
    ///   - a: The base number. It can be any real number.
    ///   - b: The exponent to which the base number is raised.
    func POWER(_ a: BigDouble, _ b: BigDouble) -> BigDouble {
        return pow(a, b)
    }
    
    /// The PRODUCT function multiplies all the numbers given as arguments and returns the product. For example, if cells A1 and A2 contain numbers, you can use the formula =PRODUCT(A1, A2) to multiply those two numbers together. You can also perform the same operation by using the multiply (*) mathematical operator; for example, =A1 * A2.
    
    /// The PRODUCT function is useful when you need to multiply many cells together. For example, the formula =PRODUCT(A1:A3, C1:C3) is equivalent to =A1 * A2 * A3 * C1 * C2 * C3.
    /// - Parameter ns: The first number or range that you want to multiply. Continue by adding additional numbers or ranges that you want to multiply, up to a maximum of 255 arguments.
    func PRODUCT(_ ns: BigDouble...) -> BigDouble {
        return ns.reduce(BigDouble(1)) { $0 * $1 }
    }
    
    /// Returns the integer portion of a division. Use this function when you want to discard the remainder of a division.
    ///
    /// > Tip: If you want to divide numeric values, you should use the "/" operator as there isn't a DIVIDE function in `Euler.Tables`. For example, to divide 5 by 2, you would type =5/2 into a cell, which returns 2.5. The QUOTIENT function for these same numbers =QUOTIENT(5,2) returns 2, since QUOTIENT doesn't return a remainder.
    /// - Parameters:
    ///   - numerator: The dividend.
    ///   - denominator: The divisor.
    func QUOTIENT(_ numerator: BigDouble, _ denominator: BigDouble) -> BigInt {
        let div = numerator / denominator
        return ceil(div)
    }
    
    /// Converts degrees to radians.
    /// - Parameter angle: An angle in degrees that you want to convert.
    func RADIANS(_ angle: BigDouble) -> BigDouble {
        return angle * pi / BigDouble(180)
    }
    
    /// RAND returns an evenly distributed random real number greater than or equal to 0 and less than 1.
    ///
    /// A new random real number is returned every time the worksheet is calculated.
    func RAND() -> BigDouble {
        return BigDouble(Double.random(in: 0..<1))
    }
    
    func RANDBETWEEN(_ a: BigDouble, _ b: BigDouble) -> BigDouble {
        guard let c = a.asDouble(), let d = b.asDouble() else { return RAND() * (b - a) + a }
        return BigDouble(Double.random(in: c..<d))
    }
    // MARK: Todo Roman
    /// The ROUND function rounds a number to a specified number of digits.
    ///
    /// For example, if cell A1 contains 23.7825, and you want to round that value to two decimal places, you can use the following formula:
    ///
    /// `=ROUND(A1, 2)`
    /// The result of this function is 23.78.
    ///
    /// - If `digits` is greater than 0 (zero), then number is rounded to the specified number of decimal places.
    /// - If `digits` is 0, the number is rounded to the nearest integer.
    /// - If `digits` is less than 0, the number is rounded to the left of the decimal point.
    /// - To always round up (away from zero), use the ROUNDUP function.
    /// - To always round down (toward zero), use the ROUNDDOWN function.
    /// - To round a number to a specific multiple (for example, to round to the nearest 0.5), use the MROUND function.
    /// - Parameters:
    ///   - n: The number that you want to round.
    ///   - digits: The number of digits to which you want to round the number argument.
    func ROUND(_ n: BigDouble, digits: BigInt) -> BigDouble {
        let powed = pow(10, digits)
        let times = n * powed
        return BigDouble(times.rounded()) / powed
    }
    
    /// Rounds a number down, toward zero.
    /// - Parameters:
    ///   - n: Any real number that you want rounded down.
    ///   - digits: The number of digits to which you want to round number.
    func ROUNDDOWN(_ n: BigDouble, digits: BigInt) -> BigDouble {
        let sign: BigDouble = (n > 0) ? 1 : -1
        let powed = pow(10, digits)
        return sign * BigDouble(floor(abs(n) * powed)) / powed
    }
    
    /// Rounds a number up, away from zero.
    /// - Parameters:
    ///   - n: Any real number that you want rounded up.
    ///   - digits: The number of digits to which you want to round number.
    func ROUNDUP(_ n: BigDouble, digits: BigInt) -> BigDouble {
        let sign: BigDouble = (n > 0) ? 1 : -1
        let powed = pow(10, digits)
        return sign * BigDouble(ceil(abs(n) * powed)) / powed
    }
    
    /// Returns the secant of an angle.
    /// - Parameter n: Number is the angle in radians for which you want the secant.
    func SEC(_ n: BigDouble) throws -> BigDouble {
        let cos = try COS(n)
        return BigDouble(1) / cos
    }
    
    /// Returns the hyperbolic secant of an angle.
    /// - Parameter n: Number is the angle in radians for which you want the hyperbolic secant.
    func SECH(_ n: BigDouble) -> BigDouble {
        return 2 / (EXP(n) + EXP(-n))
    }
    
    /// Many functions can be approximated by a power series expansion.
    /// Returns the sum of a power series based on the formula:
    /// `$$ SERIES(x, n, m, a)=a_1x^n+a_2x^(n+m)+...+a_ix^(n+(i-1)m)
    /// - Parameters:
    ///   - x: The input value to the power series.
    ///   - n: The initial power to which you want to raise x.
    ///   - m: The step by which to increase n for each term in the series.
    ///   - coefficients: A set of coefficients by which each successive power of x is multiplied. The number of values in coefficients determines the number of terms in the power series. For example, if there are three values in coefficients, then there will be three terms in the power series.
    func SERIESSUM(_ x: BigDouble, _ n: BigDouble, _ m: BigDouble, _ coefficients: BigDouble...) throws -> BigDouble {
        guard coefficients.count >= 1 else { throw TablesError.Arguments }
        var result = coefficients[0] * pow(x, n)
        var i = 1
        while i < coefficients.count {
            result += coefficients[i] * pow(x, n + BigDouble(i) * m)
            i += 1
        }
        return result
    }
    
    /// Determines the sign of a number. Returns 1 if the number is positive, zero (0) if the number is 0, and -1 if the number is negative.
    /// - Parameter n: Any real number.
    func SIGN(_ n: BigDouble) -> BigInt {
        if (n.sign == false) {
            return -1;
        } else if (n == .zero) {
            return 0;
        } else {
            return 1;
        }
    }
}
