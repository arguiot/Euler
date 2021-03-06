//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2019-12-16.
//

import Foundation
/// An entity that helps build a tree when parsing math expressions
public protocol Node: NSObject {
    /// This will be the string representation of the Node, it may change depending on the type of the Node
    var content: String { get set }
    /// The name in camelCase of the Node.
    /// > Ex: `"ExpressionNode"` or `"OperatorNode"`
    var type: String { get }
    /// The Node's children in the expression tree
    var children: [Node] { get set }
    
    /// Evaluate the mathematical expression behind each nodes
    /// - Parameter params: The object that contains all the variable
    func evaluate(_ params: [String: BigNumber], _ fList: [String:(([CellValue]) throws -> CellValue)]) throws -> CellValue
    /// Compiles the Node and each of its children for easier parsing / evaluation
    func compile() -> Node
    /// Gives String representation of the node
    func toString() -> String
    /// Gives Tex (String) representation of the node
    func toTex() -> String
    
    /// The depth of the `Node` in a `Tree`
    var depth: Int? { get set }
    /// The depth of the deepest children of the `Node` in a `Tree`
    var maxDepth: Int? { get set }
}
/// A type of error thrown when evaluation fails
public enum EvaluationError: LocalizedError {
    /// Parameter isn't found or somehting went wrong with them
    case parameters(String)
    /// The function provided is missing
    case functionError
    /// Children are missing
    case missingChildren
    /// The operation you're trying to do is impossible
    case ImpossibleOperation
    
    /// The error description
    ///
    /// Required to conform to `LocalizedError`
    ///
    public var errorDescription: String? {
        switch self {
        case .parameters(let parameter):
            return "Couldn't find the parameter named: \(parameter)"
        case .functionError:
            return "The function returned an error"
        case .missingChildren:
            return "Couldn't find the children (inside the expression tree)"
        case .ImpossibleOperation:
            return "Impossible Operation"
        }
    }
}
