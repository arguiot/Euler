//
//  TablesTest.swift
//  EulerTests
//
//  Created by Arthur Guiot on 2020-05-30.
//

import XCTest
import Euler
class TablesTest: XCTestCase {

    func testEngineering() {
        let t = Tables()
        do {
            XCTAssertEqual(try t.CONVERT(28, from_unit: "sec", to_unit: "h"), 7/900)
        } catch {
            print(error.localizedDescription)
            XCTFail()
        }
    }

}
