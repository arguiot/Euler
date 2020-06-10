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
    // MARK: Average
    
    /// Return the arithmetic mean (average) of the list
    ///
    /// The arithmetic mean of a set of values is the quantity commonly called "the" mean or the average. It's simply the sum of all the terms in a list, divided by the number of elements in the list.
    ///
    var average: BigNumber {
        guard !self.list.isEmpty else { return 0 }
        let sum = list.reduce(0, +) // Sum of the entire list
        let av = sum / BigDouble(list.count)
        return av
    }
    
    /// Alias for average
    var mean: BigNumber {
        return average
    }
    
    /// Returns the average of the absolute deviations of data points from their mean. It is a measure of the variability in a data set.
    var MAD: BigDouble {
        guard !self.list.isEmpty else { return 0 }
        
        let average = self.average
        let sum = list.reduce(.zero) { (prev, next) in
            return prev + abs(next - average)
        }
        return sum / BN(list.count)
    }
    
    /// Returns the sum of squares of deviations of data points from their sample mean.
    var devSquared: BigDouble {
        let average = self.average
        let sum = list.reduce(.zero) { (prev, next) in
            return prev + (next - average) ** 2
        }
        return sum
    }
    
    /// Returns the geometric mean.
    ///
    /// In mathematics, the geometric mean is a mean or average, which indicates the central tendency or typical value of a set of numbers by using the product of their values (as opposed to the arithmetic mean which uses their sum). The geometric mean is defined as the nth root of the product of `$n$` numbers, i.e., for a set of numbers `$x_1, x_2, ..., x_n,$` the geometric mean is defined as `$$ \left(\prod_{i=1}^n x_i\right)^\frac{1}{n} = \sqrt[n]{x_1 x_2 \cdots x_n} $$`
    ///
    var geometricMean: BigDouble {
        let mul = list.reduce(BN(1)) { $0 * $1 }
        guard let pow = mul.nthroot(list.count) else { return .zero }
        return pow
    }
    
    /// Returns the harmonic mean
    ///
    /// In mathematics, the harmonic mean (sometimes called the subcontrary mean) is one of several kinds of average, and in particular, one of the Pythagorean means. Typically, it is appropriate for situations when the average of rates is desired.
    ///
    /// The harmonic mean can be expressed as the reciprocal of the arithmetic mean of the reciprocals of the given set of observations. As a simple example, the harmonic mean of 1, 4, and 4 is
    /// `$$ \left(\frac{1^{-1} + 4^{-1} + 4^{-1}}{3}\right)^{-1} = \frac{3}{\frac{1}{1} + \frac{1}{4} + \frac{1}{4}} = \frac{3}{1.5} = 2 $$`
    ///
    var harmonicMean: BigDouble {
        guard !list.contains(.zero) else { return 0 }
        let inverted = list.map { BN(1) / $0 }
        let av = Statistics(list: inverted).average
        return 1 / av
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
        guard coefSum != 0 else { throw AverageError.CoefficientIssue }
        let av = sum / coefSum
        return av
    }
}
