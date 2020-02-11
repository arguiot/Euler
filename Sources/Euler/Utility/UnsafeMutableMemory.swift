//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-02-11.
//

import Foundation

/// Mutable memory region.
internal struct UnsafeMutableMemory<Element> {
    /// Pointer to the first element
    internal var pointer: UnsafeMutablePointer<Element>

    /// Pointer stride between elements
    internal var stride: Int

    /// Number of elements
    internal var count: Int

    internal init(pointer: UnsafeMutablePointer<Element>, stride: Int = 1, count: Int) {
        self.pointer = pointer
        self.stride = stride
        self.count = count
    }

    internal func makeIterator() -> UnsafeMutableMemoryIterator<Element> {
        return UnsafeMutableMemoryIterator(self)
    }
}

internal struct UnsafeMutableMemoryIterator<Element>: IteratorProtocol {
    let base: UnsafeMutableMemory<Element>
    var index: Int?

    internal init(_ base: UnsafeMutableMemory<Element>) {
        self.base = base
    }

    internal mutating func next() -> Element? {
        let newIndex: Int
        if let index = index {
            newIndex = index + 1
        } else {
            newIndex = 0
        }

        if newIndex >= base.count {
            return nil
        }

        self.index = newIndex
        return base.pointer[newIndex * base.stride]
    }
}

/// Protocol for mutable collections that can be accessed via `UnsafeMutableMemory`
internal protocol UnsafeMutableMemoryAccessible: UnsafeMemoryAccessible {
    mutating func withUnsafeMutableMemory<Result>(_ body: (UnsafeMutableMemory<Element>) throws -> Result) rethrows -> Result
}

internal func withUnsafeMutableMemory<L, Result>(_ lhs: inout L, _ body: (UnsafeMutableMemory<L.Element>) throws -> Result) rethrows -> Result where L: UnsafeMutableMemoryAccessible {
    return try lhs.withUnsafeMutableMemory(body)
}

internal func withUnsafeMutableMemory<L, R, Result>(_ lhs: inout L, _ rhs: inout R, _ body: (UnsafeMutableMemory<L.Element>, UnsafeMutableMemory<R.Element>) throws -> Result) rethrows -> Result where L: UnsafeMutableMemoryAccessible, R: UnsafeMutableMemoryAccessible {
    return try lhs.withUnsafeMutableMemory { lhsMemory in
        try rhs.withUnsafeMutableMemory { rhsMemory in
            try body(lhsMemory, rhsMemory)
        }
    }
}

internal func withUnsafeMutableMemory<L, R, Z, Result>(_ lhs: inout L, _ rhs: inout R, _ z: inout Z, _ body: (UnsafeMutableMemory<L.Element>, UnsafeMutableMemory<R.Element>, UnsafeMutableMemory<Z.Element>) throws -> Result) rethrows -> Result where L: UnsafeMutableMemoryAccessible, R: UnsafeMutableMemoryAccessible, Z: UnsafeMutableMemoryAccessible {
    return try lhs.withUnsafeMutableMemory { lhsMemory in
        try rhs.withUnsafeMutableMemory { rhsMemory in
            try z.withUnsafeMutableMemory { zm in
                try body(lhsMemory, rhsMemory, zm)
            }
        }
    }
}
