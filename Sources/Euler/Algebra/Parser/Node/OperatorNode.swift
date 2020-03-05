//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2019-12-16.
//

import Foundation
/// A type of `Node` for representing mathematical operations
public class OperatorNode: NSObject, Node {
    /// The depth of the deepest children of the `Node` in a `Tree`
    public var maxDepth: Int?
    
    /// The depth of the `Node` in a `Tree`
    public var depth: Int?
    
    
    /// Gives String representation of the node
    public func toString() -> String {
        guard self.children.count == 2 else { return "Unable to convert to String" }
        let c1 = self.children[0].toString()
        let c2 = self.children[1].toString()
        return "\(c1) \(self.content) \(c2)"
    }
    /// Gives Tex (String) representation of the node
    public func toTex() -> String {
        guard self.children.count == 2 else { return "Unable to convert to LaTex" }
        let c1 = self.children[0].toString()
        let c2 = self.children[1].toString()

        if self.content == "/" {
            return "\\frac{\(c1)}{\(c2)}"
        }
        var op = self.content
        if op == "*" {
            op = "\\times"
        }
        
        return "\(c1) \(op) \(c2)"
    }
    /// The `print()` description
    override public var description: String {
        return "\(self.type)[ \(self.toString()) ]"
    }
    /// The sign of the operator (ex: `"+"` or `"*"`)
    public var content: String
    
    /// The name of the node
    public var type: String = "OperatorNode"
    
    /// The left and right hand sides of the operator
    public var children = [Node]()
    
    /// Creates an OperatorNode
    /// - Parameters:
    ///   - op: The symbol of the operator, ex: +, -, /, ...
    ///   - children: The 2 affected nodes
    public init(_ op: String, children: [Node]) {
        self.content = op
        self.children = children
    }
    
    /// Compiles ConstantNode to simpler node (useless here, but required by protocol)
    public func compile() -> Node {
        guard self.children.count == 2 else { return self }
        let c1 = self.children[0].compile()
        let c2 = self.children[1].compile()
        
        if c1.toString() == c2.toString() {
            switch self.content {
            case "+":
                return OperatorNode("*", children: [ConstantNode(2), c1]).compile()
            case "-":
                return NullNode()
            case "/":
                return ConstantNode(1)
            case "*":
                return OperatorNode("^", children: [c1, ConstantNode(2)])
            default:
                break
            }
        }
        
        if c1.type == "ConstantNode" && c2.type == "ConstantNode" {
            guard let ev1 = try? c1.evaluate([:]) else { return self }
            guard let ev2 = try? c2.evaluate([:]) else { return self }
            switch self.content {
            case "+":
                return ConstantNode(ev1 + ev2)
            case "-":
                return ConstantNode(ev1 - ev2)
            case "/":
                return ConstantNode(ev1 / ev2)
            case "*":
                return ConstantNode(ev1 * ev2)
            case "^":
                return ConstantNode(ev1 ** ev2)
            default:
                break
            }
        }
        return OperatorNode(self.content, children: [c1, c2])
    }
    /// Converts OperatorNode to BigNumber
    public func evaluate(_ params: [String: BigNumber]) throws -> BigNumber {
        guard self.children.count == 2 else { throw EvaluationError.missingChildren }
        let ev1 = try self.children[0].evaluate(params)
        let ev2 = try self.children[1].evaluate(params)
        
        switch self.content {
        case "+":
            return ev1 + ev2
        case "-":
            return ev1 - ev2
        case "/":
            return ev1 / ev2
        case "*":
            return ev1 * ev2
        case "^":
            return ev1 ** ev2
        default:
            return ev1 + ev2
        }
    }
}
