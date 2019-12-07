//
//  EulerTests.swift
//  Euler
//
//  Created by Arthur Guiot on 2019-12-04.
//  Copyright © 2019 Euler. All rights reserved.
//

import Foundation
import XCTest
@testable import Euler

class EulerTests: XCTestCase {
    func testBigNum() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        /// BigNumber constructor
        XCTAssertEqual(BigNumber(123456789).limbs, [123456789])

        /// Comparable
        XCTAssertEqual(BigNumber(123456789) < BigNumber(1e14), true)
        XCTAssertEqual(BigNumber(123456789) < BigNumber(123456789.1), false)
        XCTAssertEqual(BigNumber(123456789) == BigNumber(123456789.000), true)
        XCTAssertEqual(BigDouble(3.14) != BigDouble(3.15), true)
        
        /// # API
        
        /// abs()
        XCTAssertEqual(BigNumber(-123456789) == BigNumber(123456789), false)
        
    }
    
    static var allTests = [
        ("Big Number", testBigNum),
    ]
}
