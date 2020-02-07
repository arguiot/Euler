//
//  Average.swift
//  
//
//  Created by Arthur Guiot on 2020-01-08.
//

import Foundation

fileprivate enum AverageError: LocalizedError {
    case CoefficientIssue
    public var errorDescription: String? {
        switch self {
        case .CoefficientIssue:
            return "The coefficient list provided was either longer or shorter than the original list. Please make sure that they have the same length"
        }
    }
}

public extension Statistics {
    /// Return the arithmetic mean (average) of the list
    ///
    /// The arithmetic mean of a set of values is the quantity commonly called "the" mean or the average. It's simply the sum of all the terms in a list, divided by the number of elements in the list.
    ///
    var average: BigNumber {
        let sum = list.reduce(0, +) // Sum of the entire list
        let av = sum / BigDouble(list.count)
        return av
    }
    
    /// Alias for average
    var mean: BigNumber {
        return average
    }
    
    /// Return the weighted arithmetic mean (average) of the list with the given coefficients
    ///
    /// The weighted arithmetic mean is similar to an ordinary arithmetic mean (the most common type of average), except that instead of each of the data points contributing equally to the final average, some data points contribute more than others. The notion of weighted mean plays a role in descriptive statistics and also occurs in a more general form in several other areas of mathematics.
    ///
    /// If all the weights are equal, then the weighted mean is the same as the arithmetic mean. While weighted means generally behave in a similar fashion to arithmetic means, they do have a few counterintuitive properties, as captured for instance in Simpson's paradox.
    /// - Parameter coefficients: The weighted coefficients you want to use to multiply the original list.
    func average(coefficients: [BigNumber]) throws -> BigNumber {
        guard coefficients.count == list.count else { throw AverageError.CoefficientIssue }
        var tmp = [BigNumber]()
        
        var i = 0
        
        while i < list.count {
            tmp.append(list[i] * coefficients[i])
            i += 1
        }
        let sum = tmp.reduce(0, +) // Sum of the entire list
        let coefSum = coefficients.reduce(0, +)
        let av = sum / coefSum
        return av
    }
}
