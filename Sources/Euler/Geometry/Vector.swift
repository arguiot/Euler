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
    /// X-coordinate of the vector
    public var x: BigDouble
    /// Y-coordinate of the vector
    public var y: BigDouble
    /// X, Y and higher dimensions
    public var dims: [BigDouble]
    /// Origin of the vector
    public var origin: Point
    /// Simple 2D Vector
    /// - Parameters:
    ///   - x: X coordinate
    ///   - y: Y coordinate
    public init(x: BigDouble, y: BigDouble, origin: Point = Point(x: 0, y: 0)) {
        self.x = x
        self.y = y
        self.dims = [x, y]
        self.origin = origin
    }
    
    /// Simple 1D Vector
    /// - Parameter x: X coordinate
    public init(x: BigDouble, origin: Point = Point(x: 0)) {
        self.x = x
        self.y = 0
        self.dims = [x]
        self.origin = origin
    }
    
    /// Vector in more than 2 dimensions
    /// - Parameter multipleDimensions: An containing the coordinates: `[x, y, z, ...]`
    public init(multipleDimensions: [BigDouble], origin: Point? = nil) {
        self.x = multipleDimensions.first ?? 0
        self.y = multipleDimensions.count > 1 ? multipleDimensions[1] : 0
        self.dims = multipleDimensions
        self.origin = origin ?? Point(multipleDimensions: Array<BigDouble>(repeating: .zero, count: multipleDimensions.count))
    }
    /// Converts a Vector into a Matrix
    public var matrix: Matrix {
        return Matrix(self.dims.map { $0.asDouble() ?? Double.infinity }, isColumnVector: true)
    }
    /// Origin point translated by the vector
    public var translated: Point {
        let dims = zip(origin.dims, self.dims).map { $0 + $1 }
        return Point(multipleDimensions: dims)
    }
    
    /// Sum of two vectors
    static public func +(rhs: Vector, lhs: Vector) -> Vector {
        var rhs = rhs
        var lhs = lhs
        if rhs.dims.count > lhs.dims.count {
            let diff = rhs.dims.count - lhs.dims.count
            lhs.dims.append(contentsOf: Array<BigDouble>(repeating: 0, count: diff))
        } else if lhs.dims.count > rhs.dims.count {
            let diff = lhs.dims.count - rhs.dims.count
            rhs.dims.append(contentsOf: Array<BigDouble>(repeating: 0, count: diff))
        }
        let dims = zip(rhs.dims, lhs.dims).map { $0 + $1 }
        return Vector(multipleDimensions: dims)
    }
    /// Dot product of two vectors
    static public func *(rhs: Vector, lhs: Vector) -> BigDouble {
        var rhs = rhs
        var lhs = lhs
        if rhs.dims.count > lhs.dims.count {
            let diff = rhs.dims.count - lhs.dims.count
            lhs.dims.append(contentsOf: Array<BigDouble>(repeating: 0, count: diff))
        } else if lhs.dims.count > rhs.dims.count {
            let diff = lhs.dims.count - rhs.dims.count
            rhs.dims.append(contentsOf: Array<BigDouble>(repeating: 0, count: diff))
        }
        let mul = zip(rhs.dims, lhs.dims).map { $0 * $1 }
        let sum = mul.reduce(0, +)
        return sum
    }
    /// Equality between vectors
    static public func ==(rhs: Vector, lhs: Vector) -> Bool {
        return rhs.dims == lhs.dims
    }
}
