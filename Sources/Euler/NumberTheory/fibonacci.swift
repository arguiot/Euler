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
