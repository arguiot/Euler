//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-04-02.
//

import Foundation

/// A `Node` for cell adress such as `A2` or `$HH$26`
public class CellAddressNode: NSObject, Node {
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
    
    /// The `print()` description
    override public var description: String {
        return "\(self.type)[ \(self.toString()) ]"
    }
    /// The cell reference (ex: `A2` or `$HH$26`)
    public var content: String
    
    /// The name of the node
    public var type: String = "CellAddressNode"
    
    /// Useless here, but it's to conform to the Node protocol
    public var children = [Node]()
    
    /// Create a CellAddressNode
    /// - Parameter name: Cell reference (ex: `A2`)
    public init(_ name: String, _ ctx: Tables) {
        self.content = name
        self.tablesContext = ctx
    }
    
    /// Compiles CellAddressNode to simpler node (useless here, but required by protocol)
    public func compile() -> Node {
        return self
    }
    
    internal var tablesContext: Tables
    
    
    internal func lettersToInt(_ letters: String) -> Int? {
        let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ").map { String($0) }
        let lArray = Array(letters).map { String($0) }
        var n = 0
        let p = 0
        for l in lArray.reversed() {
            guard let fIndex = alphabet.firstIndex(of: l) else { return nil }
            n += fIndex * Int(pow(Double(alphabet.count), Double(p)))
        }
        return n
    }
    
    /// Converts CellAddressNode to CellValue by getting the original value from the `TablesDataSource`
    public func evaluate(_ params: [String: BigNumber], _ fList: [String:(([CellValue]) throws -> CellValue)]) throws -> CellValue {
        guard let dataSource = tablesContext.dataSource else { throw EvaluationError.functionError }
        guard let letters = "[A-Z]+".match(regex: self.content) else { throw EvaluationError.ImpossibleOperation }
        guard let x = self.lettersToInt(letters) else { throw EvaluationError.ImpossibleOperation }
        guard let int = "[0-9]+".match(regex: self.content) else { throw EvaluationError.ImpossibleOperation }
        guard let y = Int(int) else { throw EvaluationError.ImpossibleOperation }
        
        return dataSource.valueOfCell(x: x, y: y)
    }
    
    /// Make sure that two `CellAddressNode` are equals (used in pattern matching)
    ///
    /// If you want to search for patterns, build a sample tree with a `SymbolNode` with `"Any"` as `content`
    /// - Parameters:
    ///   - lhs: Any `CellAddressNode`
    ///   - rhs: Any `CellAddressNode`
    static func ==(lhs: CellAddressNode, rhs: CellAddressNode) -> Bool {
        guard lhs.content == rhs.content || lhs.content == "Any" || rhs.content == "Any" else { return false }
        guard lhs.children.count == rhs.children.count else { return false }
        for i in 0..<lhs.children.count {
            guard lhs.children[i] == rhs.children[i] else { return false }
        }
        return true
    }
}
