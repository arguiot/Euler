//
//  Statistical.swift
//  Euler
//
//  Created by Arthur Guiot on 2020-06-10.
//

import Foundation

public extension Tables {
    // MARK: Statistical functions
    
    /// Returns the average of the absolute deviations of data points from their mean. AVEDEV is a measure of the variability in a data set.
    func AVEDEV(_ array: [BigDouble]) -> BigDouble {
        let stats = Statistics(list: array)
        return stats.MAD
    }

    
    /// Returns the average (arithmetic mean) of the arguments. For example, if the range A1:A20 contains numbers, the formula `=AVERAGE(A1:A20)` returns the average of those numbers.
    func AVERAGE(_ array: [BigDouble]) -> BigDouble {
        let stats = Statistics(list: array)
        return stats.average
    }
    
    /// The CORREL function returns the correlation coefficient of two arrays. Use the correlation coefficient to determine the relationship between two properties. For example, you can examine the relationship between a location's average temperature and the use of air conditioners.
    /// - Parameters:
    ///   - array1: A an array of values
    ///   - array2: A an array of values
    /// - Returns: Correlation coefficient of two arrays
    func CORREL(_ array1: [BigDouble], _ array2: [BigDouble]) throws -> BigDouble {
        let stats = Statistics(list: array1)
        return try stats.correlation(with: array2)
    }
    
    /// Counts the element of the given array
    /// - Parameter array: Any array composed of random elements
    /// - Returns: Counted value
    func COUNT(_ array: [Any]) -> Int {
        return array.count
    }
    
    /// Returns the sum of squares of deviations of data points from their sample mean.
    func DEVSQ(_ array: [BigDouble]) -> BigDouble {
        let stats = Statistics(list: array)
        return stats.devSquared
    }
    /// Returns the Fisher transformation at x. This transformation produces a function that is normally distributed rather than skewed. Use this function to perform hypothesis testing on the correlation coefficient.
    func FISHER(_ x: BigDouble) -> BigDouble {
        return Statistics.fisher(at: x)
    }
    /// Returns the inverse of the Fisher transformation. Use this transformation when analyzing correlations between ranges or arrays of data. If y = FISHER(x), then FISHERINV(y) = x.
    func FISHERINV(_ y: BigDouble) -> BigDouble {
        return Statistics.inverseFisher(at: y)
    }
    
    /// The gamma function (represented by `$\Gamma$`, the capital letter gamma from the Greek alphabet) is one commonly used extension of the factorial function to complex numbers. The gamma function is defined for all complex numbers except the non-positive integers. For any positive integer n: `$\Gamma (n)=(n-1)!$`
    /// - Parameter x: Any number
    /// - Returns: The gamma function value.
    func GAMMA(_ x: BigDouble) -> BigDouble {
        return gamma(x)
    }
    
    /// Returns the natural logarithm of the gamma function, `$\Gamma (x)$`.
    /// - Parameter x: Any number
    func GAMMALN(_ x: BigDouble) -> BigDouble {
        return ln(gamma(x))
    }
    
    /// Integral of the Gauss function
    ///
    /// Computed using: `$$ \int_{0}^{x}\frac{1}{\sqrt{2\pi}}*e^{-\frac{x^{2}}{2}}dx = \frac{1}{2}\cdot \operatorname{erf}\left( \frac{x}{\sqrt{2}} \right) $$`
    /// - Parameter x: Any number
    func GAUSS(_ x: BigDouble) -> BigDouble {
        return Statistics.gauss(at: x)
    }
}
