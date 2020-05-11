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
    }
    
    static var allTests = [
        ("Polynomial", testPolynomial)
    ]
}
