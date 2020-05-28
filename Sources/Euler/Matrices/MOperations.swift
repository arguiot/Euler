//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-02-07.
//
#if !os(Linux)
import Foundation
import Accelerate

// MARK: - Operations
extension Matrix {
    /// Inverse of the Matrix
    ///
    /// In linear algebra, an n-by-n square matrix A is called invertible (also nonsingular or nondegenerate) if there exists an n-by-n square matrix B such that
    /// ```$
    /// AB = BA = I_n
    /// $```
    /// where In denotes the n-by-n identity matrix and the multiplication used is ordinary matrix multiplication.
    ///
    public func inverse() -> Matrix {
        precondition(rows == columns, "Matrix must be square")
        
        var results = self
        results.grid.withUnsafeMutableBufferPointer { ptr in
            var ipiv = [__CLPK_integer](repeating: 0, count: rows * rows)
            var lwork = __CLPK_integer(columns * columns)
            var work = [CDouble](repeating: 0, count: Int(lwork))
            var error: __CLPK_integer = 0
            var nc = __CLPK_integer(columns)
            var m = nc
            var n = nc
            
            dgetrf_(&m, &n, ptr.baseAddress, &nc, &ipiv, &error)
            dgetri_(&m, ptr.baseAddress, &nc, &ipiv, &work, &lwork, &error)
            
            assert(error == 0, "Matrix not invertible")
        }
        return results
    }
}

extension Matrix {
    /// Transpose the `Matrix` by flipping it diagonally
    ///
    /// In linear algebra, the transpose of a matrix is an operator which flips a matrix over its diagonal, that is it switches the row and column indices of the matrix by producing another matrix denoted as A'
    public func transpose() -> Matrix {
        var results = Matrix(rows: columns, columns: rows, repeatedValue: 0)
        grid.withUnsafeBufferPointer { srcPtr in
            vDSP_mtransD(srcPtr.baseAddress!, 1, &results.grid, 1, vDSP_Length(results.rows), vDSP_Length(results.columns))
        }
        return results
    }
}
// MARK: Operators
infix operator </> : MultiplicationPrecedence
postfix operator ′
infix operator <*> : MultiplicationPrecedence

public extension Matrix {
    
    /// Transpose the `Matrix` by flipping it diagonally
    /// - Parameter value: The `Matrix` you want to transpose
    static postfix func ′ (value: Matrix) -> Matrix {
        return value.transpose()
    }
    
    // MARK: - Arithmetic
    /**
     Element-by-element addition.
     Either:
     - both matrices have the same size
     - rhs is a row vector with an equal number of columns as lhs
     - rhs is a column vector with an equal number of rows as lhs
     */
    static func + (lhs: Matrix, rhs: Matrix) -> Matrix {
        if lhs.columns == rhs.columns {
            if rhs.rows == 1 {   // rhs is row vector
                /**
                 var results = lhs
                 for r in 0..<results.rows {
                 for c in 0..<results.columns {
                 results[r, c] += rhs[0, c]
                 }
                 }
                 return results
                 */
                
                var results = Matrix.zeros(size: lhs.size)
                lhs.grid.withUnsafeBufferPointer{ src in
                    results.grid.withUnsafeMutableBufferPointer{ dst in
                        for c in 0..<lhs.columns {
                            var v = rhs[c]
                            vDSP_vsaddD(src.baseAddress! + c, vDSP_Stride(lhs.columns), &v, dst.baseAddress! + c, vDSP_Stride(lhs.columns), vDSP_Length(lhs.rows))
                        }
                    }
                }
                return results
                
            } else if lhs.rows == rhs.rows {   // lhs and rhs are same size
                var results = rhs
                lhs.grid.withUnsafeBufferPointer { lhsPtr in
                    results.grid.withUnsafeMutableBufferPointer { resultsPtr in
                        cblas_daxpy(Int32(lhs.grid.count), 1, lhsPtr.baseAddress, 1, resultsPtr.baseAddress, 1)
                    }
                }
                return results
            }
        } else if lhs.rows == rhs.rows && rhs.columns == 1 {  // rhs is column vector
            /**
             var results = lhs
             for c in 0..<results.columns {
             for r in 0..<results.rows {
             results[r, c] += rhs[r, 0]
             }
             }
             return results
             */
            
            var results = Matrix.zeros(size: lhs.size)
            lhs.grid.withUnsafeBufferPointer{ src in
                results.grid.withUnsafeMutableBufferPointer{ dst in
                    for r in 0..<lhs.rows {
                        var v = rhs[r]
                        vDSP_vsaddD(src.baseAddress! + r*lhs.columns, 1, &v, dst.baseAddress! + r*lhs.columns, 1, vDSP_Length(lhs.columns))
                    }
                }
            }
            return results
        }
        
        fatalError("Cannot add \(lhs.rows)×\(lhs.columns) matrix and \(rhs.rows)×\(rhs.columns) matrix")
    }
    /** Element-by-element addition of the same `Matrix` with another */
    static func += (lhs: inout Matrix, rhs: Matrix) {
        lhs = lhs + rhs
    }
    
    /** Adds a scalar to each element of the matrix. */
    static func + (lhs: Matrix, rhs: Double) -> Matrix {
        /**
         var m = lhs
         for r in 0..<m.rows {
         for c in 0..<m.columns {
         m[r, c] += rhs
         }
         }
         return m
         */
        
        var results = lhs
        lhs.grid.withUnsafeBufferPointer { src in
            results.grid.withUnsafeMutableBufferPointer { dst in
                var scalar = rhs
                vDSP_vsaddD(src.baseAddress!, 1, &scalar, dst.baseAddress!, 1, vDSP_Length(lhs.rows * lhs.columns))
            }
        }
        return results
    }
    /** Adds a scalar to each element of the same matrix. */
    static func += (lhs: inout Matrix, rhs: Double) {
        lhs = lhs + rhs
    }
    
    /** Adds a scalar to each element of the matrix. */
    static func + (lhs: Double, rhs: Matrix) -> Matrix {
        return rhs + lhs
    }
    
    /**
     Element-by-element subtraction.
     Either:
     - both matrices have the same size
     - rhs is a row vector with an equal number of columns as lhs
     - rhs is a column vector with an equal number of rows as lhs
     */
    static func - (lhs: Matrix, rhs: Matrix) -> Matrix {
        if lhs.columns == rhs.columns {
            if rhs.rows == 1 {   // rhs is row vector
                /**
                 var results = lhs
                 for r in 0..<results.rows {
                 for c in 0..<results.columns {
                 results[r, c] -= rhs[0, c]
                 }
                 }
                 return results
                 */
                
                var results = Matrix.zeros(size: lhs.size)
                lhs.grid.withUnsafeBufferPointer{ src in
                    results.grid.withUnsafeMutableBufferPointer{ dst in
                        for c in 0..<lhs.columns {
                            var v = -rhs[c]
                            vDSP_vsaddD(src.baseAddress! + c, vDSP_Stride(lhs.columns), &v, dst.baseAddress! + c, vDSP_Stride(lhs.columns), vDSP_Length(lhs.rows))
                        }
                    }
                }
                return results
                
            } else if lhs.rows == rhs.rows {   // lhs and rhs are same size
                var results = lhs
                rhs.grid.withUnsafeBufferPointer { rhsPtr in
                    results.grid.withUnsafeMutableBufferPointer { resultsPtr in
                        cblas_daxpy(Int32(rhs.grid.count), -1, rhsPtr.baseAddress, 1, resultsPtr.baseAddress, 1)
                    }
                }
                return results
            }
            
        } else if lhs.rows == rhs.rows && rhs.columns == 1 {  // rhs is column vector
            /**
             var results = lhs
             for c in 0..<results.columns {
             for r in 0..<results.rows {
             results[r, c] -= rhs[r, 0]
             }
             }
             return results
             */
            
            var results = Matrix.zeros(size: lhs.size)
            lhs.grid.withUnsafeBufferPointer{ src in
                results.grid.withUnsafeMutableBufferPointer{ dst in
                    for r in 0..<lhs.rows {
                        var v = -rhs[r]
                        vDSP_vsaddD(src.baseAddress! + r*lhs.columns, 1, &v, dst.baseAddress! + r*lhs.columns, 1, vDSP_Length(lhs.columns))
                    }
                }
            }
            return results
        }
        
        fatalError("Cannot subtract \(lhs.rows)×\(lhs.columns) matrix and \(rhs.rows)×\(rhs.columns) matrix")
    }
    
    /** Subtracts a scalar from each element of the matrix. */
    static func - (lhs: Matrix, rhs: Double) -> Matrix {
        return lhs + (-rhs)
    }
    /** Subtracts a scalar from each element of the same matrix. */
    static func -= (lhs: inout Matrix, rhs: Double) {
        lhs = lhs - rhs
    }
    
    /** Subtracts each element of the matrix from a scalar. */
    static func - (lhs: Double, rhs: Matrix) -> Matrix {
        /**
         var m = rhs
         for r in 0..<m.rows {
         for c in 0..<m.columns {
         m[r, c] = lhs - rhs[r, c]
         }
         }
         return m
         */
        
        var results = rhs
        var scalar = lhs
        let length = vDSP_Length(rhs.rows * rhs.columns)
        results.grid.withUnsafeMutableBufferPointer { ptr in
            vDSP_vnegD(ptr.baseAddress!, 1, ptr.baseAddress!, 1, length)
            vDSP_vsaddD(ptr.baseAddress!, 1, &scalar, ptr.baseAddress!, 1, length)
        }
        return results
    }
    
    /** Negates each element of the matrix. */
    static prefix func -(m: Matrix) -> Matrix {
        /**
         var results = m
         for r in 0..<m.rows {
         for c in 0..<m.columns {
         results[r, c] = -m[r, c]
         }
         }
         return results
         */
        
        var results = m
        m.grid.withUnsafeBufferPointer { src in
            results.grid.withUnsafeMutableBufferPointer { dst in
                vDSP_vnegD(src.baseAddress!, 1, dst.baseAddress!, 1, vDSP_Length(m.rows * m.columns))
            }
        }
        return results
    }
    
    /** Multiplies two matrices, or a matrix with a vector. */
    static func <*> (lhs: Matrix, rhs: Matrix) -> Matrix {
        precondition(lhs.columns == rhs.rows, "Cannot multiply \(lhs.rows)×\(lhs.columns) matrix and \(rhs.rows)×\(rhs.columns) matrix")
        
        var results = Matrix(rows: lhs.rows, columns: rhs.columns, repeatedValue: 0)
        lhs.grid.withUnsafeBufferPointer { lhsPtr in
            rhs.grid.withUnsafeBufferPointer { rhsPtr in
                cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, Int32(lhs.rows), Int32(rhs.columns), Int32(lhs.columns), 1, lhsPtr.baseAddress, Int32(lhs.columns), rhsPtr.baseAddress, Int32(rhs.columns), 0, &results.grid, Int32(results.columns))
            }
        }
        return results
    }
    
    /**
     Warning: This is not the dot product, see `<*>` for that.
     
     Multiplies each element of the lhs matrix by each element of the rhs matrix.
     Either:
     - both matrices have the same size
     - rhs is a row vector with an equal number of columns as lhs
     - rhs is a column vector with an equal number of rows as lhs
     */
    static func * (lhs: Matrix, rhs: Matrix) -> Matrix {
        if lhs.columns == rhs.columns {
            if rhs.rows == 1 {   // rhs is row vector
                /**
                 var results = lhs
                 for r in 0..<results.rows {
                 for c in 0..<results.columns {
                 results[r, c] *= rhs[0, c]
                 }
                 }
                 return results
                 */
                
                var results = Matrix.zeros(size: lhs.size)
                lhs.grid.withUnsafeBufferPointer{ src in
                    results.grid.withUnsafeMutableBufferPointer{ dst in
                        for c in 0..<lhs.columns {
                            var v = rhs[c]
                            vDSP_vsmulD(src.baseAddress! + c, vDSP_Stride(lhs.columns), &v, dst.baseAddress! + c, vDSP_Stride(lhs.columns), vDSP_Length(lhs.rows))
                        }
                    }
                }
                return results
                
            } else if lhs.rows == rhs.rows {   // lhs and rhs are same size
                /**
                 var results = lhs
                 for r in 0..<results.rows {
                 for c in 0..<results.columns {
                 results[r, c] *= rhs[r, c]
                 }
                 }
                 return results
                 */
                
                var results = Matrix.zeros(size: lhs.size)
                rhs.grid.withUnsafeBufferPointer{ srcX in
                    lhs.grid.withUnsafeBufferPointer{ srcY in
                        results.grid.withUnsafeMutableBufferPointer{ dstZ in
                            vDSP_vmulD(srcX.baseAddress!, 1, srcY.baseAddress!, 1, dstZ.baseAddress!, 1, vDSP_Length(lhs.rows * lhs.columns))
                        }
                    }
                }
                return results
            }
            
        } else if lhs.rows == rhs.rows && rhs.columns == 1 {  // rhs is column vector
            /**
             var results = lhs
             for c in 0..<results.columns {
             for r in 0..<results.rows {
             results[r, c] *= rhs[r, 0]
             }
             }
             return results
             */
            
            var results = Matrix.zeros(size: lhs.size)
            lhs.grid.withUnsafeBufferPointer{ src in
                results.grid.withUnsafeMutableBufferPointer{ dst in
                    for r in 0..<lhs.rows {
                        var v = rhs[r]
                        vDSP_vsmulD(src.baseAddress! + r*lhs.columns, 1, &v, dst.baseAddress! + r*lhs.columns, 1, vDSP_Length(lhs.columns))
                    }
                }
            }
            return results
        }
        
        fatalError("Cannot element-wise multiply \(lhs.rows)×\(lhs.columns) matrix and \(rhs.rows)×\(rhs.columns) matrix")
    }
    
    /** Multiplies each element of the matrix with a scalar. */
    static func * (lhs: Matrix, rhs: Double) -> Matrix {
        var results = lhs
        results.grid.withUnsafeMutableBufferPointer { ptr in
            cblas_dscal(Int32(lhs.grid.count), rhs, ptr.baseAddress, 1)
        }
        return results
    }
    
    /** Multiplies each element of the matrix with a scalar. */
    static func * (lhs: Double, rhs: Matrix) -> Matrix {
        return rhs * lhs
    }
    
    /** Divides a matrix by another. This is the same as multiplying with the inverse. */
    static func </> (lhs: Matrix, rhs: Matrix) -> Matrix {
        let inv = rhs.inverse()
        precondition(lhs.columns == inv.rows, "Cannot divide \(lhs.rows)×\(lhs.columns) matrix and \(rhs.rows)×\(rhs.columns) matrix")
        return lhs <*> inv
    }
    
    /**
     Divides each element of the lhs matrix by each element of the rhs matrix.
     Either:
     - both matrices have the same size
     - rhs is a row vector with an equal number of columns as lhs
     - rhs is a column vector with an equal number of rows as lhs
     */
    static func / (lhs: Matrix, rhs: Matrix) -> Matrix {
        if lhs.columns == rhs.columns {
            if rhs.rows == 1 {   // rhs is row vector
                /**
                 var results = lhs
                 for r in 0..<results.rows {
                 for c in 1..<results.columns {
                 results[r, c] /= rhs[0, c]
                 }
                 }
                 return results
                 */
                
                var results = Matrix.zeros(size: lhs.size)
                lhs.grid.withUnsafeBufferPointer{ src in
                    results.grid.withUnsafeMutableBufferPointer{ dst in
                        for c in 0..<lhs.columns {
                            var v = rhs[c]
                            vDSP_vsdivD(src.baseAddress! + c, vDSP_Stride(lhs.columns), &v, dst.baseAddress! + c, vDSP_Stride(lhs.columns), vDSP_Length(lhs.rows))
                        }
                    }
                }
                return results
                
            } else if lhs.rows == rhs.rows {   // lhs and rhs are same size
                /**
                 var results = lhs
                 for r in 0..<results.rows {
                 for c in 0..<results.columns {
                 results[r, c] /= rhs[r, c]
                 }
                 }
                 return results
                 */
                
                var results = Matrix.zeros(size: lhs.size)
                rhs.grid.withUnsafeBufferPointer{ srcX in
                    lhs.grid.withUnsafeBufferPointer{ srcY in
                        results.grid.withUnsafeMutableBufferPointer{ dstZ in
                            vDSP_vdivD(srcX.baseAddress!, 1, srcY.baseAddress!, 1, dstZ.baseAddress!, 1, vDSP_Length(lhs.rows * lhs.columns))
                        }
                    }
                }
                return results
            }
            
        } else if lhs.rows == rhs.rows && rhs.columns == 1 {  // rhs is column vector
            /**
             var results = lhs
             for c in 0..<results.columns {
             for r in 0..<results.rows {
             results[r, c] /= rhs[r, 0]
             }
             }
             return results
             */
            
            var results = Matrix.zeros(size: lhs.size)
            lhs.grid.withUnsafeBufferPointer{ src in
                results.grid.withUnsafeMutableBufferPointer{ dst in
                    for r in 0..<lhs.rows {
                        var v = rhs[r]
                        vDSP_vsdivD(src.baseAddress! + r*lhs.columns, 1, &v, dst.baseAddress! + r*lhs.columns, 1, vDSP_Length(lhs.columns))
                    }
                }
            }
            return results
        }
        
        fatalError("Cannot element-wise divide \(lhs.rows)×\(lhs.columns) matrix and \(rhs.rows)×\(rhs.columns) matrix")
    }
    
    /** Divides each element of the matrix by a scalar. */
    static func / (lhs: Matrix, rhs: Double) -> Matrix {
        var results = lhs
        results.grid.withUnsafeMutableBufferPointer { ptr in
            cblas_dscal(Int32(lhs.grid.count), 1/rhs, ptr.baseAddress, 1)
        }
        return results
    }
    
    /** Divides a scalar by each element of the matrix. */
    static func / (lhs: Double, rhs: Matrix) -> Matrix {
        /**
         var m = rhs
         for r in 0..<m.rows {
         for c in 0..<m.columns {
         m[r, c] = lhs / rhs[r, c]
         }
         }
         return m
         */
        
        var results = rhs
        rhs.grid.withUnsafeBufferPointer { src in
            results.grid.withUnsafeMutableBufferPointer { dst in
                var scalar = lhs
                vDSP_svdivD(&scalar, src.baseAddress!, 1, dst.baseAddress!, 1, vDSP_Length(rhs.rows * rhs.columns))
            }
        }
        return results
    }
}


// MARK: - Other maths
extension Matrix {
    /** Exponentiates each element of the matrix. */
    public func exp() -> Matrix {
        /**
         var result = m
         for r in 0..<m.rows {
         for c in 0..<m.columns {
         result[r, c] = exp(m[r, c])
         }
         }
         return result
         */
        
        var result = self
        grid.withUnsafeBufferPointer { src in
            result.grid.withUnsafeMutableBufferPointer { dst in
                var size = Int32(rows * columns)
                vvexp(dst.baseAddress!, src.baseAddress!, &size)
            }
        }
        return result
    }
    
    /** Takes the natural logarithm of each element of the matrix. */
    public func log() -> Matrix {
        /**
         var result = m
         for r in 0..<m.rows {
         for c in 0..<m.columns {
         result[r, c] = log(m[r, c])
         }
         }
         return result
         */
        
        var result = self
        grid.withUnsafeBufferPointer { src in
            result.grid.withUnsafeMutableBufferPointer { dst in
                var size = Int32(rows * columns)
                vvlog(dst.baseAddress!, src.baseAddress!, &size)
            }
        }
        return result
    }
    
    /** Raised each element of the matrix to power alpha. */
    public func pow(_ alpha: Double) -> Matrix {
        /**
         var result = m
         for r in 0..<m.rows {
         for c in 0..<m.columns {
         result[r, c] = pow(m[r, c], alpha)
         }
         }
         return result
         */
        
        var result = self
        grid.withUnsafeBufferPointer { src in
            result.grid.withUnsafeMutableBufferPointer { dst in
                if alpha == 2.0 {
                    vDSP_vsqD(src.baseAddress!, 1, dst.baseAddress!, 1, vDSP_Length(rows * columns))
                } else {
                    var size = Int32(rows * columns)
                    var exponent = alpha
                    vvpows(dst.baseAddress!, &exponent, src.baseAddress!, &size)
                }
            }
        }
        return result
    }
    
    /** Takes the square root of each element of the matrix. */
    public func sqrt() -> Matrix {
        /**
         var result = m
         for r in 0..<m.rows {
         for c in 0..<m.columns {
         result[r, c] = sqrt(m[r, c])
         }
         }
         return result
         */
        
        var result = self
        grid.withUnsafeBufferPointer { src in
            result.grid.withUnsafeMutableBufferPointer { dst in
                var size = Int32(rows * columns)
                vvsqrt(dst.baseAddress!, src.baseAddress!, &size)
            }
        }
        return result
    }
    
    /** Adds up all the elements in the matrix. */
    public func sum() -> BigDouble {
        var result = 0.0
        
        /**
         for r in 0..<m.rows {
         for c in 0..<m.columns {
         result += m[r, c]
         }
         }
         */
        
        grid.withUnsafeBufferPointer { src in
            vDSP_sveD(src.baseAddress!, 1, &result, vDSP_Length(rows * columns))
        }
        return BigDouble(result)
    }
    
    /** Adds up the elements in each row. Returns a column vector. */
    public func sumRows() -> Matrix {
        var result = Matrix.zeros(rows: rows, columns: 1)
        
        /**
         for r in 0..<m.rows {
         for c in 0..<m.columns {
         result[r] += m[r, c]
         }
         }
         */
        
        grid.withUnsafeBufferPointer { src in
            result.grid.withUnsafeMutableBufferPointer { dst in
                for r in 0..<rows {
                    vDSP_sveD(src.baseAddress! + r*columns, 1, dst.baseAddress! + r, vDSP_Length(columns))
                }
            }
        }
        return result
    }
    
    /** Adds up the elements in each column. Returns a row vector. */
    public func sumColumns() -> Matrix {
        var result = Matrix.zeros(rows: 1, columns: columns)
        
        /**
         for c in 0..<m.columns {
         for r in 0..<m.rows {
         result[c] += m[r, c]
         }
         }
         */
        
        grid.withUnsafeBufferPointer { src in
            result.grid.withUnsafeMutableBufferPointer { dst in
                for c in 0..<columns {
                    vDSP_sveD(src.baseAddress! + c, vDSP_Stride(columns), dst.baseAddress! + c, vDSP_Length(rows))
                }
            }
        }
        return result
    }
    
    /// Returns the matrix determinant
    ///
    /// In linear algebra, the determinant is a scalar value that can be computed from the elements of a square matrix and encodes certain properties of the linear transformation described by the matrix. The determinant of a matrix A is denoted det(A), det A, or |A|. Geometrically, it can be viewed as the volume scaling factor of the linear transformation described by the matrix. This is also the signed volume of the n-dimensional parallelepiped spanned by the column or row vectors of the matrix. The determinant is positive or negative according to whether the linear mapping preserves or reverses the orientation of n-space.
    ///
    public func determinant() -> BigDouble? {
        let lhs = self
        var decomposed = lhs
        let c = [decomposed.rows, decomposed.columns]
        var pivots = [__CLPK_integer](repeating: 0, count: c.min()!)
        var info = __CLPK_integer()
        var m = __CLPK_integer(decomposed.rows)
        var n = __CLPK_integer(decomposed.columns)
        _ = withUnsafeMutableMemory(&pivots, &(decomposed.grid)) { ipiv, grid in
            withUnsafeMutablePointers(&m, &n, &info) { m, n, info in
                dgetrf_(m, n, grid.pointer, m, ipiv.pointer, info)
            }
        }
        
        if info != 0 {
            return nil
        }
        
        var det = 1 as Double
        for (i, p) in zip(pivots.indices, pivots) {
            if p != i + 1 {
                det = -det * decomposed[i, i]
            } else {
                det = det * decomposed[i, i]
            }
        }
        return BigDouble(det)
    }
}

// MARK: - Minimum and maximum
extension Matrix {
    public func min(row r: Int) -> (Double, Int) {
        /**
         var result = self[r, 0]
         var index = 0
         for c in 1..<columns {
         if self[r, c] < result {
         result = self[r, c]
         index = c
         }
         }
         return (result, index)
         */
        
        var result = 0.0
        var index: vDSP_Length = 0
        grid.withUnsafeBufferPointer { ptr in
            vDSP_minviD(ptr.baseAddress! + r*columns, 1, &result, &index, vDSP_Length(columns))
        }
        return (result, Int(index))
    }
    
    public func max(row r: Int) -> (Double, Int) {
        /**
         var result = self[r, 0]
         var index = 0
         for c in 1..<columns {
         if self[r, c] > result {
         result = self[r, c]
         index = c
         }
         }
         return (result, index)
         */
        
        var result = 0.0
        var index: vDSP_Length = 0
        grid.withUnsafeBufferPointer { ptr in
            vDSP_maxviD(ptr.baseAddress! + r*columns, 1, &result, &index, vDSP_Length(columns))
        }
        return (result, Int(index))
    }
    
    public func minRows() -> Matrix {
        var mins = Matrix.zeros(rows: rows, columns: 1)
        for r in 0..<rows {
            mins[r] = min(row: r).0
        }
        return mins
    }
    
    public func maxRows() -> Matrix {
        var maxs = Matrix.zeros(rows: rows, columns: 1)
        for r in 0..<rows {
            maxs[r] = max(row: r).0
        }
        return maxs
    }
    
    public func min(column c: Int) -> (Double, Int) {
        /**
         var result = self[0, c]
         var index = 0
         for r in 1..<rows {
         if self[r, c] < result {
         result = self[r, c]
         index = r
         }
         }
         return (result, index)
         */
        
        var result = 0.0
        var index: vDSP_Length = 0
        grid.withUnsafeBufferPointer { ptr in
            vDSP_minviD(ptr.baseAddress! + c, vDSP_Stride(columns), &result, &index, vDSP_Length(rows))
        }
        return (result, Int(index) / columns)
    }
    
    public func max(column c: Int) -> (Double, Int) {
        /**
         var result = self[0, c]
         var index = 0
         for r in 1..<rows {
         if self[r, c] > result {
         result = self[r, c]
         index = r
         }
         }
         return (result, index)
         */
        
        var result = 0.0
        var index: vDSP_Length = 0
        grid.withUnsafeBufferPointer { ptr in
            vDSP_maxviD(ptr.baseAddress! + c, vDSP_Stride(columns), &result, &index, vDSP_Length(rows))
        }
        return (result, Int(index) / columns)
    }
    
    public func minColumns() -> Matrix {
        var mins = Matrix.zeros(rows: 1, columns: columns)
        for c in 0..<columns {
            mins[c] = min(column: c).0
        }
        return mins
    }
    
    public func maxColumns() -> Matrix {
        var maxs = Matrix.zeros(rows: 1, columns: columns)
        for c in 0..<columns {
            maxs[c] = max(column: c).0
        }
        return maxs
    }
    
    public func min() -> (Double, Int, Int) {
        var result = 0.0
        var index: vDSP_Length = 0
        grid.withUnsafeBufferPointer { ptr in
            vDSP_minviD(ptr.baseAddress!, 1, &result, &index, vDSP_Length(rows * columns))
        }
        let r = Int(index) / rows
        let c = Int(index) - r * columns
        return (result, r, c)
    }
    
    public func max() -> (Double, Int, Int) {
        var result = 0.0
        var index: vDSP_Length = 0
        grid.withUnsafeBufferPointer { ptr in
            vDSP_maxviD(ptr.baseAddress!, 1, &result, &index, vDSP_Length(rows * columns))
        }
        let r = Int(index) / rows
        let c = Int(index) - r * columns
        return (result, r, c)
    }
}

// MARK: - Statistics
extension Matrix {
    /** Calculates the mean for each of the matrix's columns. */
    public func mean() -> Matrix {
        return mean(0..<columns)
    }
    
    /**
     Calculates the mean for some of the matrix's columns.
     Note: This returns a matrix of the same size as the original one.
     Any columns not in the range are set to 0.
     */
    public func mean(_ range: CountableRange<Int>) -> Matrix {
        /**
         var mu = Matrix.zeros(rows: 1, columns: columns)
         for r in 0..<rows {
         for c in range {
         mu[0, c] += self[r, c]
         }
         }
         for c in range {
         mu[0, c] /= Double(rows)
         }
         return mu
         */
        
        var mu = Matrix.zeros(rows: 1, columns: columns)
        grid.withUnsafeBufferPointer{ srcBuf in
            mu.grid.withUnsafeMutableBufferPointer{ dstBuf in
                var srcPtr = srcBuf.baseAddress! + range.lowerBound
                var dstPtr = dstBuf.baseAddress! + range.lowerBound
                for _ in range {
                    vDSP_meanvD(srcPtr, vDSP_Stride(columns), dstPtr, vDSP_Length(rows))
                    srcPtr += 1
                    dstPtr += 1
                }
            }
        }
        return mu
    }
    
    /**
     Calculates the mean for some of the matrix's columns.
     Note: This returns a matrix of the same size as the original one.
     Any columns not in the range are set to 0.
     */
    public func mean(_ range: CountableClosedRange<Int>) -> Matrix {
        return mean(CountableRange(range))
    }
    
    /** Calculates the standard deviation for each of the matrix's columns. */
    public func std() -> Matrix {
        return std(0..<columns)
    }
    
    /**
     Calculates the standard deviation for some of the matrix's columns.
     Note: This returns a matrix of the same size as the original one.
     Any columns not in the range are set to 0.
     */
    public func std(_ range: CountableRange<Int>) -> Matrix {
        let mu = mean(range)
        
        /**
         var sigma = Matrix.zeros(rows: 1, columns: columns)
         for r in 0..<rows {
         for c in range {
         let d = (self[r, c] - mu[0, c])
         sigma[0, c] += d*d
         }
         }
         for c in range {
         sigma[0, c] /= Double(rows) - 1
         sigma[0, c] = sqrt(sigma[0, c])
         }
         return sigma
         */
        
        var sigma = Matrix.zeros(rows: 1, columns: columns)
        var temp = Matrix.zeros(rows: rows, columns: columns)
        
        grid.withUnsafeBufferPointer{ buf1 in
            temp.grid.withUnsafeMutableBufferPointer{ buf2 in
                sigma.grid.withUnsafeMutableBufferPointer{ buf3 in
                    var ptr1 = buf1.baseAddress! + range.lowerBound
                    var ptr2 = buf2.baseAddress! + range.lowerBound
                    var ptr3 = buf3.baseAddress! + range.lowerBound
                    
                    for c in range {
                        var v = -mu[c]
                        vDSP_vsaddD(ptr1, vDSP_Stride(columns), &v, ptr2, vDSP_Stride(columns), vDSP_Length(rows))
                        vDSP_vsqD(ptr2, vDSP_Stride(columns), ptr2, vDSP_Stride(columns), vDSP_Length(rows))
                        vDSP_sveD(ptr2, vDSP_Stride(columns), ptr3, vDSP_Length(rows))
                        
                        ptr1 += 1
                        ptr2 += 1
                        ptr3 += 1
                    }
                }
            }
        }
        
        // Note: we cannot access sigma[] inside the withUnsafeMutableBufferPointer
        // block, so we do it afterwards.
        sigma = sigma / (Double(rows) - 1)   // sample stddev, not population
        sigma = sigma.sqrt()
        
        return sigma
    }
    
    /**
     Calculates the standard deviation for some of the matrix's columns.
     
     Note: This returns a matrix of the same size as the original one.
     Any columns not in the range are set to 0.
     */
    public func std(_ range: CountableClosedRange<Int>) -> Matrix{
        return std(CountableRange(range))
    }
    
    
    fileprivate enum MatrixSystemError: Error {
        case SolveError
    }
    
    /// Solve any system of equations.
    ///
    /// Equations involving matrices and vectors of real numbers can often be solved by using methods from linear algebra. A finite set of linear equations in a finite set of variables, for example `$x_1, x_2,..., x_n$` or `$x, y, ..., z$`, is called a system of linear equations or a linear system. Systems of linear equations form a fundamental part of linear algebra. Historically, linear algebra and matrix theory has been developed for solving such systems. In the modern presentation of linear algebra through vector spaces and matrices, many problems may be interpreted in terms of linear systems.
    ///
    /// For example, let
    /// ```
    /// $$
    ///  2x + y -  z =  8
    /// -3x - y + 2z = -11
    /// -2x + y + 2z = -3
    /// $$
    /// ```
    /// be a linear system.
    /// To such a system, one may associate its matrix
    /// ```
    ///   ⎛  2         1        -1 ⎞
    /// M ⎜ -3        -1         2 ⎥
    ///   ⎝ -2         1         2 ⎠
    /// ```
    /// and its right member vector
    /// ```
    ///   ⎛  8  ⎞
    /// v ⎜ -11 ⎥
    ///   ⎝ -3  ⎠
    /// ```
    /// Let T be the linear transformation associated to the matrix M. A solution of the system (S) is a vector
    /// ```
    ///   ⎛ x ⎞
    /// X ⎜ y ⎥
    ///   ⎝ z ⎠
    /// ```
    /// such that `$T(X)=v$`
    ///
    /// that is an element of the preimage of v by T.
    /// Let (S') be the associated homogeneous system, where the right-hand sides of the equations are put to zero:
    /// ```
    /// $$
    ///  2x + y -  z = 0
    /// -3x - y + 2z = 0
    /// -2x + y + 2z = 0
    /// $$
    /// ```
    /// The solutions of (S') are exactly the elements of the kernel of T or, equivalently, M.
    /// The Gaussian-elimination consists of performing elementary row operations on the augmented matrix
    /// ```
    ///   ⎛  2         1        -1  |  8  ⎞
    /// M ⎜ -3        -1         2  | -11 ⎥
    ///   ⎝ -2         1         2  | -3  ⎠
    /// ```
    /// for putting it in reduced row echelon form. These row operations do not change the set of solutions of the system of equations. In the example, the reduced echelon form is
    /// ```
    ///   ⎛  1        0        0  |  2 ⎞
    /// M ⎜ 0         1        0  |  3 ⎥
    ///   ⎝ 0         0        1  | -1 ⎠
    /// ```
    /// showing that the system (S) has the unique solution
    /// ```
    /// $$
    ///  x =  2
    ///  y =  3
    ///  z = -1
    /// $$
    /// ```
    /// It follows from this matrix interpretation of linear systems that the same methods can be applied for solving linear systems and for many operations on matrices and linear transformations, which include the computation of the ranks, kernels, matrix inverses.
    ///
    /// So, you can reproduce the exact same process with:
    /// ```swift
    /// let m = Matrix([[2,1-1],[-3,-1,2],[-2,1,2]] as [[Double]]) // Creating the Matrix
    /// let s = m.solveEquationsSystem(vector: [8, -11, -3]) // Solving the system
    /// ```
    ///
    /// - Parameter vector: The result vector
    public func solveEquationsSystem(vector: [Double]) throws -> Matrix {
        let flatMatrix = self.grid
        let matrix = self.array
        let laMatrix:la_object_t =
            la_matrix_from_double_buffer(flatMatrix,  la_count_t(matrix.count),  la_count_t(matrix[0].count),  la_count_t(matrix[0].count), la_hint_t(LA_NO_HINT), la_attribute_t(LA_DEFAULT_ATTRIBUTES))
        let laVector = la_matrix_from_double_buffer(vector, la_count_t(vector.count), 1, 1, la_hint_t(LA_NO_HINT), la_attribute_t(LA_DEFAULT_ATTRIBUTES))
        let vecCj = la_solve(laMatrix, laVector)
        var result: [Double] = Array(repeating: 0.0, count: matrix.count)
        let status = la_matrix_to_double_buffer(&result, 1, vecCj)

        if status == la_status_t(LA_SUCCESS) {
           return Matrix(result)
        } else {
            throw MatrixSystemError.SolveError
        }
    }
    
    /// Gaussian Elimination used in `Statistics`
    ///
    /// Gaussian elimination, also known as row reduction, is an algorithm in linear algebra for solving a system of linear equations. It is usually understood as a sequence of operations performed on the corresponding matrix of coefficients. This method can also be used to find the rank of a matrix, to calculate the determinant of a matrix, and to calculate the inverse of an invertible square matrix. The method is named after Carl Friedrich Gauss.
    /// - Parameter order: The degree to which we solve the system
    internal func gaussElimination(vector: [Double]) throws -> Matrix {
        let flatMatrix = self.grid
        let matrix = self.array
        let laMatrix:la_object_t =
            la_matrix_from_double_buffer(flatMatrix,  la_count_t(matrix.count),  la_count_t(matrix[0].count),  la_count_t(matrix[0].count), la_hint_t(LA_NO_HINT), la_attribute_t(LA_DEFAULT_ATTRIBUTES))
        let laVector = la_matrix_from_double_buffer(vector, la_count_t(vector.count), 1, 1, la_hint_t(LA_NO_HINT), la_attribute_t(LA_DEFAULT_ATTRIBUTES))
        let vecCj = la_solve(laMatrix, laVector)
        var result: [Double] = Array(repeating: 0.0, count: matrix.count)
        let status = la_matrix_to_double_buffer(&result, 1, vecCj)

        if status == la_status_t(LA_SUCCESS) {
           return Matrix(result)
        } else {
            throw MatrixSystemError.SolveError
        }
    }
}

#endif
