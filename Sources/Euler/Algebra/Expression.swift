//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-02-07.
//

import Foundation

public class Expression: NSObject {
    var node: ExpressionNode
    init(_ str: String) throws {
        let p = Parser(str)
        let expression = try p.parse()
        let comp = expression.compile()
        
        self.node = ExpressionNode(comp)
    }
}
