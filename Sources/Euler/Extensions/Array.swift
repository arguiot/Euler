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
    /// This method will help you convert an array like [ [1, 2], [3, 4], 5 ] to [1, 2, 3, 4, 5]
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
}
