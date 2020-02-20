//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-02-07.
//

import Foundation
import Accelerate

public extension Statistics {
    static func linearRegression(points: [Point]) throws -> Polynomial {
        let n = BigDouble(points.count)
        var sum_x: BigDouble = .zero
        var sum_y: BigDouble = .zero
        var sum_xy: BigDouble = .zero
        var sum_xx: BigDouble = .zero
        var sum_yy: BigDouble = .zero
        for p in points {
            sum_x += p.x
            sum_y += p.y
            sum_xy += p.x * p.y
            sum_xx += p.x * p.x
            sum_yy += p.y * p.y
        }
        let upper = n * sum_xy - sum_x * sum_y
        let down = n * sum_xx - sum_x * sum_x
        let slope =  upper / down
        let intercept = (sum_y - slope * sum_x) / n
        return try Polynomial(slope, intercept)
    }
    
//    static func polynomialRegression(points: [Point], deg: Int = 2) throws -> Polynomial {
//        var lhs = [BigDouble]()
//        var rhs = [[BigDouble]]()
//        
//        var a: BigDouble = 0
//        var b: BigDouble = 0
//        let len = points.count
//        
//        let k = deg + 1
//        for i in 0..<k {
//            for l in 0..<len {
//                a += points[l].x ** i * points[l].y
//            }
//            lhs.append(a)
//            a = 0
//            
//            var c = [BigDouble]()
//            
//            for j in 0..<k {
//                for l in 0..<len {
//                    b += points[l].x ** (i + j)
//                }
//                c.append(b)
//                b = 0
//            }
//            rhs.append(c)
//        }
//        rhs.append(lhs)
//        
//        let matrix = Matrix(rhs)
//        
//        let eq = try matrix.gaussElimination(vector: [Double(k)])
//        let grid = eq.grid.map { BigDouble($0) }
//        return try Polynomial(grid)
//    }
}

class Regression {
    let degree: Int
    
    private (set) var betas: [Double] = []
    
    
    init(x: Matrix, y: Matrix, degree: Int) throws {
        self.degree = degree
        self.betas = try self.findBetas(x: x, y: y, degree: degree)
    }
    
    
    private func calculatePowersOfX(x: Matrix) -> Matrix {
        var newX = x
        
        if degree > 1 {
            for i in 2...degree {
                let degreeOfX = Matrix(rows: x.rows, columns: 1, grid: x.grid.map({ pow($0, Double(i)) }))
                
                newX = newX.appendHorizontal(m: degreeOfX)
            }
        }
        
        return newX
    }
    
    
    private func findBetas(x: Matrix, y: Matrix, degree: Int) throws -> [Double] {
        let newX = calculatePowersOfX(x: x)
        let ones = Matrix(rows: y.rows, columns: 1, repeatedValue: 1)
        let onedNewX = ones.appendHorizontal(m: newX)
        
        let a = (onedNewX.transpose() <*> onedNewX)
        let b = (onedNewX.transpose() <*> y)
        
        return try a.solveEquationsSystem(vector: b.grid).grid
    }
    
    
    func predict(x: Matrix) -> Matrix {
        let beta = Matrix(rows: betas.count, columns: 1, grid: betas)
        let newX = calculatePowersOfX(x: x)
        let ones = Matrix(rows: newX.rows, columns: 1, repeatedValue: 1)
        let onedNewX = ones.appendHorizontal(m: newX)
        
        return onedNewX * beta
    }
}
