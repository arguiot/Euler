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
    
    internal func replaceDeepestRight(_ node: Node) {
        guard children.count == 2 else { return }
        if children[1] is OperatorNode {
            (children[1] as! OperatorNode).replaceDeepestRight(node)
        } else {
            children[1] = node
        }
    }
    
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
            case "!":
                return ConstantNode(1) // 0! = 1
            case "%":
                return ConstantNode(0) // x mod x = 0
            default:
                break
            }
        }
        
        if c1.type == "ConstantNode" && c2.type == "ConstantNode" {
            do {
                guard let ev1 = try c1.evaluate([:], Tables.functions).number else { return self }
                guard let ev2 = try c2.evaluate([:], Tables.functions).number else { return self }
                switch self.content {
                case "+":
                    return ConstantNode(ev1 + ev2)
                case "-":
                    return ConstantNode(ev1 - ev2)
                case "/":
                    guard ev2 != .zero else {
                        return self
                    }
                    return ConstantNode(ev1 / ev2)
                case "*":
                    return ConstantNode(ev1 * ev2)
                case "^":
                    return ConstantNode(ev1 ** ev2)
                case "!":
                    guard ev1 >= .zero else { throw EvaluationError.ImpossibleOperation }
                    let i = ev1.rounded()
                    if BN(i) == ev1 {
                        return ConstantNode(factorial(i))
                    }
                
                    return ConstantNode(gamma(ev1 + 1))
                case "%":
                    return ConstantNode(ev1 % ev2)
                default:
                    break
                }
            } catch {
                return self
            }
        }
        return OperatorNode(self.content, children: [c1, c2])
    }
    /// Converts OperatorNode to BigNumber
    public func evaluate(_ params: [String: BigNumber], _ fList: [String:(([CellValue]) throws -> CellValue)]) throws -> CellValue {
        guard self.children.count == 2 else { throw EvaluationError.missingChildren }
        guard var ev1 = try self.children[0].evaluate(params, fList).number else { throw EvaluationError.missingChildren }
        guard var ev2 = try self.children[1].evaluate(params, fList).number else { throw EvaluationError.missingChildren }
        
        ev1 = ev1.simplified
        ev2 = ev2.simplified
        
        switch self.content {
        case "+":
            return CellValue(number: ev1 + ev2)
        case "-":
            return CellValue(number: ev1 - ev2)
        case "/":
            guard ev2 != .zero else {
                throw EvaluationError.ImpossibleOperation
            }
            return CellValue(number: ev1 / ev2)
        case "*":
            return CellValue(number: ev1 * ev2)
        case "^":
            return CellValue(number: ev1 ** ev2)
        case "!":
            guard ev1 >= .zero else { throw EvaluationError.ImpossibleOperation }
            let i = ev1.rounded()
            if BN(i) == ev1 {
                return CellValue(number: BigNumber(factorial(i)))
            }
            return CellValue(number: gamma(ev1 + 1))
        case "%":
            return CellValue(number: ev1 % ev2)
        default:
            throw EvaluationError.ImpossibleOperation
        }
    }
}
