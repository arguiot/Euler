//
//  Correlation.swift
//  
//
//  Created by Arthur Guiot on 2020-02-07.
//

import Foundation

public enum CorrelationError: LocalizedError {
    case ArrayLengthIssue
    case SQRTProblem
    public var errorDescription: String? {
        switch self {
        case .ArrayLengthIssue:
            return "Correlation error, arrays are not the same size"
        case .SQRTProblem:
            return "Couldn't find the SQRT. This should actually never happen, so if you ever see this message, something terrible happened..."
        }
    }
}

public extension Statistics {
    // MARK: Correlation
    
    /// This function returns the correlation coefficient of two cell ranges.
    ///
    /// Use the correlation coefficient to determine the relationship between two properties. For example, you can examine the relationship between a location's average temperature and the use of air conditioners.
    /// - Parameter list: A second array to be compared with.
    func correlation(with list: [BigNumber]) throws -> BigNumber {
        guard self.list.count == list.count else { throw CorrelationError.ArrayLengthIssue }
        let average1 = self.average
        let average2 = Statistics(list: list).average
        var up: BigNumber = 0
        var down1: BigNumber = 0
        var down2: BigNumber = 0
        for i in 0..<self.list.count {
            up += (self.list[i] - average1)*(list[i] - average2)
            down1 += pow(self.list[i] - average1, 2)
            down2 += pow(list[i] - average2, 2)
        }
        guard let down = (down1 * down2).squareRoot() else { throw CorrelationError.SQRTProblem }
        return up / down
    }
}
