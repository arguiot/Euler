//
//  TablesTest.swift
//  EulerTests
//
//  Created by Arthur Guiot on 2020-05-30.
//

import XCTest
import Euler
class TablesTests: XCTestCase {
    func testDate() {
        let t = Tables()
        do {
            XCTAssertEqual(try t.DATEVALUE("1/30/2008"), 39477)
        } catch {
            print(error.localizedDescription)
            XCTFail()
        }
    }


    func testEngineering() {
        let t = Tables()
        do {
            XCTAssertEqual(try t.CONVERT(28, from_unit: "km/h", to_unit: "m/s"), 70/9)
        } catch {
            print(error.localizedDescription)
            XCTFail()
        }
    }

    static var allTests = [
        ("Engineering", testEngineering)
    ]
}
