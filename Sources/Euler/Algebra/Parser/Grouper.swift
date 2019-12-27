//
//  Grouper.swift
//  
//
//  Created by Arthur Guiot on 2019-12-19.
//

import Foundation

fileprivate enum GroupError: Error {
    case UnexpectedToken
    case UndefinedOperator(String)
    
    case ExpectedCharacter(Character)
    case ExpectedExpression
    case ExpectedArgumentList
    case ExpectedFunctionName
    case UnexpectedError
}

class Group: NSObject {
    enum `Type` {
        case Symbol
        case Function
        case Operator
        case Number
        case UnParsed
        case Equal
    }
    var tokens: [Token]
    var type: Type
    init(tokens: [Token], type: Type) {
        self.tokens = tokens
        self.type = type
    }
    
    func compile() throws {
        if self.type == .UnParsed {
            let ops = [
                "+",
                "-",
                "*",
                "/",
                "^"
            ]
            guard tokens.count == 1 else { throw GroupError.UnexpectedError }
            guard case let Token.Other(token) = tokens[0] else { throw GroupError.UnexpectedError }
            
            if ops.contains(token) {
                self.type = .Operator
            } else if token == "=" {
                self.type = .Equal
            }
        }
    }
    func toNode(lhs: Node?, rhs: Node?) throws -> Node {
        try self.compile()
        switch self.type {
        case .Symbol:
            return try self.toSymbol()
        case .Function:
            throw GroupError.ExpectedExpression
        case .Operator:
            guard lhs != nil && rhs != nil else { throw GroupError.ExpectedArgumentList }
            return try self.toOperator(lhs: lhs!, rhs: rhs!)
        case .Number:
            return try self.toNumber()
        case .UnParsed:
            throw GroupError.ExpectedExpression
        case .Equal:
            guard lhs != nil && rhs != nil else { throw GroupError.ExpectedArgumentList }
//            return ExpressionNode(lhs!, rhs!)
            return OperatorNode("=", children: [lhs!, rhs!])
        }
    }
    
    func toSymbol() throws -> SymbolNode {
        guard tokens.count == 1 else { throw GroupError.UnexpectedError }
        guard case let Token.Symbol(token) = tokens[0] else { throw GroupError.UnexpectedError }
        return SymbolNode(token)
    }
    func toOperator(lhs: Node, rhs: Node) throws -> OperatorNode {
        guard tokens.count == 1 else { throw GroupError.UnexpectedError }
        guard case let Token.Other(token) = tokens[0] else { throw GroupError.UnexpectedError }
        return OperatorNode(token, children: [lhs, rhs])
    }
    func toNumber() throws -> ConstantNode {
        guard tokens.count == 1 else { throw GroupError.UnexpectedError }
        guard case let Token.Number(token) = tokens[0] else { throw GroupError.UnexpectedError }
        return ConstantNode(token)
    }
    
    override var description : String {
        get {
            return "Euler.Group(tokens: \(self.tokens), type: \(self.type))"
        }
    }
}

class Grouper {
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
    
    var tokensAvailable: Bool {
        return index < tokens.count
    }
    
    var level = 0
    
    func group() throws -> [Group] {
        index = 0
        
        var temp = [[Token]]()
        
        var groups = [Group]()
        while tokensAvailable {
            let token = peekCurrentToken()
            index += 1
            if level > 0 {
                switch token {
                case .ParensOpen:
                    level += 1
                    temp.append([Token]())
                case .ParensClose:
                    level -= 1
                    
                    groups.append(Group(tokens: temp[level], type: .UnParsed))
                default:
                    temp[level - 1].append(token)
                }
                continue
            }
            switch token {
            case .Symbol(_):
                let g = Group(tokens: [token], type: .Symbol)
                 groups.append(g)
            case .Number(_):
                let g = Group(tokens: [token], type: .Number)
                 groups.append(g)
            case .ParensOpen:
                level += 1
                temp.append([Token]())
            case .ParensClose:
                level -= 1
                
                groups.append(Group(tokens: temp[level], type: .UnParsed))
            case .Other(_):
                let g = Group(tokens: [token], type: .UnParsed)
                groups.append(g)
            }
        }
        
        return groups
    }
}
