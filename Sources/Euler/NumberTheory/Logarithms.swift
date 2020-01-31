//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-01-30.
//

import Foundation

public func ln(_ n: BigDouble, precision: BigInt = 15) -> BigDouble {
    var buffer: BigNumber = 0
    var i: BigInt = 0
    while i < ceil(precision + (3 / 2 * n)) {
        let c = i * 2 + 1
        let a: BigDouble = 1 / c
        let b = (n - 1) / (n + 1)
        var powed: BigDouble
        if let bi = b.asDouble(), let ci = c.asInt() {
            let p = pow(bi, Double(ci))
            if p == Double.infinity {
                powed = pow(b, c)
            } else {
                powed = BigDouble(p)
            }
        } else {
            powed = pow(b, c)
        }
        let t = a * powed
        buffer += t
        i += 1
    }
    return buffer * 2
}
