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
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(BigNumber(123456789).c, [123456789])
    }
    
    static var allTests = [
        ("Big Number", testExample),
    ]
}
