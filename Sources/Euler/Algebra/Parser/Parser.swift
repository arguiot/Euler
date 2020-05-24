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
    internal init(tokens: [Token], context: Parser.ParseContext, grouper: Grouper, groups: [Group]?) {
        self.tokens = tokens
        self.context = context
        self.grouper = grouper
        self.groups = groups
    }
    
    /// List of used tokens by the `Parser`
    internal var tokens: [Token]
    
    
    /// Makes the difference between regular math equations and tables (excel like) formulas.
    public enum ParseContext {
        /// Regular math equation / expression
        case math
        /// Excel like formula
        ///
        /// example: `=SUM(A3:A5)`
        case tables
    }
    internal var context: ParseContext
    
    internal var tablesContext: Tables?
    
    /// Initialize `Parser` with a mathematical expression as a String ( ASCIIMath)
    /// - Parameter str: ASCIIMath expression
    /// - Parameter type: The mode in which the parser should be executed. Can be 2 options: math (for standard math expression) and tables (for excel like expression)
    /// - Parameter tablesContext: If the type is set to tables, then a Tables object is required to interact with the different cells
    public init(_ str: String, type: ParseContext = .math, tablesContext: Tables? = nil) {
        self.context = type
        let lexer = Lexer(input: str)
        let tokenized = lexer.tokenize()
        if type == .tables && str.first == "=" {
            self.tokens = Array(tokenized.dropFirst())
        } else {
            self.tokens = tokenized
        }
        
        self.tablesContext = tablesContext
        
        self.grouper = Grouper(tokens: tokens, context: type, tablesContext: tablesContext)
    }
    /// Initialize `Parser` with a list of tokens given by the `Lexer`
    /// - Parameter tokens: Array of `Token` given by the `Lexer`
    /// - Parameter type: The mode in which the parser should be executed. Can be 2 options: math (for standard math expression) and tables (for excel like expression)
    /// - Parameter tablesContext: If the type is set to tables, then a Tables object is required to interact with the different cells
    internal init(tokens: [Token], type: ParseContext = .math, tablesContext: Tables? = nil) {
        self.context = type
        self.tokens = tokens
        self.tablesContext = tablesContext
        self.grouper = Grouper(tokens: self.tokens, context: type, tablesContext: tablesContext)
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
        let groups = try grouper.group()
        self.groups = self.cleaning(groups)
        // Creates an array of Node. If it's an operator or something else, it will give a `nil`
        let chain = try chainMaker()
        let link = try linker(chain: chain)
        
        self.index = 0 // Resets index
        
        return link
    }
    
    /// Links the nodes to create a tree
    /// - Parameter chain: The chain given by `chainMaker`
    internal func linker(chain: [Node]) throws -> ExpressionNode {
        // Less priority means higher position in tree
        let priorities = [
            "+": 1,
            "-": 1,
            "*": 2,
            "/": 2,
            "^": 3,
            ",": 3, // Multiple arguments
            ":": 4, // For tables
            "=": 4
        ]
        guard chain.count >= 1 else { throw ParseError.FailedToParse }
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
                    
                    let op1 = OperatorNode(next.content, children: [mhs, rhs])
                    let op2 = OperatorNode(choosedSign, children: [lhs, op1])
                    
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
            guard !qp.contains(where: {$0 == nil}) else { throw ParseError.FailedToParse }
            return qp.map{ $0! }
        }
        
        var nodes = [Node]()
        
        while index < qp.count {
            let current = qp[index]
            if current == nil {
                guard index > 0 else { throw ParseError.FailedToParse }
                guard index + 1 <= qp.count - 1 else { throw ParseError.FailedToParse }
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
    
    /// `Parser` index
    private var index = 0
    
    /// Transform Groups to Node
    /// - Parameter gs: Array of `Group` given by the `Grouper`
    private func quickParsing(_ gs: [Group]) -> [Node?] {
        return gs.map { try? $0.toNode(lhs: nil, rhs: nil) }
    }
    
    private func cleaning(_ gs: [Group]) -> [Group] {
        var out = [Group]()
        for i in 0..<gs.count {
            let c = gs[i]
            out.append(c) // Adding last element to out
            
            if i == gs.count - 1 {
                return out
            }
            let n = gs[i + 1]
            let bad_types: [Group.GType] = [.Address, .Equal, .Operator, .Str, .UnParsed]
            if !bad_types.contains(c.type) && !bad_types.contains(n.type) {
                if !(c.type == .Symbol && n.type == .Parenthesis) {
                    out.append(Group(tokens: [.Other("*")], type: .Operator, context: self.context))
                }
                
            }
        }
        return gs // Will actually never happen... just a compiler thing
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
                
                func flattenedArray(array: [Node]) -> [Node] {
                    var myArray = [Node]()
                    for element in array {
                        if element.content == "," {
                            let result = flattenedArray(array: element.children)
                            for i in result {
                                myArray.append(i)
                            }
                        } else {
                            myArray.append(element)
                        }
                    }
                    return myArray
                }
                
                nodes[index] = FunctionNode(name, args: flattenedArray(array: children))
            }
            index += 1
        }
        // Resetting the index
        index = 0
        return nodes
    }
}
