//
//  Parser.swift
//  
//
//  Created by Arthur Guiot on 2019-12-26.
//

import Foundation

public class Parser {
    var tokens: [Token]
    init(_ str: String) {
        let src = "x+2 - (3*4)=2"
        let lexer = Lexer(input: src)
        self.tokens = lexer.tokenize()
        
        self.grouper = Grouper(tokens: tokens)
    }
    init(tokens: [Token]) {
        self.tokens = tokens
        self.grouper = Grouper(tokens: tokens)
    }
    
    var grouper: Grouper
    var groups: [Group]!
    func parse() throws -> [Node] {
        self.groups = try grouper.group()
        // Creates an array of Node. If it's an operator or something else, it will give a `nil`
        let qp = self.quickParsing(self.groups)
        
        var nodes = [Node]()
        
        while index < qp.count {
            let current = qp[index]
            if current == nil {
                let m1 = qp[index - 1]
                let p1 = qp[index + 1]
                
                let node = try self.groups[index].toNode(lhs: m1, rhs: p1)
                nodes.append(node)
            } else {
//                nodes.append(current!)
            }
            
            index += 1
        }
        return nodes
    }
    
    var index = 0
    
    func nextGroup() -> Group? {
        guard index < groups.count - 1 else { return nil }
        index += 1
        return groups[index]
    }
    var currentGroup: Group {
        return self.groups[index]
    }
    
    func quickParsing(_ gs: [Group]) -> [Node?] {
        return gs.map { try? $0.toNode(lhs: nil, rhs: nil) }
    }
}
