//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2019-12-16.
//

import Foundation
/// An entity that helps build a tree when parsing math expressions
public protocol Node {
    var content: String { get }
    var type: String { get }
    var children: [Node] { get }
    
    func evaluate(_ params: [String: BigNumber]) -> BigNumber
    func compile() -> Node
    func toString() -> String
    func toTex() -> String
}
