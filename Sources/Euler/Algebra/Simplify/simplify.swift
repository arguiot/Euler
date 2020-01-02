//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2019-12-30.
//

import Foundation

class Simplify {
    var expression: ExpressionNode
    init(_ expr: ExpressionNode) {
        self.expression = expr
    }
    
    func simple() -> ExpressionNode {
        let compiled = expression.compile()
        guard compiled is ExpressionNode else { return ExpressionNode(compiled) }
        return compiled as! ExpressionNode
    }
}
