//
//  Statistics.swift
//  
//
//  Created by Arthur Guiot on 2020-01-08.
//

import Foundation

/// The class that helps to process numerical data
///
/// `Statistics` was designed to help with the mathematics of the collection, organization, and interpretation of numerical data, especially the analysis of population characteristics by inference from sampling.
///
public class Statistics: NSObject {
    
    /// The list used for statistical computations
    public var list: [BigNumber]
    
    /// Creates a `Statistics` object
    /// - Parameter list: A list of `BigDouble` used for statistical computations
    public init(list: [BigNumber]) {
        self.list = list
    }
    
    /// Creates a `Statistics` object
    ///
    /// Example:
    /// ```swift
    /// Statistics(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
    /// ```
    /// - Parameter list: A list of `Double` used for statistical computations
    public init(_ list: Double...) {
        self.list = list.map { BigNumber($0) }
    }
}

// MARK: Basic Methods for the list
public extension Statistics {
    /// Returns the mode of the list.
    ///
    /// The mode is the value that appears most often in a set of data values.
    var mode: BigNumber {
        var counts: [BigNumber: Int] = [:]
        for num in self.list {
            counts[num, default: 0] += 1
        }
        let sorted = counts.sorted { $0.value > $1.value }
        return sorted[0].key
    }
}
