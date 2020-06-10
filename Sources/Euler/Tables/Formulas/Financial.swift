//
//  Financial.swift
//  Euler
//
//  Created by Arthur Guiot on 2020-05-31.
//

import Foundation

public extension Tables {
    // MARK: Financial functions
    
    /// Returns the accrued interest for a security that pays periodic interest.
    /// - Parameters:
    ///   - issue: The security's issue date.
    ///   - first: The security's first interest date.
    ///   - settlement: The security's settlement date. The security settlement date is the date after the issue date when the security is traded to the buyer.
    ///   - rate: The security's annual coupon rate.
    ///   - par: The security's par value. If you omit par, ACCRINT uses $1,000.
    ///   - frequency: The number of coupon payments per year. For annual payments, frequency = 1; for semiannual, frequency = 2; for quarterly, frequency = 4.
    ///   - basis: The type of day count basis to use.
    /// - Throws: `TablesError`
    /// - Returns: Accrued interest for a security that pays periodic interest
    func ACCRINT(_ issue: Int, _ first: Int, _ settlement: Int, _ rate: BigDouble, _ par: BigDouble = 1000, _ frequency: Int = 1, _ basis: Int = 0) throws -> BigDouble {
        guard rate > 0 && par > 0 else { throw TablesError.Arguments }
        guard [1, 2, 4].contains(frequency) && [0, 1, 2, 3, 4].contains(basis) else { throw TablesError.Arguments }
        guard settlement > issue else { throw TablesError.Arguments }
        // Compute accrued interest
        
        let frac = try self.YEARFRAC(start: BN(issue), end: BN(settlement), basis: basis)
        return par * rate * frac
    }
}
