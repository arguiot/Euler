//
//  Grouper.swift
//  
//
//  Created by Arthur Guiot on 2019-12-19.
//

import Foundation

enum ParseError: Error {
    case UnexpectedToken
    case UndefinedOperator(String)
    
    case ExpectedCharacter(Character)
    case ExpectedExpression
    case ExpectedArgumentList
    case ExpectedFunctionName
}

class Group: NSObject {
    enum `Type` {
        case Symbol
        case Function
        case Operator
        case Number
        case UnParsed
    }
    var tokens: [Token]
    var type: Type
    init(tokens: [Token], type: Type) {
        self.tokens = tokens
        self.type = type
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
