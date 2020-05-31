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
        guard let number = self.number else { return self.content }
        if BN(number.rounded()) == number {
            return number.rounded().asString(radix: 10)
        }
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
    
    /// Content of the node
    ///
    /// String representation of the number. This is the principal conten of the node, but for even better precision, computation rely on `number`
    ///
    public var content: String
    
    /// Type of the node
    public var type: String = "ConstantNode"
    
    /// Children of the node
    public var children = [Node]()
    
    /// Number represented by the node.
    ///
    /// Optional because it may fail
    ///
    public var number: BigDouble?
    
    /// Create a ConstantNode
    /// - Parameter bn: BigNumber/BigDouble
    public init(_ bn: BigNumber) {
        self.number = bn
        
        let desc = bn.description
        if desc.contains("/") {
            self.content = bn.decimalDescription
        } else {
            self.content = desc
        }
    }
    /// Create a ConstantNode
    /// - Parameter str: String
    public init(_ str: String) {
        self.content = str
        
        self.number = BigDouble(str)
    }
    /// Create a ConstantNode
    /// - Parameter int: Integer
    public init(_ int: Int) {
        self.number = BigNumber(int)
        self.content = String(int)
    }
    /// Create a ConstantNode
    /// - Parameter float: Floating point number
    public init(_ float: Float) {
        self.content = String(float)
        self.number = BigDouble(Double(float))
    }
    /// Create a ConstantNode
    /// - Parameter double: Floating point number
    public init(_ double: Double) {
        self.content = String(double)
        self.number = BigDouble(Double(double))
    }
    
    /// Compiles ConstantNode to simpler node (useless here, but required by protocol)
    public func compile() -> Node {
        return self
    }
    /// Converts ConstantNode to BigNumber
    public func evaluate(_ params: [String: BigNumber], _ fList: [String:(([CellValue]) throws -> CellValue)]) throws -> CellValue {
        guard let n = self.number else { throw EvaluationError.ImpossibleOperation }
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
