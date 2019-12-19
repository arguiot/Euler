//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2019-12-19.
//

import Foundation

enum Errors: Error {
    case UnexpectedToken
    case UndefinedOperator(String)
    
    case ExpectedCharacter(Character)
    case ExpectedExpression
    case ExpectedArgumentList
    case ExpectedFunctionName
}

class Parser {
    let tokens: [Token]
    var index = 0
    
    init(tokens: [Token]) {
        self.tokens = tokens
    }
    
    func peekCurrentToken() -> Token {
        return tokens[index]
    }
    
    func popCurrentToken() -> Token {
        index += 1
        return tokens[index]
    }
    
    func parseNumber() throws -> Node {
        guard case let Token.Number(value) = popCurrentToken() else {
            throw Errors.UnexpectedToken
        }
        return ConstantNode(value)
    }
    
    func parseExpression() throws -> Node {
        let node = try parsePrimary()
        return try parseBinaryOp(node: node)
    }
    
    func parseParens() throws -> Node {
        guard case Token.ParensOpen = popCurrentToken() else {
            throw Errors.ExpectedCharacter("(")
        }
        
        let exp = try parseExpression()

        guard case Token.ParensClose = popCurrentToken() else {
            throw Errors.ExpectedCharacter(")")
        }
    
        return exp
    }
    
    func parseIdentifier() throws -> Node {
        guard case let Token.Identifier(name) = popCurrentToken() else {
            throw Errors.UnexpectedToken
        }

        guard case Token.ParensOpen = peekCurrentToken() else {
            return SymboleNode(name)
        }
        popCurrentToken()
        
        var arguments = [Node]()
        if case Token.ParensClose = peekCurrentToken() {
        }
        else {
            while true {
                let argument = try parseExpression()
                arguments.append(argument)
                
                if case Token.ParensClose = peekCurrentToken() {
                    break
                }
                
                guard case Token.Comma = popCurrentToken() else {
                    throw Errors.ExpectedArgumentList
                }
            }
        }
        
        popCurrentToken()
        return FunctionNode(name, args: arguments)
    }
    
    func parsePrimary() throws -> Node {
        switch (peekCurrentToken()) {
        case .Identifier:
            return try parseIdentifier()
        case .Number:
            return try parseNumber()
        case .ParensOpen:
            return try parseParens()
        default:
            throw Errors.ExpectedExpression
        }
    }
    
    let operatorPrecedence: [String: Int] = [
        "+": 20,
        "-": 20,
        "*": 40,
        "/": 40
    ]
    
    func getCurrentTokenPrecedence() throws -> Int {
        guard index < tokens.count else {
            return -1
        }
        
        guard case let Token.Other(op) = peekCurrentToken() else {
            return -1
        }
        
        guard let precedence = operatorPrecedence[op] else {
            throw Errors.UndefinedOperator(op)
        }

        return precedence
    }
    
    func parseBinaryOp(node: Node, exprPrecedence: Int = 0) throws -> Node {
        var lhs = node
        while true {
            let tokenPrecedence = try getCurrentTokenPrecedence()
            if tokenPrecedence < exprPrecedence {
                return lhs
            }
            
            guard case let Token.Other(op) = popCurrentToken() else {
                throw Errors.UnexpectedToken
            }
            
            var rhs = try parsePrimary()
            let nextPrecedence = try getCurrentTokenPrecedence()
            
            if tokenPrecedence < nextPrecedence {
                rhs = try parseBinaryOp(node: rhs, exprPrecedence: tokenPrecedence+1)
            }
            lhs = OperatorNode(op, children: [lhs, rhs])
        }
    }
    
    func parsePrototype() throws -> Node {
        guard case let Token.Identifier(name) = popCurrentToken() else {
            throw Errors.ExpectedFunctionName
        }
        
        guard case Token.ParensOpen = popCurrentToken() else {
            throw Errors.ExpectedCharacter("(")
        }
        
        var argumentNames = [SymboleNode]()
        while case let Token.Identifier(name) = peekCurrentToken() {
            popCurrentToken()
            argumentNames.append(SymboleNode(name))
            
            if case Token.ParensClose = peekCurrentToken() {
                break
            }
            
            guard case Token.Comma = popCurrentToken() else {
                throw Errors.ExpectedArgumentList
            }
        }
        
        // remove ")"
        popCurrentToken()
        
        return FunctionNode(name, args: argumentNames)
    }
    
    func parseDefinition() throws -> FunctionNode {
        popCurrentToken()
        let prototype = try parsePrototype()
        let body = try parseExpression()
        return FunctionNode(prototype.content, args: [body])
    }
    
    func parseTopLevelExpr() throws -> ExpressionNode {
        let body = try parseExpression()
        return ExpressionNode(body)
    }
    
    func parse() throws -> [Any] {
        index = 0
        
        var nodes = [Any]()
        while index < tokens.count {
            switch peekCurrentToken() {
            case .Define:
                let node = try parseDefinition()
                nodes.append(node)
            default:
                let expr = try parseExpression()
                nodes.append(expr)
            }
        }
        
        return nodes
    }
}
