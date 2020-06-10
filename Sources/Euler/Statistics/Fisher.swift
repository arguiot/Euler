//
//  Fisher.swift
//  Euler
//
//  Created by Arthur Guiot on 2020-06-10.
//

import Foundation

public extension Statistics {
    /// Returns the Fisher transformation at x. This transformation produces a function that is normally distributed rather than skewed. Use this function to perform hypothesis testing on the correlation coefficient.
    /// - Parameter x: A numeric value for which you want the transformation.
    /// - Returns: The Fisher transformation at x.
    static func fisher(at x: BigDouble) -> BigDouble {
        return ln((1 + x) / (1 - x)) / 2
    }
}
