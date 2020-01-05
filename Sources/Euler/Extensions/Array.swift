//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-01-04.
//

import Foundation

public extension Array {
    /// Flattens the current Array of any type
    ///
    /// This method will help you convert an array like `[ [1, 2], [3, 4], 5 ]` to `[1, 2, 3, 4, 5]`
    /// Here is how you use it:
    /// ```swift
    /// let array = [
    ///     [1, 2],
    ///     [3, 4], 5
    /// ]
    ///
    /// array.flatten() // => [1, 2, 3, 4, 5]
    /// ```
    ///
    /// - Parameter index: The starting index of the array
    func flatten<T>(_ index: Int = 0) -> [T] {
         guard index < self.count else { 
             return []
         }

         var flatten: [T] = []

         if let itemArr = self[index] as? [T] {
             flatten += itemArr.flatten()
         } else if let element = self[index] as? T {
             flatten.append(element)
         }
         return flatten + self.flatten(index + 1)
    }
    
    /// This will create a range of number starting from the number `a`, going to the number `b` with `x` numbers in it.
    ///
    /// If you don't have any idea of how it works, the example may help you:
    /// ```swift
    /// Array.linspace(start: 0, end: 100, n: 10) // => [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    /// ```
    /// - Parameters:
    ///   - start: The start of the array
    ///   - end: The end of your array
    ///   - n: The length of the outputed array
    static func linspace(start: Double, end: Double, n: Int) -> [Double] {
        let diff = end - start
        let step = diff / Double(n)
        return self.arange(start: start, end: end, step: step)
    }
    
    /// Similar as `Array.range`, but with more options (start, end, step)
    ///
    /// Example:
    /// ```swift
    /// Array.arange(start: 1, end: 11, step: 2, offset: 0) // => [ 1, 3, 5, 7, 9, 11 ]
    /// ```
    /// - Parameters:
    ///   - start: The start of the array
    ///   - end: The end of the array
    ///   - step: The step the function will use to generate the array
    ///   - offset: The offset you want to use to generate your array
    static func arange(start: Double, end: Double, step: Double = 1, offset: Double = 0) -> [Double] {
        let len = (abs(end - start) + (offset * 2)) / step + 1
        let direction: Double = start < end ? 1 : -1
        let startingPoint = start - (direction * offset)
        let stepSize = direction * step
        
        let count = round(len)
        let arr = Array<Double>(repeating: 0, count: Int(count))
        var index: Double = 0
        return arr.map { (el) -> Double in
            let computed = startingPoint + (stepSize * index)
            index += 1
            return computed
        }
    }
    
    /// This will create a range of number, starting from `0` up to a number `n`
    ///
    /// Example:
    /// ```swift
    /// Array.range(n: 10) // => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    /// ```
    /// - Parameter n: The number `n` represent the end of the range
    static func range(n: Int) -> [Int] {
        return self.arange(start: 0, end: Double(n)).map { Int($0) }
    }
}
