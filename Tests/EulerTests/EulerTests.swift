//
//  EulerTests.swift
//  Euler
//
//  Created by Arthur Guiot on 2019-12-04.
//  Copyright © 2019 Euler. All rights reserved.
//

import Foundation
import XCTest
import Euler

class EulerTests: XCTestCase {
    func testBigNum() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        /// BigNumber constructor
        XCTAssertEqual(BigNumber(123456789).c, [123456789])

        /// Comparable
        XCTAssertEqual(BigNumber(123456789) < BigNumber(1e14), false)
        XCTAssertEqual(BigNumber(123456789) < BigNumber(123456789.1), false)
        XCTAssertEqual(BigNumber(123456789) == BigNumber(123456789.000), true)
        
        /// # API
        
        /// abs()
        XCTAssertEqual(BigNumber(-123456789) == BigNumber(123456789), false)
        
    }
    
    static var allTests = [
        ("Big Number", testBigNum),
    ]
}
