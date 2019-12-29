//
//  ExpressionNode.swift
//  
//
//  Created by Arthur Guiot on 2019-12-17.
//

import Foundation

/// An ExpressionNode is a Node containing 1 or more expression.
public class ExpressionNode: NSObject, Node {
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
    public var type: String { "ExpressionNode" }
    
    /// Array of Node, containing the expressions
    public var children = [Node]()
    
    /// Create a ExpressionNode
    /// - Parameter nodes: a Node of any type
    public init(_ nodes: Node...) {
        self.children = nodes
    }
    /// Create a ExpressionNode
    /// - Parameter nodes: an array of Node of any type
    public init(_ nodes: [Node]) {
        self.children = nodes
    }
    
    /// Compiles ExpressionNode to simpler node (useless here, but required by protocol)
    public func compile() -> Node {
        self.children = self.children.map { $0.compile() }
        return self
    }
    /// Converts ExpressionNode to BigNumber
    public func evaluate(_ params: [String: BigNumber]) -> BigNumber {
        return self.children.first?.evaluate(params) ?? .zero
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
    public override var type: String { "ParenthesisNode" }
}
