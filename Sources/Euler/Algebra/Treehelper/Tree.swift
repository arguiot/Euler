//
//  Tree.swift
//  
//
//  Created by Arthur Guiot on 2020-01-02.
//

import Foundation

/// A Tree object containing the Tree of a parsed expression. It helps to do various operations on the expression
class Tree: NSObject {
    var expression: ExpressionNode
    init(_ expr: ExpressionNode) {
        self.expression = expr
    }
    
    func switchChildren(node: Node) -> Node {
        node.children.reverse() // Switch all children
        return node
    }
    
    
//    static func treeCallback(node: Node, _ callback: (Node) -> Node) -> Node {
//        //
//    }
}
