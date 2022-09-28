//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-02-07.
//

import Foundation

fileprivate enum QuantileError: LocalizedError {
    case PercentageIssue
    case ArrayLength
    public var errorDescription: String? {
        switch self {
        case .PercentageIssue:
            return "Percentage given is not between 0% and 100%"
        case .ArrayLength:
            return "The list given is empty"
        }
    }
}

public extension Statistics {
    // MARK: Median & Quantile
    /// Returns the median of the given numbers. The median is the number in the middle of a set of numbers.
    ///
    /// If there is an even number of numbers in the set, then MEDIAN calculates the average of the two numbers in the middle.
    ///
    var median: BigNumber {
        guard self.list.count > 1 else { return 0 }
        let sorted = self.list.sorted()
        
        let half = Int(floor(Double(sorted.count) / 2.0))
        
        if self.list.count % 2 == 0 {
            return (sorted[half - 1] + sorted[half]) / 2
        } else {
            return sorted[half]
        }
    }
    
    /// Returns corresponding quantile
    ///
    /// In statistics and probability quantiles are cut points dividing the range of a probability distribution into continuous intervals with equal probabilities, or dividing the observations in a sample in the same way. There is one fewer quantile than the number of groups created. Thus quartiles are the three cut points that will divide a dataset into four equal-sized groups. Common quantiles have special names: for instance quartile, decile (creating 10 groups: see below for more). The groups created are termed halves, thirds, quarters, etc., though sometimes the terms for the quantile are used for the groups created, rather than for the cut points.
    /// - Parameter percentage: The percentage of distribution (ex:  0.25 is the first quartile)
    func quantile(percentage: Double) throws -> BigNumber {
        guard percentage > 0.0 && percentage < 1.0 else { throw QuantileError.PercentageIssue }
        guard self.list.count > 1 else { throw QuantileError.ArrayLength }
        var array = self.list
        _ = array.removeFirst()
        let sorted = array.sorted()
        let index = Double(sorted.count - 1) * percentage
        let floored = Int(index)
        let diff = index - BigDouble(floored)
        
        if index + 1 >= BigDouble(sorted.count) {
            let out = sorted[floored] + diff * (sorted[floored + 1] - sorted[floored])
            return out
        } else {
            return sorted[floored]
        }
    }
}
