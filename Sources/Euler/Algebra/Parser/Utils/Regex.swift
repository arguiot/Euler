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
            guard let e = try? NSRegularExpression(pattern: "^\(regex)", options: []) else { return nil }
            expression = e
            expressions[regex] = expression
        }
        
        let range = expression.rangeOfFirstMatch(in: self, options: [], range: NSMakeRange(0, self.utf16.count))
        if range.location != NSNotFound {
            return (self as NSString).substring(with: range)
        }
        return nil
    }
    
    func matches(regex: String) -> [(Int, Int)] {
        let expression: NSRegularExpression
        if let exists = expressions[regex] {
            expression = exists
        } else {
            guard let e = try? NSRegularExpression(pattern: "\(regex)", options: []) else { return [] }
            expression = e
            expressions[regex] = expression
        }
        let m = expression.matches(in: self, options: [], range: NSMakeRange(0, self.utf16.count))
        let ranges = m.map { $0.range }
        return ranges.map { ($0.lowerBound, $0.upperBound) }
    }
}
internal func multiline(x: String...) -> String {
    return x.joined(separator: "\n")
}
