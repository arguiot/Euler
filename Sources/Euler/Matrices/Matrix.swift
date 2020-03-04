//
//  Matrix.swift
//  
//
//  Created by Arthur Guiot on 2020-02-07.
//
#if os(macOS)
import Foundation
import Accelerate

/// Simple Matrix type
///
/// ## ⚠️: Not available on Linux
///
/// Matrix uses the Accelerate.framework for most of its operations, so it should be pretty fast -- but no doubt there's lots of room for improvement.
/// Since the Accelerate framework works a lot with `Double`, I had to find a compromise between performance and compatibility with other `Euler` object, such as `BigNumber`. I made some convenience initializer, but make sure your code converts these `BigNumber` to `Double` using `BigNumber.asDouble`
///
/// For example, here's how you can use Matrix as part of the k-nearest neighbors algorithm:
/// ```swift
/// // load your data set into matrix X, where each row represents one training
/// // example, and each column a feature
/// let X = Matrix(rows: 10000, columns: 200)
///
/// // load your test example into the row vector x
/// let x = Matrix(rows: 1, columns: 200)
///
/// // Calculate the distance between the test example and every training example
/// // and store this in a new column vector
/// let distances = (x.tile(X.rows) - X).pow(2).sumRows().sqrt()
/// ```
///
public struct Matrix {
    public let rows: Int
    public let columns: Int
    var grid: [Double]
}

// MARK: - Creating matrices
extension Matrix {
    public init(rows: Int, columns: Int, repeatedValue: Double) {
        self.rows = rows
        self.columns = columns
        self.grid = .init(repeating: repeatedValue, count: rows * columns)
    }
    
    public init(size: (Int, Int), repeatedValue: Double) {
        self.init(rows: size.0, columns: size.1, repeatedValue: repeatedValue)
    }
    
    /** Creates a matrix from an array: [[a, b], [c, d], [e, f]]. */
    public init(_ data: [[Double]]) {
        self.init(data, range: 0..<data[0].count)
    }
    
    /** Creates a matrix from an array: [[a, b], [c, d], [e, f]]. */
    public init(_ data: [[BigDouble]]) {
        let drow = data.map { $0.map { $0.asDouble() ?? Double.nan }}
        self.init(drow)
    }
    
    /** Extracts one or more columns into a new matrix. */
    public init(_ data: [[Double]], range: CountableRange<Int>) {
        let m = data.count
        let n = range.upperBound - range.lowerBound
        self.init(rows: m, columns: n, repeatedValue: 0)
        
        /**
         for (i, row) in data.enumerate() {
         for j in range {
         self[i, j - range.startIndex] = row[j]
         }
         }
         */
        
        for (i, row) in data.enumerated() {
            row.withUnsafeBufferPointer { src in
                cblas_dcopy(Int32(n), src.baseAddress! + range.lowerBound, 1, &grid + i*columns, 1)
            }
        }
    }
    
    /// Extracts one or more columns into a new matrix.
    public init(_ data: [[Double]], range: CountableClosedRange<Int>) {
        self.init(data, range: CountableRange(range))
    }
    
    /// Extracts one or more columns into a new matrix.
    public init(_ data: [[BigDouble]], range: CountableClosedRange<Int>) {
        let drow = data.map { $0.map { $0.asDouble() ?? Double.nan }}
        self.init(drow, range: range)
    }
    
    /// Extracts one or more columns into a new matrix.
    public init(_ data: [[BigDouble]], range: CountableRange<Int>) {
        let drow = data.map { $0.map { $0.asDouble() ?? Double.nan }}
        self.init(drow, range: range)
    }
    
    /** Creates a matrix from a row vector or column vector. */
    public init(_ contents: [Double], isColumnVector: Bool = false) {
        if isColumnVector {
            self.rows = contents.count
            self.columns = 1
        } else {
            self.rows = 1
            self.columns = contents.count
        }
        self.grid = contents
    }
    
    /** Creates a matrix containing the numbers in the specified range. */
    public init(_ range: CountableRange<Int>, isColumnVector: Bool = false) {
        if isColumnVector {
            self.init(rows: 1, columns: range.upperBound - range.lowerBound, repeatedValue: 0)
            for c in range {
                self[0, c - range.lowerBound] = Double(c)
            }
        } else {
            self.init(rows: range.upperBound - range.lowerBound, columns: 1, repeatedValue: 0)
            for r in range {
                self[r - range.lowerBound, 0] = Double(r)
            }
        }
    }
    
    public init(_ range: CountableClosedRange<Int>, isColumnVector: Bool = false) {
        self.init(CountableRange(range), isColumnVector: isColumnVector)
    }
}

extension Matrix: ExpressibleByArrayLiteral {
    /** Array literals are interpreted as row vectors. */
    public init(arrayLiteral: Double...) {
        self.rows = 1
        self.columns = arrayLiteral.count
        self.grid = arrayLiteral
    }
}

extension Matrix {
    /** Duplicates a row vector across "d" rows. */
    public func tile(_ d: Int) -> Matrix {
        precondition(rows == 1)
        var m = Matrix.zeros(rows: d, columns: columns)
        
        /**
         for r in 0..<d {
         for c in 0..<columns {
         m[r, c] = self[0, c]
         }
         }
         */
        
        grid.withUnsafeBufferPointer { src in
            m.grid.withUnsafeMutableBufferPointer { dst in
                for i in 0..<d {
                    // Alternatively, use memcpy instead of BLAS.
                    //memcpy(ptr, src.baseAddress, columns * MemoryLayout<Double>.stride)
                    cblas_dcopy(Int32(columns), src.baseAddress, 1, dst.baseAddress?.advanced(by: columns * i), 1)
                }
            }
        }
        return m
    }
}

extension Matrix {
    /** Copies the contents of an NSData object into the matrix. */
    public init(rows: Int, columns: Int, data: NSData) {
        precondition(data.length >= rows * columns * MemoryLayout<Double>.stride)
        self.init(rows: rows, columns: columns, repeatedValue: 0)
        
        grid.withUnsafeMutableBufferPointer { dst in
            let src = UnsafePointer<Double>(OpaquePointer(data.bytes))
            cblas_dcopy(Int32(rows * columns), src, 1, dst.baseAddress, 1)
        }
    }
    
    /** Copies the contents of the matrix into an NSData object. */
    public var data: NSData? {
        if let data = NSMutableData(length: rows * columns * MemoryLayout<Double>.stride) {
            grid.withUnsafeBufferPointer { src in
                let dst = UnsafeMutablePointer<Double>(OpaquePointer(data.bytes))
                cblas_dcopy(Int32(rows * columns), src.baseAddress, 1, dst, 1)
            }
            return data
        } else {
            return nil
        }
    }
}

// MARK: - Printable
extension Matrix: CustomStringConvertible {
    public var description: String {
        var description = ""
        
        for i in 0..<rows {
            let contents = (0..<columns).map{ String(format: "%20.10f", self[i, $0]) }.joined(separator: " ")
            
            switch (i, rows) {
            case (0, 1):
                description += "( \(contents) )\n"
            case (0, _):
                description += "⎛ \(contents) ⎞\n"
            case (rows - 1, _):
                description += "⎝ \(contents) ⎠\n"
            default:
                description += "⎜ \(contents) ⎥\n"
            }
        }
        return description
    }
}

// MARK: - SequenceType
/** Lets you iterate through the rows of the matrix. */
extension Matrix: Sequence {
    public func makeIterator() -> AnyIterator<ArraySlice<Double>> {
        let endIndex = rows * columns
        var nextRowStartIndex = 0
        return AnyIterator {
            if nextRowStartIndex == endIndex {
                return nil
            } else {
                let currentRowStartIndex = nextRowStartIndex
                nextRowStartIndex += self.columns
                return self.grid[currentRowStartIndex..<nextRowStartIndex]
            }
        }
    }
}

#endif
