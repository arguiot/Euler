//
//  Regex.swift
//  
//
//  Created by Arthur Guiot on 2019-12-18.
//

import Foundation

var expressions = [String: NSRegularExpression]()
internal extension String {
    /// Returns the matched String
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
    
    /// Returns the range of the matched String
    func matchRange(regex: String) -> (Int, Int)? {
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
            return (range.lowerBound, range.upperBound)
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
    
    func replace(regex: String, with: String) -> String {
        let expression: NSRegularExpression
        if let exists = expressions[regex] {
            expression = exists
        } else {
            guard let e = try? NSRegularExpression(pattern: "\(regex)", options: [.useUnixLineSeparators, .caseInsensitive]) else { return self }
            expression = e
            expressions[regex] = expression
        }
        let out = expression.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.utf16.count), withTemplate: with)
        return out
    }
}
internal func multiline(x: String...) -> String {
    return x.joined(separator: "\n")
}

extension StringProtocol {
    subscript(_ offset: Int)                     -> Element     { self[index(startIndex, offsetBy: offset)] }
    subscript(_ range: Range<Int>)               -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: ClosedRange<Int>)         -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence { prefix(range.upperBound.advanced(by: 1)) }
    subscript(_ range: PartialRangeUpTo<Int>)    -> SubSequence { prefix(range.upperBound) }
    subscript(_ range: PartialRangeFrom<Int>)    -> SubSequence { suffix(Swift.max(0, count-range.lowerBound)) }
}
