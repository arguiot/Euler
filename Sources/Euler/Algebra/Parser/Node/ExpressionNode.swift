//
//  ExpressionNode.swift
//  
//
//  Created by Arthur Guiot on 2019-12-17.
//

import Foundation

/// An ExpressionNode is a Node containing 1 or more expression.
public class ExpressionNode: NSObject, Node {
    /// The depth of the deepest children of the `Node` in a `Tree`
    public var maxDepth: Int?
    
    /// The depth of the `Node` in a `Tree`
    public var depth: Int?
    
    /// Gives String representation of the node
    public func toString() -> String {
        let map = children.map { $0.toString() }
        return map.joined(separator: " = ")
    }
    /// Gives Tex (String) representation of the node
    public func toTex() -> String {
        let map = children.map { $0.toTex() }
        return map.joined(separator: " = ")
    }
    
    /// The `print()` description
    override public var description: String {
        return "\(self.type)[ \(self.toString()) ]"
    }
    
    /// Here it's useless, but it's required to conform to Node
    public var content: String = ""
    
    /// Name of the Node
    public var type: String { return "ExpressionNode" }
    
    /// Array of Node, containing the expressions
    public var children = [Node]()
    
    /// Create a ExpressionNode
    /// - Parameter nodes: a Node of any type
    public init(_ nodes: Node...) {
        self.children = nodes
//        var string = nodes.map { $0.toString() }.joined(separator: " = ")
//        string = string.replacingOccurrences(of: "^", with: "**")
//        nsExpression = NSExpression(format: string)
    }
    /// Create a ExpressionNode
    /// - Parameter nodes: an array of Node of any type
    public init(_ nodes: [Node]) {
        self.children = nodes
//        var string = nodes.map { $0.toString() }.joined(separator: " = ")
//        string = string.replacingOccurrences(of: "^", with: "**")
//        nsExpression = NSExpression(format: string)
    }
    
    /// Compiles ExpressionNode to simpler node (useless here, but required by protocol)
    public func compile() -> Node {
        guard let first = self.children.first else { return self }
        return first.compile()
    }
    /// Converts ExpressionNode to BigNumber
    public func evaluate(_ params: [String: BigNumber], _ fList: [String:(([CellValue]) throws -> CellValue)]) throws -> CellValue {
        guard let child = try self.children.first?.evaluate(params, fList) else { throw EvaluationError.missingChildren }
        return child
    }
    
//    internal var nsExpression: NSExpression
    
    /// Converts ExpressionNode to BigNumber
    public func evaluate(_ params: [String: BigNumber]) throws -> CellValue {
//        guard let value = nsExpression.expressionValue(with: params, context: nil) as? Double else { return try self.evaluate(params, Tables.functions) }
//        return CellValue(number: BN(value))
        return try self.evaluate(params, Tables.functions)
    }
}
/// A ParenthesisNode is an ExpressionNode used to treat parenthesis
public class ParenthesisNode: ExpressionNode {
    /// Gives String representation of the node
    public override func toString() -> String {
        let map = children.map { $0.toString() }
        return "(\(map.joined(separator: ", ")))"
    }
    /// Gives Tex (String) representation of the node
    public override func toTex() -> String {
        let map = children.map { $0.toTex() }
        return "(\(map.joined(separator: ", ")))"
    }
    
    /// Name of the Node
    public override var type: String { return "ParenthesisNode" }
}
