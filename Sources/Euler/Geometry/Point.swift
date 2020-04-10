//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-02-07.
//

import Foundation

/// Fondamental element in Euclidean geometry
///
/// Points, considered within the framework of Euclidean geometry, are one of the most fundamental objects. Euclid originally defined the point as "that which has no part". In two-dimensional Euclidean space, a point is represented by an ordered pair (x, y) of numbers, where the first number conventionally represents the horizontal and is often denoted by x, and the second number conventionally represents the vertical and is often denoted by y. This idea is easily generalized to three-dimensional Euclidean space, where a point is represented by an ordered triplet (x, y, z) with the additional third number representing depth and often denoted by z. Further generalizations are represented by an ordered tuplet of n terms, (a1, a2, … , an) where n is the dimension of the space in which the point is located.
///
public struct Point {
    /// X-coordinate of the point
    public var x: BigDouble
    /// Y-coordinate of the point
    public var y: BigDouble
    /// X, Y and higher dimensions
    public var dims: [BigDouble]
    
    /// Simple 2D Point
    /// - Parameters:
    ///   - x: X coordinate
    ///   - y: Y coordinate
    public init(x: BigDouble, y: BigDouble) {
        self.x = x
        self.y = y
        self.dims = [x, y]
    }
    
    /// Simple 1D Point
    /// - Parameter x: X coordinate
    public init(x: BigDouble) {
        self.x = x
        self.y = 0
        self.dims = [x]
    }
    
    /// Point in more than 2 dimensions
    /// - Parameter multipleDimensions: An containing the coordinates: `[x, y, z, ...]`
    public init(multipleDimensions: [BigDouble]) {
        self.x = multipleDimensions.first ?? 0
        self.y = multipleDimensions.count > 1 ? multipleDimensions[1] : 0
        self.dims = multipleDimensions
    }
}
