//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-03-10.
//

import Foundation
/// A type that helps you communicate and interact with `Tables`
public protocol TablesDataSource {
    /// Get the value of a cell at a specific address
    /// - Parameters:
    ///   - x: The x coordinate of the cell. For example, when the parser sees `B4`, it will call this function with `x = 1` as `B` is the second letter in the alphabet and we start from 0
    ///   - y: The x coordinate of the cell. For example, when the parser sees `B4`, it will call this function with `y = 3` as  we start from 0.
    func valueOfCell(x: Int, y: Int) -> CellValue
    
    /// Updates the value of the cell at a specific address
    /// - Parameters:
    ///   - content: The content of the updated cell.
    ///   - x: The x coordinate of the cell. For example, when we want to update `B4`, it will call this function with `x = 1` as `B` is the second letter in the alphabet and we start from 0
    ///   - y: The x coordinate of the cell. For example, when we want to update `B4`, it will call this function with `y = 3` as  we start from 0.
    func updateCell(content: CellValue, x: Int, y: Int)
    
    /// Interprets the given command
    /// - Parameter command: The command you want to execute. Example: `=SUM(1, 2, 3, 4)`
    func interpret(command: String) -> CellValue
}
