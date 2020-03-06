//
//  NullNode.swift
//  
//
//  Created by Arthur Guiot on 2020-01-03.
//

import Foundation

/// This is a Node object that represents an empty Node
public class NullNode: NSObject, Node {
    /// The depth of the deepest children of the `Node` in a `Tree`
    public var maxDepth: Int?
    
    /// The depth of the `Node` in a `Tree`
    public var depth: Int?
    
    /// Gives String representation of the node
    public func toString() -> String {
        return self.content
    }
    /// Gives Tex (String) representation of the node
    public func toTex() -> String {
        return self.content
    }
    
    override public var description: String {
        return "\(self.type)[ \(self.toString()) ]"
    }
    
    public var content: String
    
    public var type: String = "NullNode"
    
    public var children = [Node]()
    
    /// Create a NullNode
    public override init() {
        self.content = ""
    }
    
    /// Compiles NullNode to simpler node (useless here, but required by protocol)
    public func compile() -> Node {
        return self
    }
    /// Converts NullNode to BigNumber
    public func evaluate(_ params: [String : BigNumber], _ fList: [String : (([Any]) throws -> BigDouble?)]) throws -> BigNumber {
        return .zero
    }
}
