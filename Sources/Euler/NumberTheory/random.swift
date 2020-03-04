//
//  random.swift
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
    
    internal static func rand_uniform(_ __upper_bound: UInt32) -> UInt32 {
        #if os(Linux)
           return UInt32(Int.random(in: 0...__upper_bound))
        #else
           return arc4random_uniform(__upper_bound)
        #endif
    }
    
    /// Generate a random BigInt
    ///
    /// ⚠️ This isn't crypto secure
    /// - Parameter n: Length of random number (in terms of bits)
    static func randomBigNumber(bits n: Int) -> BigInt {
        let limbs = n >> 6
        let singleBits = n % 64
        
        var res = Limbs(repeating: 0, count: Int(limbs))
        
        for i in 0..<Int(limbs) {
            res[i] = Limb(self.rand_uniform(UInt32.max)) |
                (Limb(self.rand_uniform(UInt32.max)) << 32)
        }
        
        if singleBits > 0 {
            var last: Limb
            
            if singleBits < 32 {
                last = Limb(self.rand_uniform(UInt32(2 ** singleBits)))
                
            } else if singleBits == 32 {
                last = Limb(self.rand_uniform(UInt32.max))
            } else {
                last = Limb(self.rand_uniform(UInt32.max)) |
                    (Limb(self.rand_uniform(UInt32(2.0 ** (singleBits - 32)))) << 32)
            }
            
            res.append(last)
        }
        
        return BigInt(limbs: res)
    }
    /// Alias of `randomBigNumber`
    static let random = randomBigNumber
    
    /// RAND returns an evenly distributed random real number greater than or equal to 0 and less than 1.
    ///
    /// A new random real number is returned every time the worksheet is calculated.
    static func rand() -> BigDouble {
        return BigDouble(Double.random(in: 0..<1))
    }
    
    /// Returns a random integer number between the numbers you specify. A new random integer number is returned every time the worksheet is calculated.
    /// - Parameters:
    ///   - a: The smallest integer RANDBETWEEN will return.
    ///   - b: The largest integer RANDBETWEEN will return.
    static func randbetween(_ a: BigDouble, _ b: BigDouble) -> BigDouble {
        guard let c = a.asDouble(), let d = b.asDouble() else { return rand() * (b - a) + a }
        return BigDouble(Double.random(in: c..<d))
    }
}
