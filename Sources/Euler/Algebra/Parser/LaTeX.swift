//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-05-18.
//

import Foundation

public extension Parser {
    /// Initialize Parser with `$\LaTeX$`
    convenience init(latex: String) {
        let math = Parser.LaTeX2Math(latex: latex)
        self.init("=\(math)", type: .tables, tablesContext: Tables())
    }
    
    private static func LaTeX2Math(latex: String) -> String {
        let sqrt = nthroot(latex: latex) // removes nth-root
        let lg = log(latex: sqrt)
        let absolute = abs(latex: lg)
        var out = fractions(latex: absolute)
        out = quickReplace(latex: out)
        return out
    }
    
    private static func quickReplace(latex: String) -> String {
        var out = latex
        out = out.replacingOccurrences(of: "\\div", with: "/") // Division
        out = out.replacingOccurrences(of: "\\cdot", with: "*") // Multiplication
        out = out.replacingOccurrences(of: "\\times", with: "*") // Same
        out = out.replace(regex: "\\\\operatorname\\{(\\w+)\\}", with: "$1")
        // Functions
//        out = out.replacingOccurrences(of: "\\pi", with: "pi()")
//        out = out.replace(regex: "\\|(.+)\\|", with: "ABS($1)")
        out = out.replacingOccurrences(of: "\\left", with: "")
        out = out.replacingOccurrences(of: "\\right", with: "")
        out = out.replacingOccurrences(of: "{", with: "(")
        out = out.replacingOccurrences(of: "}", with: ")")
//        out = out.replacingOccurrences(of: "ar", with: "a")
        out = out.replacingOccurrences(of: "\\", with: "")
        out = out.replace(regex: "\\^(\\d)", with: "^($1)")
        return out
    }
    
    private static func fractions(latex: String) -> String {
        var out = latex
        var old = ""
        while out.contains("\\frac") && old != out { // So we don't have an infinite loop...
            old = out
            
            guard let range = out.range(of: "\\frac") else { return latex }
            let start = range.lowerBound.utf16Offset(in: out)
            let end = range.upperBound.utf16Offset(in: out)
            
            // Finding Group1
            var open = 1
            var index = end + 1 // skipping `{`
            
            while open > 0 {
                guard index < out.count else { return latex }
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
                guard index < out.count else { return latex }
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
    
    private static func nthroot(latex: String) -> String {
        var out = latex
        var old = ""
        while out.contains("\\sqrt[") && old != out { // So we don't have an infinite loop...
            old = out
            
            guard let range = out.range(of: "\\sqrt[") else { return latex }
            let start = range.lowerBound.utf16Offset(in: out)
            let end = range.upperBound.utf16Offset(in: out)
            
            // Finding Group1
            var open = 1
            var index = end // Already skipping `[`
            
            while open > 0 {
                guard index < out.count else { return latex }
                if out[index] == "[" {
                    open += 1
                } else if out[index] == "]" {
                    open -= 1
                }
                index += 1
            }
            let g1start = out.index(out.startIndex, offsetBy: end)
            let g1end = out.index(out.startIndex, offsetBy: index - 1)
            let group1 = out[g1start..<g1end]
            // Finding Group2
            open = 1
            index += 1 // skipping `{`
            let endg1 = index
            while open > 0 {
                guard index < out.count else { return latex }
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
            
            
            let content = "root(\(group2), \(group1))"
            
            let lower = out.index(out.startIndex, offsetBy: start)
            let upper = out.index(out.startIndex, offsetBy: index)
            out.replaceSubrange(lower..<upper, with: content)
        }
        
        return out
    }
    
    private static func log(latex: String) -> String {
        var out = latex
        var old = ""
        while out.contains("\\log_") && old != out { // So we don't have an infinite loop...
            old = out
            
            guard let range = out.range(of: "\\log_") else { return latex }
            let start = range.lowerBound.utf16Offset(in: out)
            let end = range.upperBound.utf16Offset(in: out)
            
            var group1: String
            var open = 1
            var index = end + 1 // skipping `{`
            if out.contains("\\log_{") {
                // Finding Group1
                while open > 0 {
                    guard index < out.count else { return latex }
                    if out[index] == "{" {
                        open += 1
                    } else if out[index] == "}" {
                        open -= 1
                    }
                    index += 1
                }
                let g1start = out.index(out.startIndex, offsetBy: end + 1)
                let g1end = out.index(out.startIndex, offsetBy: index - 1)
                group1 = String(out[g1start..<g1end])
            } else {
                let g1start = out.index(out.startIndex, offsetBy: end)
                let g1end = out.index(out.startIndex, offsetBy: end + 1)
                group1 = String(out[g1start..<g1end])
            }
            // Finding Group2
            open = 1
            var simple = false
            if index < out.count && out[index] == "(" {
                simple = true
                index += 1 // skipping `(`
            } else {
                index += 6 // skipping `\\left(`
            }
            let endg1 = index
            while open > 0 {
                if simple {
                    guard index < out.count else { return latex }
                    if out[index] == "(" {
                        open += 1
                    } else if out[index] == ")" {
                        open -= 1
                    }
                } else {
                    guard index + 6 < out.count else { return latex }
                    if out[index..<index + 6] == "\\left(" {
                        open += 1
                        index += 5
                    } else if out[index...index + 6] == "\\right)" {
                        open -= 1
                        index += 6
                    }
                }
                
                index += 1
            }
            let g2start = out.index(out.startIndex, offsetBy: endg1)
            let g2end = out.index(out.startIndex, offsetBy: index - (simple ? 1 : 7))
            
            guard g2start < g2end else { return latex }
            
            let group2 = out[g2start..<g2end]
            
            
            let content = "log(\(group2), \(group1))"
            
            let lower = out.index(out.startIndex, offsetBy: start)
            let upper = out.index(out.startIndex, offsetBy: index)
            out.replaceSubrange(lower..<upper, with: content)
        }
        
        return out
    }
    
    private static func abs(latex: String) -> String {
        var out = latex
        var old = ""
        while out.contains("|") && old != out { // So we don't have an infinite loop...
            old = out
            
            guard let range = out.range(of: "|") else { return latex }
            let start = range.lowerBound.utf16Offset(in: out)
            let end = range.upperBound.utf16Offset(in: out)
            
            // Finding Group
            var open = 1
            var index = end
            
            while open > 0 {
                guard index < out.count else { return latex }
                if out[index] == "|" && out.substring(with: index - 5..<index) == "\\left" {
                    open += 1
                } else if out[index] == "|" && out.substring(with: index - 6..<index) == "\\right" {
                    open -= 1
                }
                index += 1
            }
            let gstart = out.index(out.startIndex, offsetBy: end)
            let gend = out.index(out.startIndex, offsetBy: index - 1)
            let group = out[gstart..<gend]
            
            
            let content = "abs(\(group))"
            
            let lower = out.index(out.startIndex, offsetBy: start)
            let upper = out.index(out.startIndex, offsetBy: index)
            out.replaceSubrange(lower..<upper, with: content)
        }
        
        return out
    }
}
