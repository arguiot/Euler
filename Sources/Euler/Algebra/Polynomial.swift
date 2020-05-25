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
    /// Substract polynomials to each other non-destructively.
    /// - Parameters:
    ///   - lhs: Left hand side
    ///   - rhs: Right hand side
    public static func -(lhs: Polynomial, rhs: Polynomial) -> Polynomial {
        let neg_poly = rhs.negated
        return lhs + neg_poly
    }
    /// Negates this polynomial.
    ///
    /// Does so non-destructively
    public var negated: Polynomial {
        let coefs = self.coefs.map { $0 * BigDouble(-1) }
        return try! Polynomial(coefs)
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
        let first_idx = 0
        let last_idx = self.size - 1
        let size = self.size
        var result = [BigDouble]()

        var do_normalize = false
        var norm_const = BigDouble.zero
        
        for i in 0..<size {
            if i == first_idx {
                let val = self.coefs[i]
                if val != 1 {
                    do_normalize = true
                    norm_const = val
                }
                result.append(1)
            } else if i == last_idx {
                var val = self.coefs[i]
                if do_normalize {
                    val = val / norm_const
                }
                val = -abs(val)
                result.append(val)
            } else {
                var val = self.coefs[i]
                if do_normalize {
                    val = val / norm_const
                }
                val = abs(val)
                result.append(val)
            }
        }
        return try! Polynomial(result)
    }
    
    /// Divides this polynomial by given linear (1 degree) polynomial (Non destructive)
    /// - Parameters:
    ///   - x_coefs: coefficient of the (x-)term
    ///   - x_const: constant term
    public func linearDivision(x_coef: BigDouble, x_const: BigDouble) -> Polynomial {
        var remainder = try! Polynomial(self.coefs) // Copy polynomial
        
        let num_iterations = remainder.highestDegree
        var dividend_idx = 0
        var curr_deg = remainder.highestDegree
        var result = [BigDouble]()
        
        for _ in 0..<num_iterations {
            let quotient_coef = remainder.coefs[dividend_idx] / x_coef
            result.append(quotient_coef)
            
            let term = Term(deg: curr_deg - 1, coef:  quotient_coef)
            let poly_term = term.multiplyLinearPoly(x_coef, x_const)
            
            remainder = remainder - poly_term
            
            // zero out the highest term just in case we still have residuals
            remainder.setCoef(at: curr_deg, value: 0)
            
            dividend_idx += 1
            curr_deg -= 1
        }
        
        return try! Polynomial(result)
    }
    
    internal func setCoef(at pow: Int, value: BigDouble) {
        let max_pow = self.highestDegree
        guard pow <= max_pow && pow > 0 else { fatalError("Index out Range") }
        let last_idx = self.size - 1
        let pos = last_idx - pow
        self.coefs[pos] = value
    }
    
    /// Multiplies through this polynomial by the given constant
    /// - Parameters:
    ///   - lhs: Left hand side
    ///   - rhs: Right hand side
    public static func *(lhs: Polynomial, rhs: BigDouble) -> Polynomial {
        let coefs = lhs.coefs.map { $0 * rhs }
        return try! Polynomial(coefs)
    }
    
    /// Find root of given polynomial by apply newton iteration
    /// - Parameter err: it is the maximum error permitted in answer
    func solveNewton(err: BigDouble = 10e-4) -> BigDouble {
        var x = BigDouble(Double.random(in: 0...1))
        let diff_poly = self.derivative
        while abs(self.evaluate(at: x)) > abs(err) {
            x = x - self.evaluate(at: x) / diff_poly.evaluate(at: x)
        }
        return x
    }
    
    /// Finds all roots of the polynomial
    var roots: [BigDouble] {
        switch self.highestDegree {
        case 0:
//            fatalError("Doesn't make sense to find the root of this Polynomial")
            return []
        case 1:
            let a = coefs[0]
            let b = coefs[1]
            return [(-b) / a]
        case 2:
            let a = coefs[0]
            let b = coefs[1]
            let c = coefs[2]
            
            let delta = b * b - 4 * a * c
            guard delta >= 0 else { return [] }
            if delta == 0 {
                return [(-b) / (2*a)]
            }
            guard let sqrt = delta.squareRoot() else { return [(-b) / (2*a)] }
            let x1 = (-b + sqrt) / (2 * a)
            let x2 = (-b - sqrt) / (2 * a)
            return [x1, x2]
        default:
            let studied_poly = self
            let derivative = studied_poly.derivative
            
            let maxs = derivative.roots
            if maxs.isEmpty {
                return []
            }
            var intervals = [(BN, BN)]()
            for i in 0..<maxs.count {
                var lower = BN.zero
                if i == 0 {
                    if maxs.count == 1 {
                        lower = maxs[i] - BN(100) // 100 should be more than enough for a lot of polynomials
                    } else {
                        lower = maxs[i] - (maxs[i + 1] - maxs[i]) * 2 // Doubling spacing between 2 roots
                    }
                } else {
                    lower = maxs[i - 1]
                }
                let upper = maxs[i]
                
                let interval = (lower, upper)
                intervals.append(interval)
            }
            let (_, max) = intervals.last!
            intervals.append((max, max + BN(100)))
            
            var zeros = [BN]()
            for i in intervals {
                if let root = try? studied_poly.solve(for: "x", in: i, with: 10e-4) {
                    zeros.append(root)
                }
            }
            
            return Array(Set(zeros)) // removing duplicates
        }
    }
}

/// Creates a new term
internal struct Term {
    /// degree of the term
    var deg: Int = 0
    /// coefficient of the term
    var coef: BigDouble = .zero
    
    /// Multiplies this term with the provided linear (1-degree) polynomial
    /// - Parameters:
    ///   - x_coef: coefficient of the x^1 term
    ///   - x_const: coefficient of the x^0 term
    func multiplyLinearPoly(_ x_coef: BigDouble, _ x_const: BigDouble) -> Polynomial {
        let new_poly_deg = self.deg + 1
        let array = Array<BigDouble>(repeating: .zero, count: new_poly_deg)
        let poly = try! Polynomial(array)
        
        let highest_term_coef = x_coef * self.coef
        let second_highest_term_coef = x_const * self.coef
        
        poly.setCoef(at: new_poly_deg, value: highest_term_coef)
        poly.setCoef(at: new_poly_deg - 1, value: second_highest_term_coef)
        
        return poly
    }
}
