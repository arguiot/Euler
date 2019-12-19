//
//  Regex.swift
//  
//
//  Created by Arthur Guiot on 2019-12-18.
//

import Foundation

var expressions = [String: NSRegularExpression]()
internal extension String {
    func match(regex: String) -> String? {
        let expression: NSRegularExpression
        if let exists = expressions[regex] {
            expression = exists
        } else {
            expression = try! NSRegularExpression(pattern: "^\(regex)", options: [])
            expressions[regex] = expression
        }
        
        let range = expression.rangeOfFirstMatch(in: self, options: [], range: NSMakeRange(0, self.utf16.count))
        if range.location != NSNotFound {
            return (self as NSString).substring(with: range)
        }
        return nil
    }
}
internal func multiline(x: String...) -> String {
    return x.joined(separator: "\n")
}
