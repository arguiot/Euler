//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-03-03.
//

import Foundation

internal extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

public extension Tables {
    
    /// Interprets the given command
    /// - Parameter command: The command you want to execute. Example: `=SUM(1, 2, 3, 4)`
    func interpret(command: String) throws -> CellValue {
        let p = Parser(command, type: .tables) // new parser for Tables
        
        p.tablesContext = self
        
        let expression = try p.parse() // Trying to parse the expression
        
        return try expression.evaluate([:], linker)
    }
    
    /// Huge list of all Tables functions.
    ///
    /// While this is public, it's not intended for use.
    ///
    static var functions: [String:(([CellValue]) throws -> CellValue)] {
        return Tables().linker
    }
    /// Links internal functions to parser by exposing them
    internal var linker: [String:(([CellValue]) throws -> CellValue)] {
        var out = [String:(([CellValue]) throws -> CellValue)]()
        out.merge(dict: self.commonFormulas)
        out.merge(dict: self.logicalFormulas)
        out.merge(dict: self.engineeringFormulas)
        out.merge(dict: self.dateFormulas)
        out.merge(dict: self.financialFormulas)
        out.merge(dict: self.statsFormulas)
        return out
    }
}
