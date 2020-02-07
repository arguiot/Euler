//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-02-07.
//

import Foundation

/// The sum function adds values. These values are passed as an argument
/// - Parameter numbers: The values you want to sum
public func sum(_ numbers: BigNumber...) -> BigNumber {
    return numbers.reduce(BigDouble.zero) { $0 + $1 }
}

/// The sum function adds values. These values are passed as an argument
/// - Parameter numbers: The values you want to sum
public func sum(_ numbers: [BigNumber]) -> BigNumber {
    return numbers.reduce(BigDouble.zero) { $0 + $1 }
}
