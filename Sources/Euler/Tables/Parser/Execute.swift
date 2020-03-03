//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-03-03.
//

import Foundation

public extension Tables {
    
    func execute() throws -> BigDouble {
        guard self.expression != nil else { throw TablesError.NULL }
        let p = Parser(self.expression!, type: .tables) // new parser for Tables
        let expression = try p.parse() // Trying to parse the expression
        
        return try expression.evaluate([:])
    }
}
