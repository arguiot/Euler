//
//  random.swift
//  
//
//  Created by Arthur Guiot on 2019-12-07.
//

import Foundation

extension BigInt {
    /// Generate a random BigInt
    ///
    /// ⚠️ This isn't crypto secure
    /// - Parameter n: Length of random number (in terms of bits)
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
    static let random = randomBigNumber
}
