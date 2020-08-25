//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-02-07.
//

import Foundation
/// A helper class to parse and manipulate math expressions
public class Expression: NSObject {
    /// The expression node that contains the expression
    public var node: ExpressionNode
    
    /// Creates an `Expression` with the string representation of an expression
    public init(_ str: String) throws {
        let p = Parser(str)
        let expression = try p.parse()
        let comp = expression.compile()
        
        self.node = ExpressionNode(comp)
    }
    /// Creates an `Expression` from `$\LaTeX$`
    public init(latex: String) throws {
        let p = Parser(latex: latex)
        let expression = try p.parse()
        let comp = expression.compile()
        
        self.node = ExpressionNode(comp)
    }
    
    /// Returns all the symbols from the expression.
    ///
    /// Useful when you want to get a list of possible parameters
    ///
    public var symbols: [SymbolNode] {
        func symbolChildren(node: Node) -> [SymbolNode] {
            var out = [SymbolNode]()
            guard !(node is SymbolNode) else { return [node as! SymbolNode] }
            node.children.forEach { (child) in
                if child is SymbolNode {
                    out.append(child as! SymbolNode)
                } else {
                    out.append(contentsOf: symbolChildren(node: child))
                }
            }
            return out
        }
        
        return symbolChildren(node: self.node).map(\.content).uniques.map { SymbolNode($0) }
    }
}
