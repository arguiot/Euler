//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-02-07.
//
#if !os(Linux)
import Foundation
import Accelerate

extension Matrix {
    /** Creates a matrix where each element is 0. */
    public static func zeros(rows: Int, columns: Int) -> Matrix {
        return Matrix(rows: rows, columns: columns, repeatedValue: 0)
    }
    
    public static func zeros(size: (Int, Int)) -> Matrix {
        return Matrix(size: size, repeatedValue: 0)
    }
    
    /** Creates a matrix where each element is 1. */
    public static func ones(rows: Int, columns: Int) -> Matrix {
        return Matrix(rows: rows, columns: columns, repeatedValue: 1)
    }
    
    public static func ones(size: (Int, Int)) -> Matrix {
        return Matrix(size: size, repeatedValue: 1)
    }
    
    /** Creates a (square) identity matrix. */
    public static func identity(size: Int) -> Matrix {
        var m = zeros(rows: size, columns: size)
        for i in 0..<size { m[i, i] = 1 }
        return m
    }
    
    /** Creates a matrix of random values between 0.0 and 1.0 (inclusive). */
    public static func random(rows: Int, columns: Int) -> Matrix {
        var m = zeros(rows: rows, columns: columns)
        for r in 0..<rows {
            for c in 0..<columns {
                m[r, c] = Double(arc4random()) / 0xffffffff
            }
        }
        return m
    }
}

// MARK: - Querying the matrix
extension Matrix {
    public var size: (Int, Int) {
        return (rows, columns)
    }
    
    /** Returns the total number of elements in the matrix. */
    public var count: Int {
        return rows * columns
    }
    
    /** Returns the largest dimension. */
    public var length: Int {
        return Swift.max(rows, columns)
    }
    
    public subscript(row: Int, column: Int) -> Double {
        get { return grid[(row * columns) + column] }
        set { grid[(row * columns) + column] = newValue }
    }
    
    /** Subscript for when the matrix is a row or column vector. */
    public subscript(i: Int) -> Double {
        get {
            precondition(rows == 1 || columns == 1, "Not a row or column vector")
            return grid[i]
        }
        set {
            precondition(rows == 1 || columns == 1, "Not a row or column vector")
            grid[i] = newValue
        }
    }
    
    /** Get or set an entire row. */
    public subscript(row r: Int) -> Matrix {
        get {
            var v = Matrix.zeros(rows: 1, columns: columns)
            
            /**
             for c in 0..<columns {
             m[c] = self[r, c]
             }
             */
            
            grid.withUnsafeBufferPointer { src in
                v.grid.withUnsafeMutableBufferPointer { dst in
                    cblas_dcopy(Int32(columns), src.baseAddress! + r*columns, 1, dst.baseAddress, 1)
                }
            }
            return v
        }
        set(v) {
            precondition(v.rows == 1 && v.columns == columns, "Not a compatible row vector")
            
            /**
             for c in 0..<columns {
             self[r, c] = v[c]
             }
             */
            
            v.grid.withUnsafeBufferPointer { src in
                grid.withUnsafeMutableBufferPointer { grid in
                    cblas_dcopy(Int32(columns), src.baseAddress, 1, grid.baseAddress! + r*columns, 1)
                }
            }
        }
    }
    
    /** Get or set multiple rows. */
    public subscript(rows range: CountableRange<Int>) -> Matrix {
        get {
            precondition(range.upperBound <= rows, "Invalid range")
            
            var m = Matrix.zeros(rows: range.upperBound - range.lowerBound, columns: columns)
            for r in range {
                for c in 0..<columns {
                    m[r - range.lowerBound, c] = self[r, c]
                }
            }
            return m
        }
        set(m) {
            precondition(range.upperBound <= rows, "Invalid range")
            
            for r in range {
                for c in 0..<columns {
                    self[r, c] = m[r - range.lowerBound, c]
                }
            }
        }
    }
    
    public subscript(rows range: CountableClosedRange<Int>) -> Matrix {
        get {
            return self[rows: CountableRange(range)]
        }
        set(m) {
            self[rows: CountableRange(range)] = m
        }
    }
    
    /** Gets just the rows specified, in that order. */
    public subscript(rows rowIndices: [Int]) -> Matrix {
        var m = Matrix.zeros(rows: rowIndices.count, columns: columns)
        
        /**
         for (i, r) in rowIndices.enumerate() {
         for c in 0..<columns {
         m[i, c] = self[r, c]
         }
         }
         */
        
        grid.withUnsafeBufferPointer { src in
            m.grid.withUnsafeMutableBufferPointer { dst in
                for (i, r) in rowIndices.enumerated() {
                    cblas_dcopy(Int32(columns), src.baseAddress! + r*columns, 1, dst.baseAddress! + i*columns, 1)
                }
            }
        }
        return m
    }
    
    /** Get or set an entire column. */
    public subscript(column c: Int) -> Matrix {
        get {
            var v = Matrix.zeros(rows: rows, columns: 1)
            
            /**
             for r in 0..<rows {
             m[r] = self[r, c]
             }
             */
            
            grid.withUnsafeBufferPointer { src in
                v.grid.withUnsafeMutableBufferPointer { dst in
                    cblas_dcopy(Int32(rows), src.baseAddress! + c, Int32(columns), dst.baseAddress, 1)
                }
            }
            return v
        }
        set(v) {
            precondition(v.rows == rows && v.columns == 1, "Not a compatible column vector")
            
            /**
             for r in 0..<rows {
             self[r, c] = v[r]
             }
             */
            
            v.grid.withUnsafeBufferPointer { src in
                grid.withUnsafeMutableBufferPointer { grid in
                    cblas_dcopy(Int32(rows), src.baseAddress, 1, grid.baseAddress! + c, Int32(columns))
                }
            }
        }
    }
    
    /** Get or set multiple columns. */
    public subscript(columns range: CountableRange<Int>) -> Matrix {
        get {
            precondition(range.upperBound <= columns, "Invalid range")
            
            var m = Matrix.zeros(rows: rows, columns: range.upperBound - range.lowerBound)
            for r in 0..<rows {
                for c in range {
                    m[r, c - range.lowerBound] = self[r, c]
                }
            }
            return m
        }
        set(m) {
            precondition(range.upperBound <= columns, "Invalid range")
            
            for r in 0..<rows {
                for c in range {
                    self[r, c] = m[r, c - range.lowerBound]
                }
            }
        }
    }
    
    public subscript(columns range: CountableClosedRange<Int>) -> Matrix {
        get {
            return self[columns: CountableRange(range)]
        }
        set(m) {
            self[columns: CountableRange(range)] = m
        }
    }
    
    /** Useful for when the matrix is 1x1 or you want to get the first element. */
    public var scalar: Double {
        return grid[0]
    }
    
    /** Converts the matrix into a 2-dimensional array. */
    public var array: [[Double]] {
        var a = [[Double]](repeating: [Double](repeating: 0, count: columns), count: rows)
        for r in 0..<rows {
            for c in 0..<columns {
                a[r][c] = self[r, c]
            }
        }
        return a
    }
}

#endif
