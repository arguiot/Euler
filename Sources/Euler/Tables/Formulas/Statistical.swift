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
    /// Returns the geometric mean.
    ///
    /// In mathematics, the geometric mean is a mean or average, which indicates the central tendency or typical value of a set of numbers by using the product of their values (as opposed to the arithmetic mean which uses their sum). The geometric mean is defined as the nth root of the product of `$n$` numbers, i.e., for a set of numbers `$x_1, x_2, ..., x_n,$` the geometric mean is defined as `$$ \left(\prod_{i=1}^n x_i\right)^\frac{1}{n} = \sqrt[n]{x_1 x_2 \cdots x_n} $$`
    ///
    func GEOMEAN(_ array: [BigDouble]) -> BigDouble {
        let stats = Statistics(list: array)
        return stats.geometricMean
    }
    /// Returns the harmonic mean
    ///
    /// In mathematics, the harmonic mean (sometimes called the subcontrary mean) is one of several kinds of average, and in particular, one of the Pythagorean means. Typically, it is appropriate for situations when the average of rates is desired.
    ///
    /// The harmonic mean can be expressed as the reciprocal of the arithmetic mean of the reciprocals of the given set of observations. As a simple example, the harmonic mean of 1, 4, and 4 is
    /// `$$ \left(\frac{1^{-1} + 4^{-1} + 4^{-1}}{3}\right)^{-1} = \frac{3}{\frac{1}{1} + \frac{1}{4} + \frac{1}{4}} = \frac{3}{1.5} = 2 $$`
    ///
    func HARMEAN(_ array: [BigDouble]) -> BigDouble {
        let stats = Statistics(list: array)
        return stats.harmonicMean
    }
    
    /// Returns the kurtosis of a data set. Kurtosis characterizes the relative peakedness or flatness of a distribution compared with the normal distribution. Positive kurtosis indicates a relatively peaked distribution. Negative kurtosis indicates a relatively flat distribution.
    func KURT(_ array: [BigDouble]) -> BigDouble {
        let stats = Statistics(list: array)
        let mean = stats.mean
        let n = BN(array.count)
        var sigma: BN = .zero
        for i in 0..<array.count {
            sigma += (array[i] - mean) ** 4
        }
        let powed = pow(stats.standardDeviation, 4)
        guard powed != 0 else { return 0 }
        sigma = sigma / powed
        let div1 = ((n - 1) * (n - 2) * (n - 3))
        guard div1 != 0 else { return .zero }
        let p1 = (n * (n + 1)) / div1
        let div2 = ((n - 2) * (n - 3))
        guard div2 != 0 else { return .zero }
        let p2 = (n - 1) / div2
        
        return p1 * sigma - 3 * (n - 1) * p2
    }
}
