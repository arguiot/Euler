//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-02-11.
//

import Foundation

/// Invokes the given closure with pointers to the given arguments (2 parameter version).
///
/// - See: `withUnsafePointer(to:body:)`
@discardableResult
internal func withUnsafePointers<A, B, Result>(_ a: inout A, _ b: inout B, body: (UnsafePointer<A>, UnsafePointer<B>) throws -> Result) rethrows -> Result {
    return try withUnsafePointer(to: &a) { (a: UnsafePointer<A>) throws -> Result in
        try withUnsafePointer(to: &b) { (b: UnsafePointer<B>) throws -> Result in
            try body(a, b)
        }
    }
}

/// Invokes the given closure with mutable pointers to the given arguments (2 parameter version).
///
/// - See: `withUnsafeMutablePointer(to:body:)`
@discardableResult
internal func withUnsafeMutablePointers<A, B, Result>(_ a: inout A, _ b: inout B, body: (UnsafeMutablePointer<A>, UnsafeMutablePointer<B>) throws -> Result) rethrows -> Result {
    return try withUnsafeMutablePointer(to: &a) { (a: UnsafeMutablePointer<A>) throws -> Result in
        try withUnsafeMutablePointer(to: &b) { (b: UnsafeMutablePointer<B>) throws -> Result in
            try body(a, b)
        }
    }
}

// MARK: - 3 Parameter
/// Invokes the given closure with pointers to the given arguments (3 parameter version).
///
/// - See: `withUnsafePointer(to:body:)`
@discardableResult
internal func withUnsafePointers<A, B, C, Result>(_ a: inout A, _ b: inout B, _ c: inout C, body: (UnsafePointer<A>, UnsafePointer<B>, UnsafePointer<C>) throws -> Result) rethrows -> Result {
    return try withUnsafePointer(to: &a) { (a: UnsafePointer<A>) throws -> Result in
        try withUnsafePointer(to: &b) { (b: UnsafePointer<B>) throws -> Result in
            try withUnsafePointer(to: &c) { (c: UnsafePointer<C>) throws -> Result in
                try body(a, b, c)
            }
        }
    }
}

/// Invokes the given closure with mutable pointers to the given arguments (3 parameter version).
///
/// - See: `withUnsafeMutablePointer(to:body:)`
@discardableResult
internal func withUnsafeMutablePointers<A, B, C, Result>(_ a: inout A, _ b: inout B, _ c: inout C, body: (UnsafeMutablePointer<A>, UnsafeMutablePointer<B>, UnsafeMutablePointer<C>) throws -> Result) rethrows -> Result {
    return try withUnsafeMutablePointer(to: &a) { (a: UnsafeMutablePointer<A>) throws -> Result in
        try withUnsafeMutablePointer(to: &b) { (b: UnsafeMutablePointer<B>) throws -> Result in
            try withUnsafeMutablePointer(to: &c) { (c: UnsafeMutablePointer<C>) throws -> Result in
                try body(a, b, c)
            }
        }
    }
}
