//
//  isPrime.swift
//  
//
//  Created by Arthur Guiot on 2019-12-07.
//

import Foundation

extension BigInt {
    /// Check if the BigInt is a prime.
    ///
    /// > Uses the multiple of 6 method (which is fairly quick and 100% safe)
    var isPrime: Bool {
        let n = abs(self)
        guard n.isNotZero() else { return false }
        if n < 3 { return n > 1 }
        if n % 2 == 0 || n % 3 == 0 { return false }
        
        var i = 5
        
        while n > i * i {
            if n % i == 0 || n % (i + 2) == 0 {
                return false
            }
            i += 6
        }
        return true
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
}
