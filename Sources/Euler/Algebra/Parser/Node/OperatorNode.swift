//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2019-12-16.
//

import Foundation

class OperatorNode: NSObject, Node {
    
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
    
    override var description: String {
        return "\(self.type)[ \(self.toString()) ]"
    }
    public var content: String
    
    public var type: String = "OperatorNode"
    
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
        
        if c1.type == "ContantNode" && c2.type == "ContantNode" {
            let ev1 = c1.evaluate([:])
            let ev2 = c2.evaluate([:])
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
                return ConstantNode(ev1 + ev2)
            }
            
            
        }
        return self
    }
    /// Converts OperatorNode to BigNumber
    public func evaluate(_ params: [String: BigNumber]) -> BigNumber {
        guard self.children.count == 2 else { return .zero }
        let ev1 = self.children[0].evaluate(params)
        let ev2 = self.children[1].evaluate(params)
        
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
