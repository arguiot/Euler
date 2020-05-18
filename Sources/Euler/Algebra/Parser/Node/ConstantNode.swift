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
    
    public static var any: ConstantNode {
        let c = ConstantNode(0)
        c.content = "Any"
        return c
    }
    
    public var content: String
    
    public var type: String = "ConstantNode"
    
    public var children = [Node]()
    
    /// Create a ConstantNode
    /// - Parameter bn: BigNumber/BigDouble
    public init(_ bn: BigNumber) {
        let desc = bn.description
        if desc.contains("/") {
            self.content = bn.decimalDescription
        } else {
            self.content = desc
        }
    }
    /// Create a ConstantNode
    /// - Parameter int: Integer
    public init(_ int: Int) {
        self.content = BigInt(int).description
    }
    /// Create a ConstantNode
    /// - Parameter float: Floating point number
    public init(_ float: Float) {
        let bn = BigFloat(Double(float))
        let desc = bn.description
        if desc.contains("/") {
            self.content = bn.decimalDescription
        } else {
            self.content = desc
        }
    }
    /// Create a ConstantNode
    /// - Parameter double: Floating point number
    public init(_ double: Double) {
        let bn = BigDouble(double)
        let desc = bn.description
        if desc.contains("/") {
            self.content = bn.decimalDescription
        } else {
            self.content = desc
        }
    }
    
    /// Compiles ConstantNode to simpler node (useless here, but required by protocol)
    public func compile() -> Node {
        return self
    }
    /// Converts ConstantNode to BigNumber
    public func evaluate(_ params: [String: BigNumber], _ fList: [String:(([CellValue]) throws -> CellValue)]) throws -> CellValue {
        guard let n = BigNumber(self.content) else { throw EvaluationError.ImpossibleOperation }
        return CellValue(number: n)
    }
    
    /// Make sure that two `ConstantNode` are equals (used in pattern matching)
    ///
    /// If you want to search for patterns, build a sample tree with a `ConstantNode` with `"Any"` as `content`
    /// - Parameters:
    ///   - lhs: Any `ConstantNode`
    ///   - rhs: Any `ConstantNode`
    static func ==(lhs: ConstantNode, rhs: ConstantNode) -> Bool {
        guard lhs.content == rhs.content || lhs.content == "Any" || rhs.content == "Any" else { return false }
        guard lhs.children.count == rhs.children.count else { return false }
        for i in 0..<lhs.children.count {
            guard lhs.children[i] == rhs.children[i] else { return false }
        }
        return true
    }
}
