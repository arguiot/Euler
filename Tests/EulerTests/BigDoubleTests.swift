//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2019-12-16.
//

import Foundation
import XCTest
@testable import Euler

class BigDoubleTests : XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertNil(BigDouble("alphabet"))
        XCTAssertNil(BigDouble("-0.123ad2e+123"))
        XCTAssertNil(BigDouble("0.123.ad2e123"))
        XCTAssertNil(BigDouble("0.123ae123"))
        XCTAssertNil(BigDouble("0.123ae1.23"))
        XCTAssertNotNil(BigDouble("1.2e+123"))
        XCTAssertNotNil(BigDouble("-1.2e+123"))
        XCTAssertNotNil(BigDouble("+1.2e-123"))
        XCTAssertEqual(BigDouble("0"), 0.0)
        XCTAssertEqual(BigDouble("10"), 10.0)
        XCTAssertEqual(BigDouble("1.2e10")?.fractionDescription, "12000000000")
        XCTAssertEqual(BigDouble("1.2e+10")?.fractionDescription, "12000000000")
        XCTAssertEqual(BigDouble("+1.2e+10")?.fractionDescription, "12000000000")
        XCTAssertEqual(BigDouble("-1.2e10")?.fractionDescription, "-12000000000")
        XCTAssertEqual(BigDouble(123000000000000000000.0), 123000000000000000000.0)
        XCTAssertEqual(BigDouble("1.2")?.fractionDescription, "6/5")
        
        for _ in 0..<100 {
            let rn = Double(Double(arc4random()) / Double(UINT32_MAX))
            XCTAssertNotNil(BigDouble(rn))
            
            let rn2 = pow(rn * 100, 2.0)
            XCTAssertNotNil(BigDouble(rn2))
        }
    }
    
    func testCompare() {
        XCTAssertEqual(BigDouble(1.0), BigDouble(1.0))
        XCTAssert(BigDouble(1.1) != BigDouble(1.0))
        XCTAssert(BigDouble(2.0) > BigDouble(1.0))
        XCTAssert(BigDouble(-1) < BigDouble(1.0))
        XCTAssert(BigDouble(0.0) <= BigDouble(1.0))
        XCTAssert(BigDouble(1.1) >= BigDouble(1.0))
        
        XCTAssertEqual(1.0, BigDouble(1.0))
        XCTAssert(1.1 != BigDouble(1.0))
        XCTAssert(2.0 > BigDouble(1.0))
        XCTAssert(0.0 < BigDouble(1.0))
        XCTAssert(-1.0 <= BigDouble(1.0))
        XCTAssert(1.1 >= BigDouble(1.0))
        
        XCTAssertEqual(BigDouble(1.0), 1.0)
        XCTAssert(BigDouble(1.1) != 1.0)
        XCTAssert(BigDouble(2.0) > 1.0)
        XCTAssert(BigDouble(-1) < 1.0)
        XCTAssert(BigDouble(0.0) <= 1.0)
        XCTAssert(BigDouble(1.1) >= 1.0)
        
        for _ in 1..<100 {
            let rn = Double(Double(arc4random()) / Double(UINT32_MAX))
            let rn2 = pow(rn * 100, 2.0)
            
            XCTAssert(BigDouble(rn) < BigDouble(rn2))
            XCTAssert(BigDouble(rn) <= BigDouble(rn2))
            XCTAssert(BigDouble(rn2) > BigDouble(rn))
            XCTAssert(BigDouble(rn2) >= BigDouble(rn))
            XCTAssertEqual(BigDouble(rn), BigDouble(rn))
            XCTAssert(BigDouble(rn2) != BigDouble(rn))
        }
    }
    
    func testPow() {
        XCTAssertEqual((BigDouble("27")!**3), BigDouble("19683")!)
        XCTAssertEqual(pow(BigDouble("27")!,BigInt("3")!), BigDouble("19683")!)

        XCTAssertEqual((BigDouble("27")!**BigInt("3")!), BigDouble("19683")!)
        XCTAssertEqual(pow(BigDouble("27")!,BigInt("3")!), BigDouble("19683")!)
        
        XCTAssertTrue(BigDouble.nearlyEqual(BigDouble("-27")!**BigDouble("1", over: "3")!, BigDouble("-3")!))
        
        XCTAssertTrue(BigDouble.nearlyEqual(BigDouble("4")!.nthroot(2), BigDouble(2.0)))
        // Test that a number to the zero power is 1
        for i in 0..<100 {
            XCTAssertEqual(pow(BigDouble(Double(i)), 0), 1.0)
            
            let rn = Double(Double(arc4random()) / Double(UINT32_MAX))
            XCTAssert(pow(BigDouble(rn), 0) == 1.0)
        }
        
        // Test that a number to the one power is itself
        for i in 0..<100 {
            XCTAssertEqual(pow(BigDouble(Double(i)), 1), BigDouble(Double(i)))
            
            let rn = Double(Double(arc4random()) / Double(UINT32_MAX))
            XCTAssertEqual(pow(BigDouble(rn), 1), BigDouble(rn))
        }
    }
    
    func testDecimalExpansionWithoutRounding() {
        let testValues = [
            ("0", "0.0", 0),
            ("0", "0.0", 1),
            ("0", "0.00", 2),
            ("0", "0.000", 3),
            ("12.345", "12.0", 0),
            ("12.345", "12.3", 1),
            ("12.345", "12.34", 2),
            ("12.345", "12.345", 3),
            ("12.345", "12.3450", 4),
            ("-0.00009", "0.0000", 4),
            ("-0.00009", "-0.00009", 5),
            ("-0.00009", "-0.000090", 6),
            ]
        
        for (original, test, precision) in testValues {
            let result = BigDouble(original)!.decimalExpansion(precisionAfterDecimalPoint: precision, rounded: false)
            XCTAssertEqual(result, test)
        }
    }
    
    func testDecimalExpansionWithRounding() {
        let testValues = [
            ("0", "0.0", 0),
            ("0", "0.0", 1),
            ("0", "0.00", 2),
            ("0", "0.000", 3),
            ("12.345", "12.0", 0),
            ("12.345", "12.3", 1),
            ("12.345", "12.35", 2),
            ("12.345", "12.345", 3),
            ("12.345", "12.3450", 4),
            ("-0.00009", "0.000", 3),
            ("-0.00009", "-0.0001", 4),
            ("-0.00009", "-0.00009", 5),
            ("-0.00009", "-0.000090", 6),
            ]
        
        for (original, test, precision) in testValues {
            let result = BigDouble(original)!.decimalExpansion(precisionAfterDecimalPoint: precision, rounded: true)
            XCTAssertEqual(result, test)
        }
    }
    
    func test_decimalExpansionRandom() {
        func generateDoubleString(preDecimalCount: Int, postDecimalCount: Int) -> String {
            var numStr = ""
            
            if preDecimalCount == 0 && postDecimalCount == 0 {
                return math.random(0...1) == 1 ? "0" : "0.0"
            }
            
            if preDecimalCount == 0 {
                numStr = "0."
            }
            
            if postDecimalCount == 0 {
                numStr = math.random(0...1) == 1 ? "" : ".0"
            }
            
            
            for i in 0..<preDecimalCount {
                if i == (preDecimalCount - 1) && preDecimalCount > 1 {
                    numStr = math.random(1...9).description + numStr
                } else {
                    numStr = math.random(0...9).description + numStr
                }
            }
            
            if postDecimalCount != 0 && preDecimalCount != 0 {
                numStr += "."
            }
            
            for _ in 0..<postDecimalCount {
                numStr = numStr + math.random(0...9).description
            }
            
            return math.random(0...1) == 1 ? numStr : "-" + numStr
        }
        
        for _ in 0..<2000 {
            let preDecimalCount = math.random(0...4)
            let postDecimalCount = math.random(0...4)
            let doubleString = generateDoubleString(
                preDecimalCount: preDecimalCount,
                postDecimalCount: postDecimalCount
            )
            
            let toBigDoubleAndBack = BigDouble(doubleString)!.decimalExpansion(precisionAfterDecimalPoint: postDecimalCount)
            
            if toBigDoubleAndBack != doubleString {
                if toBigDoubleAndBack == "0.0" && ["0", "-0"].contains(doubleString) { continue }
                // For expmple, input: "13" and output "13.0" is okay
                
                if toBigDoubleAndBack[0..<(toBigDoubleAndBack.count - 2)] == doubleString && toBigDoubleAndBack.hasSuffix(".0") { continue }
                // For expmple, input: "13" and output "13.0" is okay
                if doubleString[1..<doubleString.count] == toBigDoubleAndBack && doubleString.hasPrefix("-0.") { continue }
                
                print("\nError: PreDecCount: \(preDecimalCount) PostDecCount: \(postDecimalCount)")
                print("Previ: \(doubleString)")
                print("After: \(toBigDoubleAndBack)")
                XCTAssert(false)
            }
        }
    }
    
    func testRounding() {
        XCTAssertEqual(BigDouble("-1.0")?.rounded(), BigInt("-1"))
        XCTAssertEqual(BigDouble("-1.1")?.rounded(), BigInt("-1"))
        XCTAssertEqual(BigDouble("-1.5")?.rounded(), BigInt("-1"))
        XCTAssertEqual(BigDouble("-1.6")?.rounded(), BigInt("-2"))
        XCTAssertEqual(BigDouble("0")?.rounded(), BigInt("0"))
        XCTAssertEqual(BigDouble("1.0")?.rounded(), BigInt("1"))
        XCTAssertEqual(BigDouble("1.1")?.rounded(), BigInt("1"))
        XCTAssertEqual(BigDouble("1.5")?.rounded(), BigInt("1"))
        XCTAssertEqual(BigDouble("1.6")?.rounded(), BigInt("2"))
        
        XCTAssertEqual(floor(BigDouble(-1.0)), BigInt("-1"))
        XCTAssertEqual(floor(BigDouble(-1.1)), BigInt("-2"))
        XCTAssertEqual(floor(BigDouble(-1.5)), BigInt("-2"))
        XCTAssertEqual(floor(BigDouble(-1.6)), BigInt("-2"))
        XCTAssertEqual(floor(BigDouble(0)), BigInt("0"))
        XCTAssertEqual(floor(BigDouble(1.0)), BigInt("1"))
        XCTAssertEqual(floor(BigDouble(1.1)), BigInt("1"))
        XCTAssertEqual(floor(BigDouble(1.5)), BigInt("1"))
        XCTAssertEqual(floor(BigDouble(1.6)), BigInt("1"))
        
        XCTAssertEqual(ceil(BigDouble(-1.0)), BigInt("-1"))
        XCTAssertEqual(ceil(BigDouble(-1.1)), BigInt("-1"))
        XCTAssertEqual(ceil(BigDouble(-1.5)), BigInt("-1"))
        XCTAssertEqual(ceil(BigDouble(-1.6)), BigInt("-1"))
        XCTAssertEqual(ceil(BigDouble(0)), BigInt("0"))
        XCTAssertEqual(ceil(BigDouble(1.0)), BigInt("1"))
        XCTAssertEqual(ceil(BigDouble(1.1)), BigInt("2"))
        XCTAssertEqual(ceil(BigDouble(1.5)), BigInt("2"))
        XCTAssertEqual(ceil(BigDouble(1.6)), BigInt("2"))
        XCTAssertEqual(ceil(BigDouble(constant: .pi)), BigInt("4"))
        XCTAssertEqual(ceil(e), BigInt(3))
    }
    
    func testPrecision() {
        var bigD = BigDouble("123456789.123456789")
        bigD?.precision = 2
        XCTAssertEqual(bigD?.decimalDescription, "123456789.12")
        bigD?.precision = 4
        XCTAssertEqual(bigD?.decimalDescription, "123456789.1235")
        bigD?.precision = 10
        XCTAssertEqual(bigD?.decimalDescription, "123456789.1234567890")
        bigD?.precision = 20
        XCTAssertEqual(bigD?.decimalDescription, "123456789.12345678900000000000")
        bigD?.precision = 0
        XCTAssertEqual(bigD?.decimalDescription, "123456789.0")
        
        
        bigD = BigDouble("-123456789.123456789")
        bigD?.precision = 2
        XCTAssertEqual(bigD?.decimalDescription, "-123456789.12")
        bigD?.precision = 4
        XCTAssertEqual(bigD?.decimalDescription, "-123456789.1235")
        bigD?.precision = 10
        XCTAssertEqual(bigD?.decimalDescription, "-123456789.1234567890")
        bigD?.precision = 20
        XCTAssertEqual(bigD?.decimalDescription, "-123456789.12345678900000000000")
        bigD?.precision = 0
        XCTAssertEqual(bigD?.decimalDescription, "-123456789.0")
        
        bigD = BigDouble("0.0000000003") // nine zeroes
        bigD?.precision = 0
        XCTAssertEqual(bigD?.decimalDescription, "0.0")
        bigD?.precision = 10
        XCTAssertEqual(bigD?.decimalDescription, "0.0000000003")
        bigD?.precision = 15
        XCTAssertEqual(bigD?.decimalDescription, "0.000000000300000")
        bigD?.precision = 5
        XCTAssertEqual(bigD?.decimalDescription, "0.00000")
    }
    
    func testNearlyEqual() {
        //BigDouble.precision = 50
        let BDMax = BigDouble(Double.greatestFiniteMagnitude)
        let BDMin = BigDouble(Double.leastNormalMagnitude)
        let eFourty = BigDouble("0.00000 00000 00000 00000 00000 00000 00000 00001".replacingOccurrences(of: " ", with: ""))!
        
        //print(BDMax.decimalDescription, BDMin.decimalDescription, eFourty.decimalDescription)
        
        XCTAssert(BigDouble.nearlyEqual(BigDouble(100), BigDouble(100), epsilon: 0.00001))
        XCTAssert(BigDouble.nearlyEqual(BigDouble(100), BigDouble(100.00000001), epsilon: 0.00001))
        XCTAssert(BigDouble.nearlyEqual(BigDouble(100), BigDouble(100.0000001), epsilon: 0.00001))
        XCTAssert(BigDouble.nearlyEqual(BigDouble(100), BigDouble(100.000001), epsilon: 0.00001))
        XCTAssert(BigDouble.nearlyEqual(BigDouble(100), BigDouble(100.0001), epsilon: 0.00001))
        XCTAssert(BigDouble.nearlyEqual(BigDouble(100), BigDouble(100.001), epsilon: 0.00001))
        XCTAssert(false == BigDouble.nearlyEqual(BigDouble(100), BigDouble(100.01), epsilon: 0.00001))
        XCTAssert(false == BigDouble.nearlyEqual(BigDouble(100), BigDouble(100.1), epsilon: 0.00001))
        XCTAssert(false == BigDouble.nearlyEqual(BigDouble(100), BigDouble(101), epsilon: 0.00001))
        XCTAssert(false == BigDouble.nearlyEqual(BigDouble(100), BigDouble(11), epsilon: 0.00001))
        XCTAssert(false == BigDouble.nearlyEqual(BigDouble(100), BigDouble(1), epsilon: 0.00001))
        
        // Regular large numbers - generally not problematic
        XCTAssert(BigDouble.nearlyEqual(BigDouble(1000000), BigDouble(1000001)));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(1000001), BigDouble(1000000)));
        XCTAssert(false == BigDouble.nearlyEqual(BigDouble(10000), BigDouble(10001)));
        XCTAssert(false == BigDouble.nearlyEqual(BigDouble(10001), BigDouble(10000)));
        
        // Negative large numbers
        XCTAssert(BigDouble.nearlyEqual(BigDouble(-1000000), BigDouble(-1000001)));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(-1000001), BigDouble(-1000000)));
        XCTAssert(false == BigDouble.nearlyEqual(BigDouble(-10000), BigDouble(-10001)));
        XCTAssert(false == BigDouble.nearlyEqual(BigDouble(-10001), BigDouble(-10000)));
        
        // Numbers around 1
        XCTAssert(BigDouble.nearlyEqual(BigDouble(1.0000001), BigDouble(1.0000002)));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(1.0000002), BigDouble(1.0000001)));
        XCTAssert(false == BigDouble.nearlyEqual(BigDouble(1.0002), BigDouble(1.0001)));
        XCTAssert(false == BigDouble.nearlyEqual(BigDouble(1.0001), BigDouble(1.0002)));
        
        // Number around -1
        XCTAssert(BigDouble.nearlyEqual(BigDouble(-1.000001), BigDouble(-1.000002)));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(-1.000002), BigDouble(-1.000001)));
        XCTAssert(false == BigDouble.nearlyEqual(BigDouble(-1.0001), BigDouble(-1.0002)));
        XCTAssert(false == BigDouble.nearlyEqual(BigDouble(-1.0002), BigDouble(-1.0001)));
        
        // Numbers between 0 and 1
        XCTAssert(BigDouble.nearlyEqual(BigDouble(0.000000001000001), BigDouble(0.000000001000002)));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(0.000000001000002), BigDouble(0.000000001000001)));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(0.000000000001002), BigDouble(0.000000000001001)));
        XCTAssert( BigDouble.nearlyEqual(BigDouble(0.000000000001001), BigDouble(0.000000000001002)));
        
        // Numbers between -1 and 0
        XCTAssert(BigDouble.nearlyEqual(BigDouble(-0.000000001000001), BigDouble(-0.000000001000002)));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(-0.000000001000002), BigDouble(-0.000000001000001)));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(-0.000000000001002), BigDouble(-0.000000000001001)));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(-0.000000000001001), BigDouble(-0.000000000001002)));
        
        // small difference away from zero
        XCTAssert(BigDouble.nearlyEqual(BigDouble(0.3), BigDouble(0.30000003)));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(-0.3), BigDouble(-0.30000003)));
        
        // comparisons involving zero
        XCTAssert(BigDouble.nearlyEqual(BigDouble(0.0), BigDouble(0.0)));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(0.0), BigDouble(-0.0)));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(-0.0), BigDouble(-0.0)));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(0.00000001), BigDouble(0.0)));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(0.0), BigDouble(0.00000001)));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(-0.00000001), BigDouble(0.0)));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(0.0), BigDouble(-0.00000001)));
        
        XCTAssert(BigDouble(0.0) != eFourty)
        XCTAssert(BigDouble.nearlyEqual(BigDouble(0.0), eFourty, epsilon: 0.01));
        XCTAssert(BigDouble.nearlyEqual(eFourty, BigDouble(0.0), epsilon: 0.01));
        XCTAssert(BigDouble.nearlyEqual(eFourty, BigDouble(0.0), epsilon: 0.000001));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(0.0), eFourty, epsilon: 0.000001));
        
        XCTAssert(BigDouble.nearlyEqual(BigDouble(0.0), -eFourty, epsilon:0.1));
        XCTAssert(BigDouble.nearlyEqual(-eFourty, BigDouble(0.0), epsilon:0.1));
        XCTAssert(BigDouble.nearlyEqual(-eFourty, BigDouble(0.0), epsilon: 0.00000001));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(0.0), -eFourty, epsilon:0.00000001));
        
        // comparisons involving "extreme" values
        XCTAssert(BigDouble.nearlyEqual(BDMax, BDMax));
        XCTAssert(false == BigDouble.nearlyEqual(BDMax, -BDMax));
        XCTAssert(false == BigDouble.nearlyEqual(-BDMax, BDMax));
        XCTAssert(false == BigDouble.nearlyEqual(BDMax, BDMax / 2));
        XCTAssert(false == BigDouble.nearlyEqual(BDMax, -BDMax / 2));
        XCTAssert(false == BigDouble.nearlyEqual(-BDMax, BDMax / 2));
        
        // comparions very close to zero
        XCTAssert(BigDouble.nearlyEqual(BDMin, BDMin));
        XCTAssert(BigDouble.nearlyEqual(BDMin, -BDMin));
        XCTAssert(BigDouble.nearlyEqual(-BDMin, BDMin));
        XCTAssert(BigDouble.nearlyEqual(BDMin, BigDouble(0.0)));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(0.0), BDMin));
        XCTAssert(BigDouble.nearlyEqual(-BDMin, BigDouble(0.0)));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(0.0), -BDMin));
        
        XCTAssert(BigDouble.nearlyEqual(BigDouble(0.000000001), -BDMin));
        XCTAssert(BigDouble.nearlyEqual(BigDouble(0.000000001), BDMin));
        XCTAssert(BigDouble.nearlyEqual(BDMin, BigDouble(0.000000001)));
        XCTAssert(BigDouble.nearlyEqual(-BDMin, BigDouble(0.000000001)));
    }
    
    func testRadix() {
        XCTAssertEqual(BigDouble("aa", radix: 16), 170)
        XCTAssertEqual(BigDouble("0xaa", radix: 16), 170)
        XCTAssertEqual(BigDouble("invalid", radix: 16), nil)
        
        XCTAssertEqual(BigDouble("252", radix: 8), 170)
        XCTAssertEqual(BigDouble("0o252", radix: 8), 170)
        XCTAssertEqual(BigDouble("invalid", radix: 8), nil)
        
        XCTAssertEqual(BigDouble("11", radix: 2), 3)
        XCTAssertEqual(BigDouble("0b11", radix: 2), 3)
        XCTAssertEqual(BigDouble("invalid", radix: 2), nil)
        
        XCTAssertEqual(BigDouble("ffff",radix:16), 65535)
        XCTAssertEqual(BigDouble("rfff",radix:16), nil)
        XCTAssertEqual(BigDouble("ff",radix:10), nil)
        XCTAssertEqual(BigDouble("255",radix:6), 107)
        XCTAssertEqual(BigDouble("999",radix:10), 999)
        XCTAssertEqual(BigDouble("ff",radix:16), 255.0)
        XCTAssert(BigDouble("ff",radix:16) != 100.0)
        XCTAssert(BigDouble("ffff",radix:16)! > 255.0)
        XCTAssert(BigDouble("f",radix:16)! < 255.0)
        XCTAssert(BigDouble("0",radix:16)! <= 1.0)
        XCTAssert(BigDouble("f",radix:16)! >= 1.0)
        XCTAssertEqual(BigDouble("44",radix:5), 24)
        XCTAssert(BigDouble("44",radix:5) != 100.0)
        XCTAssertEqual(BigDouble("321",radix:5)!, 86)
        XCTAssert(BigDouble("3",radix:5)! < 255.0)
        XCTAssert(BigDouble("0",radix:5)! <= 1.0)
        XCTAssert(BigDouble("4",radix:5)! >= 1.0)
        XCTAssertEqual(BigDouble("923492349",radix:32)!, 9967689075849)
    }
    
    func testOperations() {
        XCTAssertEqual(BigDouble(1.5) + BigDouble(2.0), BigDouble(3.5))
        XCTAssertEqual(BigDouble(1.5) - BigDouble(2.0), BigDouble(-0.5))
        XCTAssertEqual(BigDouble(1.5) * BigDouble(2.0), BigDouble(3.0))
        XCTAssert(BigDouble(1.0) / BigDouble(2.0) == BigDouble(0.5))
        XCTAssertEqual(-BigDouble(6.54), BigDouble(-6.54))
        testPow()
    }
    
    func testPerformanceStringInit() {
        self.measure {
            for _ in (0...1000) {
                let _ = BigDouble(String(arc4random()))
                let _ = BigDouble(String(arc4random())+"."+String(arc4random()))
            }
        }
    }
    
    func testPerformanceStringRadixInit() {
        self.measure {
            for _ in (0...1000) {
                let _ = BigDouble(String(arc4random()), radix: 10)
                let _ = BigDouble(String(arc4random())+"."+String(arc4random()), radix: 10)
            }
        }
    }
    
    static var allTests = [
        ("Initialisation", testInitialization),
        ("Compare", testCompare),
        ("Exponentiation", testPow),
        ("Decimal Expansion (no rounding)", testDecimalExpansionWithoutRounding),
        ("Decimal Expansion (rounding)", testDecimalExpansionWithRounding),
        ("Decimal Expansion (random)", test_decimalExpansionRandom),
        ("Rounding", testRounding),
        ("Precision", testPrecision),
        ("Nearly Equal", testNearlyEqual),
        ("Radix", testRadix),
        ("Operations", testOperations),
        ("String Performance", testPerformanceStringInit),
        ("String multiple performances", testPerformanceStringRadixInit)
    ]
}
