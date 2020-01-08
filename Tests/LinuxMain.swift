import XCTest
@testable import BigIntTests
@testable import BigDoubleTests
@testable import ExtensionsTests
@testable import NodeTests
@testable import CryptogrpahyTests
XCTMain([
    testCase(BigIntTests.allTests),
    testCase(BigDoubleTests.allTests),
])
