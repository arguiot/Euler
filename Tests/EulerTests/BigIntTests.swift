//
//  EulerTests.swift
//  Euler
//
//  Created by Arthur Guiot on 2019-12-04.
//  Copyright © 2019 Euler. All rights reserved.
//

import Foundation
import XCTest
@testable import Euler

class BigIntTests: XCTestCase {
    func testRadixInitializerAndGetter() {
        let chars: [Character] = [
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g",
            "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x",
            "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
            "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
        ]

        // Randomly choose two bases and a number length, as well as a sign (+ or -)
        for _ in 0..<100 {
            let fromBase = math.random(2...62)
            let toBase = math.random(2...62)
            let numLength = math.random(1...100)
            let sign = math.random(0...1) == 1 ? "-" : ""

            // First digit should not be a 0.
            var num = sign + String(chars[math.random(1..<fromBase)])

            for _ in 1..<numLength {
                num.append(chars[math.random(0..<fromBase)])
            }

            // Convert the random number to a BigInt type
            let b1 = BigInt(num, radix: fromBase)
            // Get the number as a string with the second base
            let s1 = b1!.asString(radix: toBase)
            // Convert that number to a BigInt type
            let b2 = BigInt(s1, radix: toBase)
            // Get the number back as as string in the start base
            let s2 = b2!.asString(radix: fromBase)

            XCTAssert(b1 == b2)
            XCTAssert(s2 == num)
        }

        let bigHex = "abcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdef00"
        let x = BigInt(bigHex, radix: 16)!
        XCTAssert(x.asString(radix: 16) == bigHex)
    }


    func testRadix() {
        XCTAssert(BigInt("ffff",radix:16) == 65535)
        XCTAssert(BigInt("ff",radix:16) == 255.0)
        XCTAssert(BigInt("ff",radix:16) != 100.0)
        XCTAssert(BigInt("ffff",radix:16)! > 255.0)
        XCTAssert(BigInt("f",radix:16)! < 255.0)
        XCTAssert(BigInt("0",radix:16)! <= 1.0)
        XCTAssert(BigInt("f", radix: 16)! >= 1.0)
        XCTAssert(BigInt("rfff",radix:16) == nil)
        
        XCTAssert(BigInt("ffff",radix:16) == 65535)
        XCTAssert(BigInt("rfff",radix:16) == nil)
        XCTAssert(BigInt("ff",radix:10) == nil)
        XCTAssert(BigInt("255",radix:6) == 107)
        XCTAssert(BigInt("999",radix:10) == 999)
        XCTAssert(BigInt("ff",radix:16) == 255.0)
        XCTAssert(BigInt("ff",radix:16) != 100.0)
        XCTAssert(BigInt("ffff",radix:16)! > 255.0)
        XCTAssert(BigInt("f",radix:16)! < 255.0)
        XCTAssert(BigInt("0",radix:16)! <= 1.0)
        XCTAssert(BigInt("f",radix:16)! >= 1.0)
        XCTAssert(BigInt("44",radix:5) == 24)
        XCTAssert(BigInt("44",radix:5) != 100.0)
        XCTAssert(BigInt("321",radix:5)! == 86)
        XCTAssert(BigInt("3",radix:5)! < 255.0)
        XCTAssert(BigInt("0",radix:5)! <= 1.0)
        XCTAssert(BigInt("4",radix:5)! >= 1.0)
        XCTAssert(BigInt("923492349",radix:32)! == 9967689075849)
    }
    
    func testDivision() {
        
        for _ in (0...150) {
            let a = BigInt(Int.random(in: Int.min...Int.max)) * BigInt(Int.random(in: Int.min...Int.max))
            let b = BigInt(Int.random(in: Int.min...Int.max)) * BigInt(Int.random(in: Int.min...Int.max))
            let (q, r) = a.limbs.divMod(b.limbs)
            
            let (q2, r2) = a.limbs.divMod_ShiftSubtract(b.limbs)
            
            XCTAssertEqual(q, q2)
            XCTAssertEqual(r, r2)
        }
        
        self.measure {
            for _ in (0...15000) {
                let _ = BigInt(Int.random(in: 0...Int.max)) / BigInt(Int.random(in: 0...Int.max))
            }
        }
    }
    
    func testPerformanceStringInit() {
        self.measure {
            for _ in (0...15000) {
                let _ = BigInt(String(Int.random(in: 0...Int.max)))
            }
        }
    }
    
    func testPerformanceStringRadixInit() {
        self.measure {
            for _ in (0...15000) {
                let _ = BigInt(String(Int.random(in: 0...Int.max)), radix: 10)
            }
        }
    }
    
    func testNumberTheory() {
        // MARK: Fibonacci
        XCTAssertEqual(BigInt(20).fibonacci, 6765)
        XCTAssertEqual(BigInt(1000).fibonacci, BigInt("43466557686937456435688527675040625802564660517371780402481729089536555417949051890403879840079255169295922593080322634775209689623239873322471161642996440906533187938298969649928516003704476137795166849228875"))
        // MARK: Factorial
        XCTAssertEqual(try? factorial(1000), BigInt("402387260077093773543702433923003985719374864210714632543799910429938512398629020592044208486969404800479988610197196058631666872994808558901323829669944590997424504087073759918823627727188732519779505950995276120874975462497043601418278094646496291056393887437886487337119181045825783647849977012476632889835955735432513185323958463075557409114262417474349347553428646576611667797396668820291207379143853719588249808126867838374559731746136085379534524221586593201928090878297308431392844403281231558611036976801357304216168747609675871348312025478589320767169132448426236131412508780208000261683151027341827977704784635868170164365024153691398281264810213092761244896359928705114964975419909342221566832572080821333186116811553615836546984046708975602900950537616475847728421889679646244945160765353408198901385442487984959953319101723355556602139450399736280750137837615307127761926849034352625200015888535147331611702103968175921510907788019393178114194545257223865541461062892187960223838971476088506276862967146674697562911234082439208160153780889893964518263243671616762179168909779911903754031274622289988005195444414282012187361745992642956581746628302955570299024324153181617210465832036786906117260158783520751516284225540265170483304226143974286933061690897968482590125458327168226458066526769958652682272807075781391858178889652208164348344825993266043367660176999612831860788386150279465955131156552036093988180612138558600301435694527224206344631797460594682573103790084024432438465657245014402821885252470935190620929023136493273497565513958720559654228749774011413346962715422845862377387538230483865688976461927383814900140767310446640259899490222221765904339901886018566526485061799702356193897017860040811889729918311021171229845901641921068884387121855646124960798722908519296819372388642614839657382291123125024186649353143970137428531926649875337218940694281434118520158014123344828015051399694290153483077644569099073152433278288269864602789864321139083506217095002597389863554277196742822248757586765752344220207573630569498825087968928162753848863396909959826280956121450994871701244516461260379029309120889086942028510640182154399457156805941872748998094254742173582401063677404595741785160829230135358081840096996372524230560855903700624271243416909004153690105933983835777939410970027753472000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"))
        // MARK: GCD
        XCTAssertEqual(gcd(572, 33), 11)
        // MARK: Prime
        XCTAssertEqual(BigInt("4979354969")?.isPrime, true) // 10 digits prime
        XCTAssertEqual(BigInt(12).primeFactors, [2, 2, 3])
        XCTAssertEqual(BigInt(9007199254740991).primeFactors, [6361, 69431, 20394401])
        XCTAssertEqual(BigInt(178426363).millerRabin(), false)
        XCTAssertEqual(BigInt(178426363).millerRabin(accuracy: 10), false)
        XCTAssertEqual(BigInt(15487361).millerRabin(), true)
        // MARK: Least Factor
        XCTAssertEqual(leastFactor(50), 2)
        // MARK: Modulo
        XCTAssertEqual(mod_exp(56, 24, 5), 1)
        // MARK: Random
        XCTAssert(BigInt.randomBigNumber(bits: 64) > 0)
        // MARK: Gamma
        XCTAssertEqual(try? factorial(3), 6)
        XCTAssertEqual(try? factorial(11), 39916800)
        XCTAssertEqual(try? gamma(BN(3, over: 2)).nearlyEquals(0.8862269254527576), true)
        // MARK: Logarithms
        XCTAssert(ln(15).nearlyEquals(2.708050201102210))
        
        
        self.measure {
            let r1 = try? Statistics.polynomialRegression(points: [Point(x: 0, y: 2),Point(x: 2, y: 4),Point(x: 3, y: 5)])
            XCTAssert(r1!.evaluate(at: 4).nearlyEquals(6))
            
            let r2 = try? Statistics.polynomialRegression(points: [Point(x: 0, y: 2),Point(x: 2, y: 4),Point(x: 3, y: 4)])
            XCTAssert(r2!.evaluate(at: 6).nearlyEquals(0))
        }
    }
    
    static var allTests = [
        ("Initialisation", testRadixInitializerAndGetter),
        ("Radix", testRadix),
        ("Division performance", testDivision),
        ("String Performance", testPerformanceStringInit),
        ("String multiple performances", testPerformanceStringRadixInit),
        ("Number Theory", testNumberTheory)
    ]
}
