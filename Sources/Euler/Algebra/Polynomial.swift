//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-02-07.
//

import Foundation

public class Polynomial: Expression {
    var coefs: [BigDouble]
    
    convenience init(_ coefficients: BigDouble...) throws {
        try self.init(coefficients)
    }
    init(_ coefficients: [BigDouble]) throws {
        self.coefs = coefficients
        
        var expr = ""
        for (i, c) in self.coefs.enumerated() {
            if i < coefficients.count - 1 {
                let counted = coefficients.count - 1
                let nextSign = self.coefs[i + 1].sign
                let sign = nextSign == false ? "+ " : "- "
                expr += "\(abs(c)) * x^\(counted - i) \(sign)"
            } else {
                expr += "\(abs(c))"
            }
        }
        try super.init(expr)
    }
}
