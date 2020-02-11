//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-02-11.
//

import Foundation

/// Memory region.
internal struct UnsafeMemory<Element>: Sequence {
    /// Pointer to the first element
    internal var pointer: UnsafePointer<Element>

    /// Pointer stride between elements
    internal var stride: Int

    /// Number of elements
    internal var count: Int

    internal init(pointer: UnsafePointer<Element>, stride: Int = 1, count: Int) {
        self.pointer = pointer
        self.stride = stride
        self.count = count
    }

    internal func makeIterator() -> UnsafeMemoryIterator<Element> {
        return UnsafeMemoryIterator(self)
    }
}

internal struct UnsafeMemoryIterator<Element>: IteratorProtocol {
    let base: UnsafeMemory<Element>
    var index: Int?

    internal init(_ base: UnsafeMemory<Element>) {
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

/// Protocol for collections that can be accessed via `UnsafeMemory`
internal protocol UnsafeMemoryAccessible: Collection {
    func withUnsafeMemory<Result>(_ body: (UnsafeMemory<Element>) throws -> Result) rethrows -> Result
}

internal func withUnsafeMemory<L, Result>(_ lhs: L, _ body: (UnsafeMemory<L.Element>) throws -> Result) rethrows -> Result where L: UnsafeMemoryAccessible {
    return try lhs.withUnsafeMemory(body)
}

internal func withUnsafeMemory<L, R, Result>(_ lhs: L, _ rhs: R, _ body: (UnsafeMemory<L.Element>, UnsafeMemory<R.Element>) throws -> Result) rethrows -> Result where L: UnsafeMemoryAccessible, R: UnsafeMemoryAccessible {
    return try lhs.withUnsafeMemory { lhsMemory in
        try rhs.withUnsafeMemory { rhsMemory in
            try body(lhsMemory, rhsMemory)
        }
    }
}


extension Array: UnsafeMemoryAccessible, UnsafeMutableMemoryAccessible {
    internal func withUnsafeMemory<Result>(_ action: (UnsafeMemory<Element>) throws -> Result) rethrows -> Result {
        return try withUnsafeBufferPointer { ptr in
            guard let base = ptr.baseAddress else {
                fatalError("Array is missing its pointer")
            }
            let memory = UnsafeMemory(pointer: base, stride: 1, count: ptr.count)
            return try action(memory)
        }
    }

    internal mutating func withUnsafeMutableMemory<Result>(_ action: (UnsafeMutableMemory<Element>) throws -> Result) rethrows -> Result {
        return try withUnsafeMutableBufferPointer { ptr in
            guard let base = ptr.baseAddress else {
                fatalError("Array is missing its pointer")
            }
            let memory = UnsafeMutableMemory(pointer: base, stride: 1, count: ptr.count)
            return try action(memory)
        }
    }
}
