//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-03-05.
//

import Foundation

public class StringNode: NSObject, Node {
    /// The depth of the deepest children of the `Node` in a `Tree`
    public var maxDepth: Int?
    
    /// The depth of the `Node` in a `Tree`
    public var depth: Int?
    
    /// Gives String representation of the node
    public func toString() -> String {
        return "\"\(self.content)\""
    }
    /// Gives Tex (String) representation of the node
    public func toTex() -> String {
        return "\"\(self.content)\""
    }
    
    /// The `print()` description
    override public var description: String {
        return "\(self.type)[ \(self.toString()) ]"
    }
    /// The name of the Symbol (ex: `x` or `y`)
    public var content: String
    
    /// The name of the node
    public var type: String = "StringNode"
    
    /// Useless here, but it's to conform to the Node protocol
    public var children = [Node]()
    
    /// Create a SymbolNode
    /// - Parameter double: Floating point number
    public init(_ variable: String) {
        self.content = String(variable.dropFirst().dropLast())
    }
    
    /// Compiles SymbolNode to simpler node (useless here, but required by protocol)
    public func compile() -> Node {
        return self
    }
    /// Converts SymboleNode to BigNumber by replacing unknown value by their parameters. If it fails, it will return 0.
    public func evaluate(_ params: [String: BigNumber]) throws -> BigNumber {
        throw EvaluationError.ImpossibleOperation
    }
    
    /// Make sure that two `StringNode` are equals (used in pattern matching)
    ///
    /// If you want to search for patterns, build a sample tree with a `StringNode` with `"Any"` as `content`
    /// - Parameters:
    ///   - lhs: Any `StringNode`
    ///   - rhs: Any `StringNode`
    static func ==(lhs: StringNode, rhs: StringNode) -> Bool {
        guard lhs.content == rhs.content || lhs.content == "Any" || rhs.content == "Any" else { return false }
        guard lhs.children.count == rhs.children.count else { return false }
        for i in 0..<lhs.children.count {
            guard lhs.children[i] == rhs.children[i] else { return false }
        }
        return true
    }
}
