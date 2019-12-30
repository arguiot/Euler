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

/// The `Parser` converts a mathematical expression to a tree.
///
/// As humans, we read and write math as a line of text. If you were to type a math expression, it would probably look something like this:
/// ```
/// (1 + 2) - abs(-3) * x²
/// ```
/// You could also just look at that math expression and use your intuition to prioritize where to start simplifying. But a computer will understand the expression best when it’s stored in a tree. These trees can be surprisingly complicated — even a short expression like `(1 + 2) - abs(-3) * x²` becomes this tree:
/// ```
///           (-)
///          /   \
///         ( )   (*)
///        /     /   \
///      (+)    abs   (^)
///     /   \    |   /   \
///    1     2  -3  x     2
/// ```
///
public class Parser {
    /// List of used tokens by the `Parser`
    internal var tokens: [Token]
    /// Initialize `Parser` with a mathematical expression as a String ( ASCIIMath)
    /// - Parameter str: ASCIIMath expression
    public init(_ str: String) {
        let lexer = Lexer(input: str)
        self.tokens = lexer.tokenize()
        
        self.grouper = Grouper(tokens: tokens)
    }
    /// Initialize `Parser` with a list of tokens given by the `Lexer`
    /// - Parameter tokens: Array of `Token` given by the `Lexer`
    public init(tokens: [Token]) {
        self.tokens = tokens
        self.grouper = Grouper(tokens: tokens)
    }
    
    /// Grouper object containing the `Token`
    internal var grouper: Grouper
    /// The array of `Group` given by the Grouper. It becomes active after `parse()`
    internal var groups: [Group]!
    /// This function will be in charge of parsing the expression.
    ///
    /// After, initializing the `Parser`, use this function to get an ExpressionNode (aka expression tree).
    /// Here is a code example:
    /// ```swift
    /// let p = Parser("5.0 - sqrt(8) * 5 = x^2 - factorial(4)")
    /// let expression = try p.parse()
    /// ```
    public func parse() throws -> ExpressionNode {
        self.groups = try grouper.group()
        // Creates an array of Node. If it's an operator or something else, it will give a `nil`
        let chain = try chainMaker()
        let link = try linker(chain: chain)
        
        return link
    }
    
    /// Links the nodes to create a tree
    /// - Parameter chain: The chain given by `chainMaker`
    internal func linker(chain: [Node]) throws -> ExpressionNode {
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
                    
                    let op1 = OperatorNode(choosedSign, children: [lhs, mhs])
                    let op2 = OperatorNode(next.content, children: [op1, rhs])
                    
                    nodes.remove(at: 0) // Empty array
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
                    
                    nodes.remove(at: 0) // Empty array
                    nodes.append(op2)
                }
            }
            
            index += 1
        }
        return ExpressionNode(nodes)
    }
    /// Quickly grouping groups and Nodes together
    internal func chainMaker() throws -> [Node] {
        let quick = self.quickParsing(self.groups)
        let qp = try detectFunctions(parsed: quick)
        
        if qp.count == 1 {
            return qp.map{ $0! }
        }
        
        var nodes = [Node]()
        
        while index < qp.count {
            let current = qp[index]
            if current == nil {
                let m1 = qp[index - 1]
                guard index + 1 <= qp.count - 1 else { throw ParseError.FailedToParse }
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
    
    /// `Parser` index
    private var index = 0
    
    /// Transform Groups to Node
    /// - Parameter gs: Array of `Group` given by the `Grouper`
    private func quickParsing(_ gs: [Group]) -> [Node?] {
        return gs.map { try? $0.toNode(lhs: nil, rhs: nil) }
    }
    
    /// Detects functions and returning an array of Optional Node to work on.
    /// - Parameter parsed: Array of Node parsed by `quickParsing`
    private func detectFunctions(parsed: [Node?]) throws -> [Node?] {
        var nodes = parsed
        while index < nodes.count {
            let current = nodes[index]
            guard index + 1 <= nodes.count - 1 else {
                // Resetting the index
                index = 0
                return nodes
            }
            let next = nodes[index + 1]
            if current is SymbolNode && next is ParenthesisNode {
                self.groups.remove(at: index + 1)
                nodes.remove(at: index + 1)
                guard let name = current?.content else { throw ParseError.FailedToParse }
                guard let children = next?.children else { throw ParseError.FailedToParse }
                nodes[index] = FunctionNode(name, args: children)
            }
            index += 1
        }
        // Resetting the index
        index = 0
        return nodes
    }
}
