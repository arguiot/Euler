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
    /// Creates a polynomial based on the coefficients
    public convenience init(_ coefficients: BigDouble...) throws {
        try self.init(coefficients)
    }
    /// Creates a polynomial based on the coefficients
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
    
    /// Get the degree of the highest term with a non-zero coefficient.
    /// If all coefficients are zero (polynomial is empty) - then `nil` is returned.
    var trueHighestDegree: Int? {
        var i = 0;
        for coef in self.coefs {
            if coef != 0 {
                return power(at: i)
            }
            i += 1
        }
        return nil
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
    
    /// Translate the index value to an x-power value
    /// (i.e. the value of term degree at given position)
    /// i - the index (0-based)
    /// - Parameter index: Index
    internal func power(at index: Int) -> Int {
        let max_index = size - 1
        guard index >= 0 && index <= max_index else { fatalError("Index out of range") }
        let max_degree = highestDegree
        return max_degree - index
        
    }
    
    ///  Returns the coefficeint of the given x-power
    /// - Parameter power: The exponent
    internal func powerCoef(at power: Int) -> BigDouble {
        let max_pow = self.highestDegree
        guard power <= max_pow && power >= 0 else { fatalError("Index out of range") }
        let last_idx = self.size - 1
        let pos = last_idx - power
        return self.coefs[pos]
    }
    
    /// Computes the derivative of this polynomial
    public var derivative: Polynomial {
        var result = [BigDouble]()
        let size = self.size
        
        for i in 0..<size - 1 { // skip constant
            let curr_deg = self.power(at: i)
            let curr_coef = powerCoef(at: curr_deg)
            let new_coef = BigDouble(curr_deg) * curr_coef
            result.append(new_coef)
        }
        
        return try! Polynomial(result)
    }
    /// Divides the polynomial by the leading coefficient so that we would have a monic polynomial
    public var normalized: Polynomial {
        var result = [BigDouble]()
        var norm_const: BigDouble?
        // Usually the first highest coefficient is good enough. But sometimes that
        // is zero. So we look through all coefficietns to find the first viable one.
        for coef in self.coefs where coef != 0 {
            norm_const = coef
            break
        }
        guard let norm = norm_const else { return self }
        for coef in self.coefs {
            let val = coef / norm
            result.append(val)
        }
        
        return try! Polynomial(result)
    }
    /// Returns the Cauchy Polynomial from this polynomial
    public var cauchyPoly: Polynomial {
        var first_idx = 0
        var last_idx = self.size - 1
        var size = self.size
        var result = [BigDouble]()

        var do_normalize = false
        var norm_const = 0
        
        for i in 0..<size {
            if i == first_idx {
                var val = self.coefs[i]
                if val != 1 {
                    do_normalize = true
                    norm_const = val
                }
                result.append(1)
            } else if i == last_idx {
                var val = self.coefs[i]
                if do_normalize {
                    val /= norm_const
                }
                val = -abs(val)
                result.append(val)
            } else {
                var val = self.coefs[i]
                if do_normalize {
                    val /= norm_const
                }
                val = abs(val)
                result.append(val)
            }
        }
        return try! Polynomial(result)
    }
}
