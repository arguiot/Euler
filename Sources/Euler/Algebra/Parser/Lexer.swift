//
//  Token.swift
//  
//
//  Created by Arthur Guiot on 2019-12-18.
//

import Foundation

/// Possible Tokens in a mathematical expression.
///
/// > This is part of the `Lexer`
public enum Token {
    case Symbol(String)
    case Number(Float)
    case ParensOpen
    case ParensClose
    case Other(String)
}

typealias TokenGenerator = (String) -> Token?
/// Helps the `Lexer` to convert text to `Token`
let tokenList: [(String, TokenGenerator)] = [
    ("[ \t\n]", { _ in nil }),
    ("[a-zA-Z][a-zA-Z0-9]*", { .Symbol($0) }),
    ("[0-9.]+", { (r: String) in .Number((r as NSString).floatValue) }),
    ("\\(", { _ in .ParensOpen }),
    ("\\)", { _ in .ParensClose }),
]

/// The `Lexer` is converting a sequence of characters (mathematical expression) into a sequence of `Token`
public class Lexer {
    let input: String
    /// Initializes the `Lexer`
    /// - Parameter input: The mathematical expression you want to parse
    init(input: String) {
        self.input = input
    }
    /// Tokenize the String input
    public func tokenize() -> [Token] {
        var tokens = [Token]()
        var content = input
        
        while (content.count > 0) {
            var matched = false
            
            for (pattern, generator) in tokenList {
                if let m = content.match(regex: pattern) {
                    if let t = generator(m) {
                        tokens.append(t)
                    }
                    let firstIndex = String.Index(encodedOffset: m.count - 1)
                    let index = content.index(after: firstIndex)
                    content = content.substring(from: index)
                    matched = true
                    break
                }
            }

            if !matched {
                let firstIndex = content.startIndex
                let index = content.index(after: firstIndex)
                tokens.append(.Other(content.substring(to: index)))
                content = content.substring(from: index)
            }
        }
        return tokens
    }
}
