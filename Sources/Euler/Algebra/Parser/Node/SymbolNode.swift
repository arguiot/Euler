//
//  SymbolNode.swift
//  
//
//  Created by Arthur Guiot on 2019-12-16.
//

import Foundation

public class SymbolNode: NSObject, Node {
    /// Gives String representation of the node
    public func toString() -> String {
        return self.content
    }
    /// Gives Tex (String) representation of the node
    public func toTex() -> String {
        return self.content
    }
    
    /// The `print()` description
    override public var description: String {
        return "\(self.type)[ \(self.toString()) ]"
    }
    /// The name of the Symbol (ex: `x` or `y`)
    public var content: String
    
    /// The name of the node
    public var type: String = "SymbolNode"
    
    /// Useless here, but it's to conform to the Node protocol
    public var children = [Node]()
    
    /// Create a SymbolNode
    /// - Parameter double: Floating point number
    public init(_ variable: String) {
        self.content = variable
    }
    
    /// Compiles SymbolNode to simpler node (useless here, but required by protocol)
    public func compile() -> Node {
        return self
    }
    /// Converts SymboleNode to BigNumber by replacing unknown value by their parameters. If it fails, it will return 0.
    public func evaluate(_ params: [String: BigNumber]) -> BigNumber {
        guard let n = params[self.content] else { return .zero }
        return n
    }
}