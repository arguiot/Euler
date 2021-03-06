//
//  ExpressionSolver.swift
//  Euler
//
//  Created by Arthur Guiot on 2020-08-16.
//

import Foundation

public extension Expression {
    fileprivate enum SolveError: Error {
        case moreThan2SubExpressions
        case evalError
        case noSolutions
    }
    
    /// Solve equation using Brent's method
    ///
    /// In numerical analysis, Brent's method is a root-finding algorithm combining the bisection method, the secant method and inverse quadratic interpolation. It has the reliability of bisection but it can be as quick as some of the less-reliable methods. The algorithm tries to use the potentially fast-converging secant method or inverse quadratic interpolation if possible, but it falls back to the more robust bisection method if necessary.
    /// - Parameters:
    ///   - variable: For which variable we're solving the equation. Example: `"x"`
    ///   - interval: In which interval the solution is predicted to be. Example: `(-1, 1)`
    ///   - precision: At which precision you want the solution. Example: `10e-3`
    func singleSolve(for variable: String, in interval: (BigNumber, BigNumber), with precision: BigNumber = 10e-3) throws -> BigNumber {
        let precision = precision / 10 // To ensure decimal precision
        
        var simplify = Simplify(self.node)
        let simplified = simplify.simple()
        guard simplified.children.count <= 2 else { throw SolveError.moreThan2SubExpressions }
        
        var single = simplified
        
        if single.children.count == 2 {
            let expr = ExpressionNode(OperatorNode("-", children: [
                single.children[0],
                single.children[1]
            ]))
            simplify = Simplify(expr)
            single = simplify.simple()
        }
        
        func f(_ x: BigNumber) throws -> BigNumber {
            if let s = self as? Polynomial {
                return s.evaluate(at: x)
            }
            let value = try single.evaluate([variable : x]).number
            
            guard let y = value else { throw SolveError.evalError }
            return y
        }
        
        var (a, b) = interval
        
        var fa = try f(a)
        var fb = try f(b)
        
        guard fa * fb < BigDouble.zero else {
            throw SolveError.noSolutions
        }
        if abs(fa) < abs(fb) {
            (a, b) = (b, a) // Switch values
        }
        
        var c = a
        var fc = try f(c)
        var mflag = true
        var d = BigDouble.zero
        
        func isBetween(x: BigDouble, _ a: BigDouble, _ b: BigDouble) -> Bool {
            guard x >= a else { return false }
            guard x <= b else { return false }
            return true
        }
        
        while fb != 0 && abs(b - a) > precision {
            var s = BigDouble.zero
            if fa != fc && fb != fc {
                let p1 = (a * fb * fc) / ((fa - fb) * (fa - fc))
                let p2 = (b * fa * fc) / ((fb - fa) * (fb - fc))
                let p3 = (c * fa * fb) / ((fc - fa) * (fc - fb))
                s = p1 + p2 + p3
            } else {
                s = b - (fb * (b - a)) / (fb - fa)
            }
            
            if (isBetween(x: s, (3*a + b) / 4, b) ||
                (mflag == true && abs(s - b) >= abs(b - c)  / BigDouble(2)) ||
                (mflag == false && abs(s - b) >= abs(c - d) / BigDouble(2))) {
                s = (a + b) / BigDouble(2)
                
                mflag = true
            } else {
                mflag = false
            }
            
            let fs = try f(s)
            d = c
            c = b
            // Recompute
            fa = try f(a)
            fb = try f(b)
            fc = try f(c)
            
            if fa * fs < BigDouble.zero {
                b = s
            } else {
                a = s
            }
            
            if abs(fa) < abs(fb) {
                (a, b) = (b, a) // Switch values
            }
        }
        
        return b
    }
    /// Solve equation using Brent's method
    ///
    /// It will go through the interval using `precision` and will estimate possible zeros location. Then will use Brent's algorithm to find thoses solutions.
    ///
    /// In numerical analysis, Brent's method is a root-finding algorithm combining the bisection method, the secant method and inverse quadratic interpolation. It has the reliability of bisection but it can be as quick as some of the less-reliable methods. The algorithm tries to use the potentially fast-converging secant method or inverse quadratic interpolation if possible, but it falls back to the more robust bisection method if necessary.
    /// - Parameters:
    ///   - variable: For which variable we're solving the equation. Example: `"x"`
    ///   - interval: In which interval the solution is predicted to be. Example: `(-1, 1)`
    ///   - precision: At which precision you want the solution. Example: `10e-4`
    func solve(for variable: String, in interval: (BigNumber, BigNumber), at rate: BigNumber = 10e-1, with precision: BigNumber = 10e-3) throws -> [BigNumber] {
        var simplify = Simplify(self.node)
        let simplified = simplify.simple()
        guard simplified.children.count <= 2 else { throw SolveError.moreThan2SubExpressions }
        
        var single = simplified
        
        if single.children.count == 2 {
            let expr = ExpressionNode(OperatorNode("-", children: [
                single.children[0],
                single.children[1]
            ]))
            simplify = Simplify(expr)
            single = simplify.simple()
        }
        
        func f(_ x: BigNumber) throws -> BigNumber {
            if let s = self as? Polynomial {
                return s.evaluate(at: x)
            }
            let value = try single.evaluate([variable : x]).number
            
            guard let y = value else { throw SolveError.evalError }
            return y
        }
        
        let (a, b) = interval
        
        var intervals = [(BigDouble, BigDouble)]()
        var beginning = a
        guard var pastImage = try? f(a) else { throw SolveError.evalError }
        var x = a
//        for x in stride(from: a, to: b, by: precision) {: Far too slow...
        while x <= b {
            guard let i = try? f(x) else { continue }
            if i.sign != pastImage.sign {
                intervals.append((beginning, x))
                beginning = x
            }
            pastImage = i
            
            x += rate
        }
        let results = try intervals.map { try self.singleSolve(for: variable, in: $0, with: precision) }
        return results
    }
}
