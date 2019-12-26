//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2019-12-19.
//

import Foundation

public class FunctionNode: NSObject, Node {
    /// Gives String representation of the node
    public func toString() -> String {
        return self.content
    }
    /// Gives Tex (String) representation of the node
    public func toTex() -> String {
        return self.content
    }
    
    public var content: String
    
    public var type: String = "FunctionNode"
    
    public var children = [Node]()
    
    /// Create a SymbolNode
    /// - Parameter double: Floating point number
    public init(_ name: String, args: [Node]) {
        self.content = name
        self.children = args
    }
    
    /// Compiles SymbolNode to simpler node (useless here, but required by protocol)
    public func compile() -> Node {
        return self
    }
    /// Converts SymbolNode to BigNumber by replacing unknown value by their parameters. If it fails, it will return 0.
    public func evaluate(_ params: [String: BigNumber]) -> BigNumber {
        guard let n = params[self.content] else { return .zero }
        return n
    }
}
