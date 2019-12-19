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
        let c2 = SymboleNode("x")
        let op = OperatorNode("*", children: [c1, c2])
        
        XCTAssertEqual(op.evaluate(["x": BigNumber(4)]), BigNumber(8))
        
        let c3 = ConstantNode(5)
        let op2 = OperatorNode("+", children: [c3, op])
        
        XCTAssertEqual(op2.toString(), "5 + 2 * x")
    }
    func testParser() {
        let src = "x+2 - (3*4)"
        let lexer = Lexer(input: src)
        let tokens = lexer.tokenize()
        
        print(tokens)
        
        let parser = Parser(tokens: tokens)
        do {
            print(try parser.parse())
        }
        catch {
            print(error)
        }
    }
    static var allTests = [
        ("Constant Node", testConstantNode),
        ("Operator Node", testOperatorNode),
        ("Symbol Node", testSymboleNode)
    ]
}
