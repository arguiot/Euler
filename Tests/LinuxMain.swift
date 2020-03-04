import XCTest
@testable import EulerTests
XCTMain([
    testCase(BigIntTests.allTests),
    testCase(BigDoubleTests.allTests),
    testCase(CryptogrpahyTests.allTests),
    testCase(ExtensionsTests.allTests),
    testCase(NodeTests.allTests),
    testCase(GeneratorsTests.allTests)
])
