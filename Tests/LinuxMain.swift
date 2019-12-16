import XCTest
@testable import BigIntTests
@testable import BigDoubleTests

XCTMain([
    testCase(BigIntTests.allTests),
    testCase(BigDoubleTests.allTests),
])
