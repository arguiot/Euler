//
//  fibonacci.swift
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
    
    /// Returns the corresponding Fibonacci number, commonly denoted `$F_n$`, form a sequence, called the Fibonacci sequence, such that each number is the sum of the two preceding ones, starting from 0 and 1.
    var fibonacci: BigInt {
        let n = self
        var a: Limbs = [0], b: Limbs = [1], t: Limbs
        
        for _ in 2...n {
            t = b
            b.addLimbs(a)
            a = t
        }
        
        return BigInt(limbs: b)
    }
}
