//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-02-07.
//

import Foundation

/// Special type of `Expression` to represent polynomials
public class Polynomial: Expression {
    /// List of coefficients
    public var coefs: [BigDouble] {
        didSet { // Won't be called inside `init`
            var expr = ""
            for (i, c) in coefs.enumerated() {
                if i < coefs.count - 1 {
                    let counted = coefs.count - 1
                    let nextSign = self.coefs[i + 1].sign
                    let sign = nextSign == false ? "+ " : "- "
                    expr += "\(abs(c)) * x^\(counted - i) \(sign)"
                } else {
                    expr += "\(abs(c))"
                }
            }
            
            let p = Parser(expr)
            guard let expression = try? p.parse() else { return }
            let comp = expression.compile()
            
            self.node = ExpressionNode(comp)
        }
    }
    /// Creates a polynomial based on the coefficiens
    public convenience init(_ coefficients: BigDouble...) throws {
        try self.init(coefficients)
    }
    /// Creates a polynomial based on the coefficiens
    public init(_ coefficients: [BigDouble]) throws {
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
    
    /// Evaluates the current polynomial at the given point
    ///
    /// Let `f` be a polynomial function. Evaluate returns the number given by `f(x)`
    /// - Parameter x: The input value for the polynomial function
    public func evaluate(at x: BigNumber) -> BigNumber {
        var result: BigNumber = 0
        var curr_pow = self.highestDegree
        for c in self.coefs {
            result += c * pow(x, curr_pow)
            curr_pow -= 1
        }
        return result
    }
    
    /// Returns the value of the degree of the term with the highest power in the polynomial
    var highestDegree: Int {
        self.size - 1
    }
    /// Returns the total number of terms in the polynomial (including the constant and zero-coefficient terms)
    var size: Int {
        self.coefs.count
    }
    
    /// Equal operator
    ///
    /// Returns true only if all the coefficient exactly match.
    /// - Parameters:
    ///   - lhs: Left hand side
    ///   - rhs: Right hand side
    public static func ==(lhs: Polynomial, rhs: Polynomial) -> Bool {
        guard lhs.size == rhs.size else { return false }
        guard lhs.coefs == rhs.coefs else { return false }
        return true
    }
    
    /// Produces a string represenation of the polynomial
    public override var description: String {
        return "Polynomial [ \(self.node.toString()) ]"
    }
    
    /// Add polynomials to each other non-destructively.
    /// - Parameters:
    ///   - lhs: Left hand side
    ///   - rhs: Right hand side
    public static func +(lhs: Polynomial, rhs: Polynomial) -> Polynomial {
        guard let new = try? Polynomial(lhs.coefs) else { return lhs }
        if lhs.size < rhs.size {
            let diff = rhs.size - lhs.size
            let array = Array<BigDouble>(repeating: 0, count: diff)
            new.coefs.insert(contentsOf: array, at: 0)
        }
        let reversed_coefs = Array(rhs.coefs.reversed())
        let maxIndex = new.highestDegree
        for i in 0..<reversed_coefs.count {
            new.coefs[maxIndex - i] += reversed_coefs[i]
        }
        return new
    }
}
