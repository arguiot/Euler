//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2019-12-16.
//

import Foundation

import XCTest
@testable import Euler

class NodeTests: XCTestCase {
    func testConstantNode() {
        let c1 = ConstantNode(2)
        
        XCTAssertEqual(c1.evaluate([:]), BigNumber(2))
    }
    func testOperatorNode() {
        let c1 = ConstantNode(2)
        let c2 = ConstantNode(4)
        let op = OperatorNode("*", children: [c1, c2])
        
        XCTAssertEqual(op.evaluate([:]), BigNumber(8))
        
        let c3 = ConstantNode(5)
        let op2 = OperatorNode("+", children: [c3, op])
        
        XCTAssertEqual(op2.evaluate([:]), BigNumber(13))
    }
    func testSymboleNode() {
        let c1 = ConstantNode(2)
        let c2 = SymbolNode("x")
        let op = OperatorNode("*", children: [c1, c2])
        
        XCTAssertEqual(op.evaluate(["x": BigNumber(4)]), BigNumber(8))
        
        let c3 = ConstantNode(5)
        let op2 = OperatorNode("+", children: [c3, op])
        
        XCTAssertEqual(op2.toString(), "5 + 2 * x")
    }
    func testParser() {
        let src = "x+2 - sqrt(3*4)=2"
        let lexer = Lexer(input: src)
        let tokens = lexer.tokenize()
        
        let p = Parser(tokens: tokens)
        do {
            let expression = try p.parse()
            let str = expression.toString()
            XCTAssertEqual(str, "x + 2.0 - sqrt(3.0 * 4.0) = 2.0")
            XCTAssertEqual(try Parser("5.0 - sqrt(8) * 5 = x^2 - factorial(4)").parse().toString(), "5.0 - sqrt(8.0) * 5.0 = x ^ 2.0 - factorial(4.0)")
            XCTAssertEqual(try Parser("((4*2) - 3) +sqrt(4)").parse().toString(), "((4.0 * 2.0) - 3.0) + sqrt(4.0)")
        } catch {
            print(error.localizedDescription)
            XCTFail()
        }
        
    }
    func testCompile() {
        do {
            let p = Parser("x+y*2 + (4+5)/3")
            let expression = try p.parse()
            let comp = expression.compile()
            XCTAssertEqual(comp.toString(), "x + y * 2.0 + 3.0")
            
            XCTAssertEqual(try Parser("(4*2)").parse().compile().toString(), "8.0000")
        } catch {
            print(error.localizedDescription)
            XCTFail()
        }
        
    }
    static var allTests = [
        ("Constant Node", testConstantNode),
        ("Operator Node", testOperatorNode),
        ("Symbol Node", testSymboleNode),
        ("Parser", testParser),
        ("Compiler", testCompile)
    ]
}
