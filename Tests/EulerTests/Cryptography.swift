//
//  Cryptogrpahy.swift
//  
//
//  Created by Arthur Guiot on 2020-01-08.
//

import Foundation

import XCTest
import Euler

class CryptographyTests: XCTestCase {
    func testSha256() {
        XCTAssertEqual("Euler".sha256, "586ca27cfbb81dde884d5f0bbb195ff4b2ff3b2f4304530e5e24194f3a391eda")
    }
    func testMd5() {
        XCTAssertEqual("Euler".md5, "0a7532036415f2491bf5f952220827b8")
    }
    static var allTests = [
        ("SHA256", testSha256),
        ("MD5", testMd5)
    ]
}
