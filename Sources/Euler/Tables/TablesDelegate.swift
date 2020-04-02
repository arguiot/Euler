//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-04-02.
//

import Foundation
/// A protocol that helps you communicate and interact with user input in `Tables`
public protocol TablesDelegate {
    /// Updates the code of the cell at a specific address
    /// - Parameters:
    ///   - code: The content of the updated cell.
    ///   - x: The x coordinate of the cell. For example, when we want to update `B4`, it will call this function with `x = 1` as `B` is the second letter in the alphabet and we start from 0
    ///   - y: The x coordinate of the cell. For example, when we want to update `B4`, it will call this function with `y = 3` as  we start from 0.
    func updateCellCode(code: String, x: Int, y: Int)
    
    
    /// Get the code of a cell at a specific address
    /// - Parameters:
    ///   - x: The x coordinate of the cell. For example, when the parser sees `B4`, it will call this function with `x = 1` as `B` is the second letter in the alphabet and we start from 0
    ///   - y: The x coordinate of the cell. For example, when the parser sees `B4`, it will call this function with `y = 3` as  we start from 0.
    func codeOfCell(x: Int, y: Int) -> String
}
