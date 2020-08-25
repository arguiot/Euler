//
//  TablesTest.swift
//  EulerTests
//
//  Created by Arthur Guiot on 2020-05-30.
//

import XCTest
import Euler
class TablesTests: XCTestCase {
    func testCommon() {
        let t = Tables()
        do {
            XCTAssertEqual(t.ABS(-2), 2)
            XCTAssertEqual(try t.COMBIN(5, k: 3), 40)
            XCTAssertEqual(t.DECIMAL("ff", 16), 255)
            XCTAssert(t.DEGREES(pi / 2).nearlyEquals(90))
            XCTAssertEqual(try t.FACTDOUBLE(6).scientificDescription, "2.6012×10¹⁷⁴⁶")
        } catch {
            print(error.localizedDescription)
            XCTFail()
        }
    }
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
        ("Common", testCommon),
        ("Date", testDate),
        ("Engineering", testEngineering)
    ]
}
