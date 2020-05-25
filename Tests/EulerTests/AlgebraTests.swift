//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-05-11.
//

import Foundation
import XCTest
@testable import Euler

class AlgebraTests: XCTestCase {
    func testPolynomial() {
        // Sum
        let p1 = try! Polynomial(1, 2, 3)
        let p2 = try! Polynomial(2, 4)
        
        var supposed = try! Polynomial(1, 4, 7)
        XCTAssert(p1 + p2 == supposed)
        
        // Derivative
        supposed = try! Polynomial(2, 2)
        XCTAssert(p1.derivative == supposed)
        
        // Roots
        let golden = try! Polynomial(1, -1, -1)
        XCTAssertEqual(golden.roots.last, 102334155/63245986) // Golden Ratio, simplified
        
        let higher = try! Polynomial(1, 2, -25, -26, 120)
        let roots = higher.roots
        print(roots.map { $0.asDouble()! })
        XCTAssertEqual(roots.count, 4)
    }
    
    static var allTests = [
        ("Polynomial", testPolynomial)
    ]
}
