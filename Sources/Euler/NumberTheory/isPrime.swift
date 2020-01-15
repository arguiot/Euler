//
//  isPrime.swift
//  
//
//  Created by Arthur Guiot on 2019-12-07.
//

import Foundation

public extension BigInt {
    //
    //
    //    MARK: - BigNumber Utility Functions
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //    ||||||||        BigNumber Utility Functions        |||||||||||||||||||||||||||||||||||||
    //    ————————————————————————————————————————————————————————————————————————————————————————
    //
    //
    //
    //
    
    /// Check if the BigInt is a prime.
    ///
    /// > Uses the multiple of 6 method (which is fairly quick and 100% safe)
    var isPrime: Bool {
        let n = abs(self)
        guard n.asInt() == nil else {
            return n == leastFactor(n.asInt()!) // quicker when using native Int
        }
        return n.millerRabin(accuracy: 30) // 30 is quick but also precise
    }
    /// Returns true iff (2 ** exp) - 1 is a mersenne prime.
    var isMersenne: Bool {
        let exp = self
        guard let int = exp.asInt() else { return false }
        var mersenne = Limbs(repeating: Limb.max, count: int >> 6)
        
        if (exp % 64) > 0 {
            mersenne.append((Limb(1) << Limb(exp % 64)) - Limb(1))
        }
        
        var res: Limbs = [4]
        
        for _ in 0..<(exp - 2) {
            res = res.squared().differencing([2]).divMod(mersenne).remainder
        }
        
        return res.equalTo(0)
    }
    
    
    /// "Prime Factorization" is finding which prime numbers multiply together to make the original number.
    ///
    /// Here are some examples:
    /// ```swift
    /// BigInt(12).primeFactors //=> [2, 2, 3] because 12 = 2 * 2 * 3
    /// ```
    ///
    var primeFactors: [BigInt] {
        var list = [BigInt]()
        if let int = self.asInt() {
            var n = int // duplicates the number
            var minFactor = 1
            while minFactor != n {
                n /= minFactor
                minFactor = leastFactor(n)
                list.append(BigInt(minFactor))
            }
            return list
        }
        var n = BigInt(limbs: self.limbs) // duplicates the number
        var minFactor: BigInt = 1
        while minFactor != n {
            n /= minFactor
            minFactor = leastFactor(n)
            list.append(minFactor)
        }
        return list
    }
    
    /**
     The Miller–Rabin test relies on an equality or set of equalities that
     hold true for prime values, then checks whether or not they hold for
     a number that we want to test for primality.
     - Parameter k: a parameter that determines the accuracy of the test
     - Returns: composite if `self` is composite, otherwise probably prime
    */
    func millerRabin(accuracy k: BigInt = 30) -> Bool {
        let n = abs(self)
        guard n > 3 else { return true }

        // return false for all even numbers bigger than 2
        if n % 2 == 0 {
            return false
        }
        
        let s = (n - 1).trailingZeroBitCount
        let d = (n - 1) >> s

        guard pow(2, s) * d == BigDouble(n - 1) else { return false }

        /// Inspect whether a given witness will reveal the true identity of n.
        func tryComposite(_ a: BigInt, d: BigInt, n: BigInt) -> Bool? {
            var x = mod_exp(a, d, n)
            if x == 1 || x == (n - 1) {
                return nil
            }
            for _ in 1..<s {
                x = mod_exp(x, 2, n)
                if x == 1 {
                    return false
                } else if x == (n - 1) {
                    return nil
                }
            }
            return false
        }

        for _ in 0..<k {
            let a = BigInt.randomBigNumber(bits: (n-2).bitWidth) + 2 // random between 2 and n-2
            if let composite = tryComposite(a, d: d, n: n) {
                return composite
            }
        }

        return true
    }
    
    /// Counts the numbr of prime number before itself
    var primePi: Int {
        let n = self
        var sieve = Sieve()
        var out = 0
        while n > sieve.next()! {
            out += 1
        }
        return out
    }
}
