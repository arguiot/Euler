//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-02-07.
//

import Foundation

public extension Statistics {
    // MARK: Regression
    
    /// Linear regression on a set of points
    ///
    /// Returns an affine function going through the set of point.
    /// - Parameter points: A set of points
    static func linearRegression(points: [Point]) throws -> Polynomial {
        let n = BigDouble(points.count)
        var sum_x: BigDouble = .zero
        var sum_y: BigDouble = .zero
        var sum_xy: BigDouble = .zero
        var sum_xx: BigDouble = .zero
        var sum_yy: BigDouble = .zero
        for p in points {
            sum_x += p.x
            sum_y += p.y
            sum_xy += p.x * p.y
            sum_xx += p.x * p.x
            sum_yy += p.y * p.y
        }
        let upper = n * sum_xy - sum_x * sum_y
        let down = n * sum_xx - sum_x * sum_x
        let slope =  upper / down
        let intercept = (sum_y - slope * sum_x) / n
        return try Polynomial(slope, intercept)
    }
    #if !os(Linux)
    /// Polynomial regression on a set of points
    ///
    /// Returns an affine function going through the set of point.
    /// - Parameter points: A set of points
    /// - Parameter deg: The polynomial degree
    /// - Returns: Polynomial
    static func polynomialRegression(points: [Point], deg: Int = 2) throws -> Polynomial {
        var z = Matrix(rows: points.count, columns: deg + 1, repeatedValue: 0)
        
        for i in 0..<points.count {
            for j in 0...deg {
                let base = points[i].x
                let val = pow(base, j)
                z[i, j] = val.asDouble() ?? 0
            }
        }
        
        let y = Matrix(rows: points.count, columns: 1, grid: points.map { $0.y.asDouble() ?? 0 })

        let z_transposed = z.transpose()

        let l = z_transposed <*> z
        let r = z_transposed <*> y

        
        let regression = try l.solveEquationsSystem(vector: r.grid)
        
        let coefs = regression.grid.map { BigDouble($0) }
        return try Polynomial(coefs.reversed())
    }
    #endif
}
