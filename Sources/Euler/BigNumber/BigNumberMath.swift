//
//  BigNumberMath.swift
//  
//
//  Created by Arthur Guiot on 2019-12-07.
//

import Foundation

//
//
//    MARK: - Useful BigNumber math functions
//    ————————————————————————————————————————————————————————————————————————————————————————————
//    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ||||||||        Useful BigNumber math functions        ||||||||||||||||||||||||||||||||||||||||||
//    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//    ————————————————————————————————————————————————————————————————————————————————————————————
//
//
//
internal class BigNumberMath {
    /// Returns true iff (2 ** exp) - 1 is a mersenne prime.
    static func isMersenne(_ exp: Int) -> Bool {
        var mersenne = Limbs(repeating: Limb.max, count: exp >> 6)
        
        if (exp % 64) > 0 {
            mersenne.append((Limb(1) << Limb(exp % 64)) - Limb(1))
        }
        
        var res: Limbs = [4]
        
        for _ in 0..<(exp - 2) {
            res = res.squared().differencing([2]).divMod(mersenne).remainder
        }
        
        return res.equalTo(0)
    }
    
    internal static func euclid(_ a: Limbs, _ b: Limbs) -> Limbs {
        var (a, b) = (a, b)
        while !b.equalTo(0) {
            (a, b) = (b, a.divMod(b).remainder)
        }
        return a
    }
    
    internal static func gcdFactors(_ lhs: Limbs, rhs: Limbs) -> (ax: Limbs, bx: Limbs) {
        let gcd = steinGcd(lhs, rhs)
        return (lhs.divMod(gcd).quotient, rhs.divMod(gcd).quotient)
    }
    
    static func steinGcd(_ a: Limbs, _ b: Limbs) -> Limbs {
        if a == [0] { return b }
        if b == [0] { return a }
        
        // Trailing zeros
        var (za, zb) = (0, 0)
        
        while !a.getBit(at: za) { za += 1 }
        while !b.getBit(at: zb) { zb += 1 }
        
        let k = min(za, zb)
        
        var (a, b) = (a, b)
        a.shiftDown(za)
        b.shiftDown(k)
        
        while b != [0] {
            zb = 0
            while !b.getBit(at: zb) { zb += 1 }
            b.shiftDown(zb)
            
            if b.lessThan(a) { (a, b) = (b, a) }
            // At this point, b >= a
            b.difference(a)
        }
        
        return a.shiftingUp(k)
    }
    
    static func gcd(_ a: BigInt, _ b: BigInt) -> BigInt {
        let limbRes = steinGcd(a.limbs, b.limbs)
        return BigInt(sign: a.sign && !limbRes.equalTo(0), limbs: limbRes)
    }
    
    /// Do not use this, extremely slow. Only for testing purposes.
    static func gcdEuclid(_ a: BigInt, _ b: BigInt) -> BigInt {
        let limbRes = euclid(a.limbs, b.limbs)
        return BigInt(sign: a.sign && !limbRes.equalTo(0), limbs: limbRes)
    }
    
    internal static func lcmPositive(_ a: Limbs, _ b: Limbs) -> Limbs {
        return a.divMod(steinGcd(a, b)).quotient.multiplyingBy(b)
    }
    
    static func lcm(_ a:BigInt, _ b:BigInt) -> BigInt {
        return BigInt(limbs: lcmPositive(a.limbs, b.limbs))
    }
    
    static func fib(_ n:Int) -> BigInt {
        var a: Limbs = [0], b: Limbs = [1], t: Limbs
        
        for _ in 2...n
        {
            t = b
            b.addLimbs(a)
            a = t
        }
        
        return BigInt(limbs: b)
    }
    
    ///    Order matters, repetition not allowed.
    static func permutations(_ n: Int, _ k: Int) -> BigInt {
        // n! / (n-k)!
        return BigInt(n).factorial() / BigInt(n - k).factorial()
    }
    
    ///    Order matters, repetition allowed.
    static func permutationsWithRepitition(_ n: Int, _ k: Int) -> BigInt {
        // n ** k
        return BigInt(n) ** k
        
    }
    
    ///    Order does not matter, repetition not allowed.
    static func combinations(_ n: Int, _ k: Int) -> BigInt {
        // (n + k - 1)! / (k! * (n - 1)!)
        return BigInt(n + k - 1).factorial() / (BigInt(k).factorial() * BigInt(n - 1).factorial())
    }
    
    ///    Order does not matter, repetition allowed.
    static func combinationsWithRepitition(_ n: Int, _ k: Int) -> BigInt {
        // n! / (k! * (n - k)!)
        return BigInt(n).factorial() / (BigInt(k).factorial() * BigInt(n - k).factorial())
    }
    
    static func randomBigNumber(bits n: Int) -> BigInt {
        let limbs = n >> 6
        let singleBits = n % 64
        
        var res = Limbs(repeating: 0, count: Int(limbs))
        
        for i in 0..<Int(limbs) {
            res[i] = Limb(arc4random_uniform(UInt32.max)) |
                (Limb(arc4random_uniform(UInt32.max)) << 32)
        }
        
        if singleBits > 0 {
            var last: Limb
            
            if singleBits < 32 {
                last = Limb(arc4random_uniform(UInt32(2 ** singleBits)))
                
            } else if singleBits == 32 {
                last = Limb(arc4random_uniform(UInt32.max))
            } else {
                last = Limb(arc4random_uniform(UInt32.max)) |
                    (Limb(arc4random_uniform(UInt32(2.0 ** (singleBits - 32)))) << 32)
            }
            
            res.append(last)
        }
        
        return BigInt(limbs: res)
    }
    let random = randomBigNumber
    
    func isPrime(_ n: BigInt) -> Bool {
        if n <= 3 { return n > 1 }
        
        if ((n % 2) == 0) || ((n % 3) == 0) { return false }
        
        var i = 5
        while (i * i) <= n
        {
            if ((n % i) == 0) || ((n % (i + 2)) == 0)
            {
                return false
            }
            i += 6
        }
        return true
    }
    
    /// Quick exponentiation/modulo algorithm
    /// FIXME: for security, this should use the constant-time Montgomery algorithm to thwart timing attacks
    ///
    /// - Parameters:
    ///   - b: base
    ///   - p: power
    ///   - m: modulus
    /// - Returns: pow(b, p) % m
    static func mod_exp(_ b: BigInt, _ p: BigInt, _ m: BigInt) -> BigInt {
        precondition(m != 0, "modulus needs to be non-zero")
        precondition(p >= 0, "exponent needs to be non-negative")
        var base = b % m
        var exponent = p
        var result = BigInt(1)
        while exponent > 0 {
            if exponent.limbs[0] % 2 != 0 {
                result = result * base % m
            }
            exponent.limbs.shiftDown(1)
            base *= base
            base %= m
        }
        return result
    }
    
    /// Non-negative modulo operation
    ///
    /// - Parameters:
    ///   - a: left hand side of the module operation
    ///   - m: modulus
    /// - Returns: r := a % b such that 0 <= r < abs(m)
    static func nnmod(_ a: BigInt, _ m: BigInt) -> BigInt {
        let r = a % m
        guard r.isNegative() else { return r }
        let p = m.isNegative() ? r - m : r + m
        return p
    }
    
    /// Convenience function combinding addition and non-negative modulo operations
    ///
    /// - Parameters:
    ///   - a: left hand side of the modulo addition
    ///   - b: right hand side of the modulo addition
    ///   - m: modulus
    /// - Returns: nnmod(a + b, m)
    static func mod_add(_ a: BigInt, _ b: BigInt, _ m: BigInt) -> BigInt {
        return nnmod(a + b, m)
    }
}
