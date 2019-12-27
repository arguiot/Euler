//
//  Parser.swift
//  
//
//  Created by Arthur Guiot on 2019-12-26.
//

import Foundation

fileprivate enum ParseError: Error {
    case UnexpectedOperator
    case FailedToParse
    case UnexpectedError
}

public class Parser {
    internal var tokens: [Token]
    public init(_ str: String) {
        let src = "x+2 - (3*4)=2"
        let lexer = Lexer(input: src)
        self.tokens = lexer.tokenize()
        
        self.grouper = Grouper(tokens: tokens)
    }
    public init(tokens: [Token]) {
        self.tokens = tokens
        self.grouper = Grouper(tokens: tokens)
    }
    
    internal var grouper: Grouper
    internal var groups: [Group]!
    public func parse() throws -> [Node] {
        self.groups = try grouper.group()
        // Creates an array of Node. If it's an operator or something else, it will give a `nil`
        let chain = try chainMaker()
        let link = try linker(chain: chain)
        
        return link
    }
    
    internal func linker(chain: [Node]) throws -> [Node] {
        let priorities = [
            "+": 1,
            "-": 1,
            "*": 2,
            "/": 2,
            "^": 3,
            "=": 4
        ]
        var nodes: [Node] = [chain[0]]
        
        while index < chain.count - 1 { // Iterating over the array, ommiting last element
            guard let current = nodes.last else { throw ParseError.UnexpectedError }
            let next = chain[index + 1]
            
            if current is OperatorNode && next is OperatorNode {
                guard let p1 = priorities[current.content] else { throw ParseError.UnexpectedOperator }
                guard let p2 = priorities[next.content] else { throw ParseError.UnexpectedOperator }
                
                if p1 < p2 { // So we'll chose next over current
                    let choosedSign = current.content
                    let lhs = current.children[0]
                    let mhs = current.children[1]
                    let rhs = next.children[1]
                    
//                    guard mhs == next.children[0] else {
//                        throw ParseError.FailedToParse
//                    }
                    
                    let op1 = OperatorNode(choosedSign, children: [mhs, rhs])
                    let op2 = OperatorNode(next.content, children: [lhs, op1])
                    
                    nodes.append(op2)
                } else {
                    let choosedSign = next.content
                    let lhs = current.children[0]
                    let mhs = current.children[1]
                    let rhs = next.children[1]
                    
//                    guard mhs == next.children[0] else {
//                        throw ParseError.FailedToParse
//                    }
                    
                    let op1 = OperatorNode(current.content, children: [lhs, mhs])
                    let op2 = OperatorNode(choosedSign, children: [op1, rhs])
                    
                    nodes.append(op2)
                }
            }
            
            index += 1
        }
        return nodes
    }
    internal func chainMaker() throws -> [Node] {
        let qp = self.quickParsing(self.groups)
                
        var nodes = [Node]()
        
        while index < qp.count {
            let current = qp[index]
            if current == nil {
                let m1 = qp[index - 1]
                let p1 = qp[index + 1]
                
                let node = try self.groups[index].toNode(lhs: m1, rhs: p1)
                nodes.append(node)
            }
            
            index += 1
        }
        // Resetting the index
        index = 0
        return nodes
    }
    
    private var index = 0
    
    private func quickParsing(_ gs: [Group]) -> [Node?] {
        return gs.map { try? $0.toNode(lhs: nil, rhs: nil) }
    }
}
