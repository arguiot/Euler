//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-05-18.
//

import Foundation

public extension Parser {
    /// Initialize Parser with LaTeX
    convenience init(latex: String) {
        let math = Parser.LaTeX2Math(latex: latex)
        self.init("=\(math)", type: .tables, tablesContext: Tables())
    }
    
    private static func LaTeX2Math(latex: String) -> String {
        var out = fractions(latex: latex)
        out = quickReplace(latex: out)
        return out
    }
    
    private static func quickReplace(latex: String) -> String {
        var out = latex
        out = out.replacingOccurrences(of: "\\div", with: "/") // Division
        out = out.replacingOccurrences(of: "\\cdot", with: "*") // Multiplication
        out = out.replacingOccurrences(of: "\\times", with: "*") // Same
        // Functions
        out = out.replace(regex: "\\|.*\\|", with: "ABS($1)")
        out = out.replacingOccurrences(of: "\\left", with: "")
        out = out.replacingOccurrences(of: "\\right", with: "")
        out = out.replacingOccurrences(of: "{", with: "(")
        out = out.replacingOccurrences(of: "}", with: ")")
        out = out.replacingOccurrences(of: "ar", with: "a")
        out = out.replacingOccurrences(of: "\\", with: "")
        return out
    }
    
    private static func fractions(latex: String) -> String {
        var out = latex
        var old = ""
        while out.contains("\\frac") && old != out { // So we don't have an infinite loop...
            old = out
            
            guard let range = out.range(of: "\\frac") else { return latex }
            let start = range.lowerBound.encodedOffset
            let end = range.upperBound.encodedOffset
            
            // Finding Group1
            var open = 1
            var index = end + 1 // skipping `{`
            
            while open > 0 {
                if out[index] == "{" {
                    open += 1
                } else if out[index] == "}" {
                    open -= 1
                }
                index += 1
            }
            let g1start = out.index(out.startIndex, offsetBy: end + 1)
            let g1end = out.index(out.startIndex, offsetBy: index - 1)
            let group1 = out[g1start..<g1end]
            // Finding Group2
            open = 1
            index += 1 // skipping `{`
            let endg1 = index
            while open > 0 {
                if out[index] == "{" {
                    open += 1
                } else if out[index] == "}" {
                    open -= 1
                }
                index += 1
            }
            let g2start = out.index(out.startIndex, offsetBy: endg1)
            let g2end = out.index(out.startIndex, offsetBy: index - 1)
            let group2 = out[g2start..<g2end]
            
            
            let content = "((\(group1)) / (\(group2)))"
            
            let lower = out.index(out.startIndex, offsetBy: start)
            let upper = out.index(out.startIndex, offsetBy: index)
            out.replaceSubrange(lower..<upper, with: content)
        }
        
        return out
    }
}
