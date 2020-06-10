//
//  Variance.swift
//  
//
//  Created by Arthur Guiot on 2020-02-07.
//

import Foundation

public extension Statistics {
    // MARK: Variance
    
    /// Returns the standard deviation of the list
    ///
    /// The standard deviation (SD, also represented by the lower case Greek letter sigma σ for the population standard deviation or the Latin letter s for the sample standard deviation) is a measure of the amount of variation or dispersion of a set of values. A low standard deviation indicates that the values tend to be close to the mean (also called the expected value) of the set, while a high standard deviation indicates that the values are spread out over a wider range.
    ///
    var standardDeviation: BigNumber {
        let mean = self.mean
        let diffSqaured = self.list.map { ($0 - mean) ** 2 }
        let summed = sum(diffSqaured)
        let N = self.list.count
        guard N != 1 else { return .zero }
        return (summed / (N - 1)).squareRoot() ?? .zero
    }
    
    /// Returns the variance of the list
    ///
    /// In probability theory and statistics, variance is the expectation of the squared deviation of a random variable from its mean. Informally, it measures how far a set of (random) numbers are spread out from their average value.
    ///
    var variance: BigNumber {
        let mean = self.mean
        let diffSqaured = self.list.map { ($0 - mean) ** 2 }
        let summed = sum(diffSqaured)
        let N = self.list.count
        guard N != 1 else { return .zero }
        return summed / (N - 1)
    }
}
