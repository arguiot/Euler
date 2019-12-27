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
        let map = children.map { $0.toString() }
        return "\(self.content)(\(map.joined(separator: ", ")))"
    }
    /// Gives Tex (String) representation of the node
    public func toTex() -> String {
        let map = children.map { $0.toTex() }
        return "\(self.content)(\(map.joined(separator: ", ")))"
    }
    
    override public var description: String {
        return "\(self.type)[ \(self.toString()) ]"
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
