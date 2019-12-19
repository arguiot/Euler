//
//  ExpressionNode.swift
//  
//
//  Created by Arthur Guiot on 2019-12-17.
//

import Foundation

public class ExpressionNode: Node {
    /// Gives String representation of the node
    public func toString() -> String {
        return children.reduce("") { $0 + $1.toString() }
    }
    /// Gives Tex (String) representation of the node
    public func toTex() -> String {
        return children.reduce("") { $0 + $1.toTex() }
    }
    
    public var content: String = ""
    
    public var type: String = "ExpressionNode"
    
    public var children = [Node]()
    
    /// Create a ExpressionNode
    /// - Parameter nodes: a Node of any type
    public init(_ nodes: Node...) {
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
public typealias ParenthesisNode = ExpressionNode
