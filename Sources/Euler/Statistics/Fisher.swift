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
    
    /// Returns the inverse of the Fisher transformation. Use this transformation when analyzing correlations between ranges or arrays of data. If y = fisher(x), then inverseFisher(y) = x.
    /// - Parameter y: The image of x using the fisher transformation
    /// - Returns: The inverse of the Fisher transformation.
    static func inverseFisher(at y: BigDouble) -> BigDouble {
        let e2y = exp(2 * y)
        return (e2y - 1) / (e2y + 1)
    }
}
