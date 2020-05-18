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
        out = out.replace(regex: "\\div", with: "/") // Division
        out = out.replace(regex: "\\cdot", with: "*") // Multiplication
        out = out.replace(regex: "\\times", with: "/") // Same
        // Functions
        out = out.replace(regex: "\\|.*\\|", with: "ABS($1)")
        out = out.replacingOccurrences(of: "\\", with: "")
        out = out.replacingOccurrences(of: "\\left", with: "")
        out = out.replacingOccurrences(of: "\\right", with: "")
        out = out.replacingOccurrences(of: "{", with: "(")
        out = out.replacingOccurrences(of: "}", with: ")")
        out = out.replacingOccurrences(of: "ar", with: "a")
        return out
    }
    
    private static func fractions(latex: String) -> String {
        var out = latex
        while out.contains("\\frac") {
            out = out.replace(regex: "\\\\frac\\s*\\{((?!\\\\frac\\{).*?)\\}\\{((?!\\\\frac\\{).*?)\\}", with: "($1) / ($2)")
        }
        return out
    }
}