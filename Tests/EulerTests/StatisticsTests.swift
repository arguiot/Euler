//
//  StatisticsTests.swift
//  EulerTests
//
//  Created by Arthur Guiot on 08/09/2022.
//

import XCTest
import Euler
class StatisticsTests: XCTestCase {
    func testQuantile() {
        let array: [BN] = [32.2, 32.0, 30.4, 31.0, 31.2, 31.2, 30.3, 29.6, 30.5, 30.7]
        
        let stats = Statistics(list: array)
        
        XCTAssertEqual(stats.median, BN(617, over: 20))
        XCTAssertEqual(try stats.quantile(percentage: 0.5), 30.7)
        XCTAssertEqual(try stats.quantile(percentage: 0.25), 30.4)
        XCTAssertEqual(try stats.quantile(percentage: 0.75), 31.2)
    }
    
    static var allTests = [
        ("Quantile", testQuantile),
    ]
}
