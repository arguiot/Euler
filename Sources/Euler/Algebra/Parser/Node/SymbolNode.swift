//
//  SymbolNode.swift
//  
//
//  Created by Arthur Guiot on 2019-12-16.
//

import Foundation
/// A `Node` for mathematical symbols such as `x` or `y`
public class SymbolNode: NSObject, Node {
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
    
    /// The `print()` description
    override public var description: String {
        return "\(self.type)[ \(self.toString()) ]"
    }
    /// The name of the Symbol (ex: `x` or `y`)
    public var content: String
    
    /// The name of the node
    public var type: String = "SymbolNode"
    
    /// Useless here, but it's to conform to the Node protocol
    public var children = [Node]()
    
    /// Create a SymbolNode
    /// - Parameter double: Floating point number
    public init(_ variable: String) {
        self.content = variable
    }
    
    /// Compiles SymbolNode to simpler node (useless here, but required by protocol)
    public func compile() -> Node {
        return self
    }
    /// Converts SymboleNode to BigNumber by replacing unknown value by their parameters. If it fails, it will return 0.
    public func evaluate(_ params: [String: BigNumber], _ fList: [String:(([CellValue]) throws -> CellValue)]) throws -> CellValue {
        if let n = params[self.content] {
            return CellValue(number: n)
        }
        if self.content == "pi" {
            return CellValue(number: pi)
        }
        if self.content == "e" {
            return CellValue(number: e)
        }
        throw EvaluationError.parameters(self.content)
    }
    
    /// Make sure that two `SymbolNode` are equals (used in pattern matching)
    ///
    /// If you want to search for patterns, build a sample tree with a `SymbolNode` with `"Any"` as `content`
    /// - Parameters:
    ///   - lhs: Any `SymbolNode`
    ///   - rhs: Any `SymbolNode`
    static func ==(lhs: SymbolNode, rhs: SymbolNode) -> Bool {
        guard lhs.content == rhs.content || lhs.content == "Any" || rhs.content == "Any" else { return false }
        guard lhs.children.count == rhs.children.count else { return false }
        for i in 0..<lhs.children.count {
            guard lhs.children[i] == rhs.children[i] else { return false }
        }
        return true
    }
}
