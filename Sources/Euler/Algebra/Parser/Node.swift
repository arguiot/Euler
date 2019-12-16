//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2019-12-16.
//

import Foundation
public protocol Node {
    internal var content: String { get }
    public var type: String { get }
    public var children: [Node] { get }
    
    public func toString() -> String
    public func toTex() -> String
}
