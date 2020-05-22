//
//  leastFactor.swift
//  
//
//  Created by Arthur Guiot on 2020-01-12.
//

import Foundation


/// Gives you the least (smallest) prime factor of any integer by trial division
/// - Parameter number: The integer you want to use
public func leastFactor(_ number: BigInt) -> BigInt {
    let n = abs(number)
    var out: BigInt? = nil
    if (n == 0) { out = out != nil ? out : 0 }
    if (n * n < 2) { out = out != nil ? out : 1 }
    if (n % 2 == 0) { out = out != nil ? out : 2 }
    if (n % 3 == 0) { out = out != nil ? out : 3 }
    if (n % 5 == 0) { out = out != nil ? out : 5 }
    guard let m = BigDouble(n).squareRoot() else { return out ?? .zero }
    
    var i = BigInt(7)
    while BigDouble(i) <= m {
        if (n % i == 0) { out = out != nil ? out : BigInt(i) }
        if (n % (i + 4) == 0) { out = out != nil ? out : i + 4 }
        if (n % (i + 6) == 0) { out = out != nil ? out : i + 6 }
        if (n % (i + 10) == 0) { out = out != nil ? out : i + 10 }
        if (n % (i + 12) == 0) { out = out != nil ? out : i + 12 }
        if (n % (i + 16) == 0) { out = out != nil ? out : i + 16 }
        if (n % (i + 22) == 0) { out = out != nil ? out : i + 22 }
        if (n % (i + 24) == 0) { out = out != nil ? out : i + 24 }
        
        i += 30
    }
    guard out != nil else { return n }
    return out!
}

/// Gives you the least (smallest) prime factor of any integer by trial division
/// - Parameter number: The integer you want to use
public func leastFactor(_ number: Int) -> Int {
    let n = abs(number)
    var out: Int? = nil
    if (n == 0) { out = out != nil ? out : 0 }
    if (n < 2) { out = out != nil ? out : 1 }
    if (n % 2 == 0) { out = out != nil ? out : 2 }
    if (n % 3 == 0) { out = out != nil ? out : 3 }
    if (n % 5 == 0) { out = out != nil ? out : 5 }
    let m = sqrt(Double(n))
    
    var i = 7
    while Double(i) <= m {
        if (n % i == 0) { out = out != nil ? out : i }
        if (n % (i + 4) == 0) { out = out != nil ? out : i + 4 }
        if (n % (i + 6) == 0) { out = out != nil ? out : i + 6 }
        if (n % (i + 10) == 0) { out = out != nil ? out : i + 10 }
        if (n % (i + 12) == 0) { out = out != nil ? out : i + 12 }
        if (n % (i + 16) == 0) { out = out != nil ? out : i + 16 }
        if (n % (i + 22) == 0) { out = out != nil ? out : i + 22 }
        if (n % (i + 24) == 0) { out = out != nil ? out : i + 24 }
        
        i += 30
    }
    guard out != nil else { return n }
    return out!
}
