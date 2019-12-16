//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2019-12-16.
//

import Foundation

public class ConstantNode: Node {
    /// Gives String representation of the node
    public func toString() -> String {
        return self.content
    }
    /// Gives Tex (String) representation of the node
    public func toTex() -> String {
        return self.content
    }
    
    internal var content: String
    
    public var type: String = "ConstantNode"
    
    public var children = [Node]()
    
    /// Create a ConstantNode
    /// - Parameter bn: BigNumber/BigDouble
    public init(_ bn: BigNumber) {
        self.content = bn.decimalDescription
    }
    /// Create a ConstantNode
    /// - Parameter int: Integer
    public init(_ int: Int) {
        self.content = String(int)
    }
    /// Create a ConstantNode
    /// - Parameter float: Floating point number
    public init(_ float: Float) {
        self.content = String(float)
    }
    /// Create a ConstantNode
    /// - Parameter double: Floating point number
    public init(_ double: Double) {
        self.content = String(double)
    }
    
    /// Converts ConstantNode to BigNumber
    public func evaluate() -> BigNumber? {
        return BigNumber(self.content)
    }
}
