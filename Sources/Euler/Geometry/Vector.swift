//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-04-08.
//

import Foundation

/// Vector object
///
/// In the Euclidean geometry, a vector is what is needed to "carry" the point A to the point B; it is a geometric object that has magnitude (or length) and direction. Vectors can be added to other vectors according to vector algebra. A Euclidean vector is frequently represented by a line segment with a definite direction, or graphically as an arrow, connecting an initial point A with a terminal point B, and denoted by `$\overrightarrow{AB}$`.
///
public struct Vector: Equatable {
    var x: BigDouble
    var y: BigDouble
    var dims: [BigDouble]
    
    /// Simple 2D Vector
    /// - Parameters:
    ///   - x: X coordinate
    ///   - y: Y coordinate
    init(x: BigDouble, y: BigDouble) {
        self.x = x
        self.y = y
        self.dims = [x, y]
    }
    
    /// Simple 1D Vector
    /// - Parameter x: X coordinate
    init(x: BigDouble) {
        self.x = x
        self.y = 0
        self.dims = [x]
    }
    
    /// Vector in more than 2 dimensions
    /// - Parameter multipleDimensions: An containing the coordinates: `[x, y, z, ...]`
    init(multipleDimensions: [BigDouble]) {
        self.x = multipleDimensions.first ?? 0
        self.y = multipleDimensions.count > 1 ? multipleDimensions[1] : 0
        self.dims = multipleDimensions
    }
    /// Converts a Vector into a Matrix
    public var matrix: Matrix {
        return Matrix(self.dims.map { $0.asDouble() ?? Double.infinity }, isColumnVector: true)
    }
    /// Sum of two vectors
    static public func +(rhs: Vector, lhs: Vector) -> Vector {
        let dims = zip(rhs.dims, lhs.dims).map { $0 + $1 }
        return Vector(multipleDimensions: dims)
    }
    /// Dot product of two vectors
    static public func *(rhs: Vector, lhs: Vector) -> BigDouble {
        let mul = zip(rhs.dims, lhs.dims).map { $0 * $1 }
        let sum = mul.reduce(0, +)
        return sum
    }
    /// Equality between vectors
    static public func ==(rhs: Vector, lhs: Vector) -> Bool {
        return rhs.dims == lhs.dims
    }
}
