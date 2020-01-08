//
//  ExtensionsTests.swift
//  
//
//  Created by Arthur Guiot on 2020-01-05.
//

import Foundation

import XCTest
import Euler

class ExtensionsTests: XCTestCase {
    // MARK: Array
    func testFlatten() {
        let array = [
            [1, 2],
            [3, 4],
            5
        ] as [Any?]
        let flatten = array.flatten() as? [Int]
        XCTAssertEqual(flatten, [1, 2, 3, 4, 5])
    }
    
    func testLinspace() {
        XCTAssertEqual(Array<Any>.linspace(start: 0, end: 100, n: 10), [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100])
    }
    
    func testRange() {
        XCTAssertEqual(Array<Any>.arange(start: 1, end: 11, step: 2, offset: 0), [ 1, 3, 5, 7, 9, 11 ])
        
        XCTAssertEqual(Array<Any>.range(10), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    }
    func testReshape() {
        let reshaped = Array<Any>.range(10).reshape(part: 2)
        XCTAssertEqual(reshaped, [
            [0, 1],
            [2, 3],
            [4, 5],
            [6, 7],
            [8, 9],
            [10]
        ])
    }
    static var allTests = [
        ("Array - Flatten", testFlatten),
        ("Array - Linspace", testLinspace),
        ("Array - Range", testRange),
        ("Array - Reshape", testReshape)
    ]
}
