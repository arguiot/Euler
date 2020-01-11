//
//  Tree.swift
//  
//
//  Created by Arthur Guiot on 2020-01-02.
//

import Foundation

/// A Tree object containing the Tree of a parsed expression. It helps to do various operations on the expression
internal class Tree: NSObject {
    var expression: ExpressionNode
    init(_ expr: ExpressionNode) {
        self.expression = expr
    }
    
    internal func switchChildren(node: Node) -> Node {
        node.children.reverse() // Switch all children
        return node
    }
    
    static internal func computeDepth(node: Node, depth: Int = 0) -> (Node, Int) {
        node.depth = depth
        var level = depth + 1
        if node.children.count == 0 {
            level = depth
        }
        for child in node.children {
            let (node, max) = Tree.computeDepth(node: child, depth: level)
            child.children = node.children
            child.maxDepth = max
        }
        node.maxDepth = node.children.map { ($0.maxDepth ?? 0) }.max()
        return (node, node.maxDepth ?? level)
    }
//    static func treeCallback(node: Node, _ callback: (Node) -> Node) -> Node {
//        //
//    }
}
