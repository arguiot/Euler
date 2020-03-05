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
}
