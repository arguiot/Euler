//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2019-12-16.
//

import Foundation

/// This is a Node object that represents a number as a BigDouble
public class ConstantNode: NSObject, Node {
    /// The depth of the deepest children of the `Node` in a `Tree`
    public var maxDepth: Int?
    
    /// The depth of the `Node` in a `Tree`
    public var depth: Int?
    
    /// Gives String representation of the node
    public func toString() -> String {
        return self.content
    }
    /// Gives Tex (String) representation of the node
    public func toTex() -> String {
        return self.content
    }
    
    override public var description: String {
        return "\(self.type)[ \(self.toString()) ]"
    }
    
    public var content: String
    
    public var type: String = "ConstantNode"
    
    public var children = [Node]()
    
    /// Create a ConstantNode
    /// - Parameter bn: BigNumber/BigDouble
    public init(_ bn: BigNumber) {
        self.content = bn.description
    }
    /// Create a ConstantNode
    /// - Parameter int: Integer
    public init(_ int: Int) {
        self.content = BigInt(int).description
    }
    /// Create a ConstantNode
    /// - Parameter float: Floating point number
    public init(_ float: Float) {
        self.content = BigFloat(Double(float)).description
    }
    /// Create a ConstantNode
    /// - Parameter double: Floating point number
    public init(_ double: Double) {
        self.content = BigDouble(double).description
    }
    
    /// Compiles ConstantNode to simpler node (useless here, but required by protocol)
    public func compile() -> Node {
        return self
    }
    /// Converts ConstantNode to BigNumber
    public func evaluate(_ params: [String: BigNumber]) -> BigNumber {
        return BigNumber(self.content) ?? .zero
    }
}
