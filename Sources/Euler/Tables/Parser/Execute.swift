//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-03-03.
//

import Foundation

public extension Tables {
    
    /// Interprets the given command
    /// - Parameter command: The command you want to execute. Example: `=SUM(1, 2, 3, 4)`
    func interpret(command: String) throws -> CellValue {
        let p = Parser(command, type: .tables) // new parser for Tables
        
        p.tablesContext = self
        
        let expression = try p.parse() // Trying to parse the expression
        
        return try expression.evaluate([:], linker)
    }
    
    /// Huge list of all Tables functions.
    ///
    /// While this is public, it's not intended for use.
    ///
    static var functions: [String:(([CellValue]) throws -> CellValue)] {
        return Tables().linker
    }
    /// Links internal functions to parser by exposing them
    internal var linker: [String:(([CellValue]) throws -> CellValue)] {
        return [
            // MARK: CommonFormulas
            "ABS": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: self.ABS(n))
            },
            "ACOS": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return try CellValue(number: self.ACOS(n))
            },
            "ACOSH": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return try CellValue(number: self.ACOSH(n))
            },
            "ACOT": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return try CellValue(number: self.ACOT(n))
            },
            "ACOTH": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return try CellValue(number: self.ACOTH(n))
            },
            "ASIN": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return try CellValue(number: self.ASINH(n))
            },
            "ATAN": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return try CellValue(number: self.ATAN(n))
            },
            "ATAN2": { args in
                guard args.count == 2 else { return CellValue.nil }
                guard let f = args.first else { return CellValue.nil }
                let s = args[1]
                guard let n1 = f.number else { return CellValue.nil }
                guard let n2 = s.number else { return CellValue.nil }
                return try CellValue(number: self.ATAN2(n1, n2))
            },
            "ATANH": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return try CellValue(number: self.ATANH(n))
            },
//            "BASE": { args in
//                guard args.count == 2 else { return CellValue.nil }
//                guard let arguments = args as? [BigNumber] else { return CellValue.nil }
//                let ns = arguments.map { $0.rounded() }
//                return try self.BASE(ns[0], ns[1])
//            }
            "CEILING": { args in
                guard args.count >= 1 else { return CellValue.nil }
                let tmp = args.map { $0.number }
                guard let arguments = tmp as? [BigNumber] else { return CellValue.nil }
                let n = arguments[0]
                guard args.count >= 2 else {
                    return CellValue(number: self.CEILING(n))
                }
                let s = arguments[1]
                guard args.count >= 3 else {
                    return CellValue(number: self.CEILING(n, significance: s))
                }
                guard let m = arguments[2].rounded().asInt() else {
                    return CellValue(number: self.CEILING(n, significance: s))
                }
                return CellValue(number: self.CEILING(n, significance: s, mode: m))
            },
            "COMBIN": { args in
                guard args.count == 2 else { return CellValue.nil }
                guard let f = args.first else { return CellValue.nil }
                let s = args[1]
                guard let n1 = f.number else { return CellValue.nil }
                guard let n2 = s.number else { return CellValue.nil }
                return try CellValue(int: self.COMBIN(n1.rounded(), k: n2.rounded()))
            },
            "COMBINA": { args in
                guard args.count == 2 else { return CellValue.nil }
                guard let f = args.first else { return CellValue.nil }
                let s = args[1]
                guard let n1 = f.number else { return CellValue.nil }
                guard let n2 = s.number else { return CellValue.nil }
                return try CellValue(int: self.COMBINA(n1.rounded(), k: n2.rounded()))
            },
            "COS": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return try CellValue(number: self.COS(n))
            },
            "COSH": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return try CellValue(number: self.COSH(n))
            },
            "COT": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return try CellValue(number: self.COT(n))
            },
            "COTH": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: self.COTH(n))
            },
            "CSC": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return try CellValue(number: self.CSC(n))
            },
            "CSCH": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: self.CSCH(n))
            },
            "DECIMAL": { args in
                guard args.count == 2 else { return CellValue.nil }
                guard let f = args.first else { return CellValue.nil }
                let s = args[1]
                guard let n1 = f.string else { return CellValue.nil }
                guard let n2 = s.number else { return CellValue.nil }
                guard let radix = n2.rounded().asInt() else { return CellValue.nil }
                return CellValue(number: self.DECIMAL(n1, radix))
            },
            "DEGREES": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: self.DEGREES(n))
            },
            "EVEN": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(int: self.EVEN(n))
            },
            "EXP": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: self.EXP(n))
            },
            "FACT": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(int: self.FACT(n.rounded()))
            },
            "FACTDOUBLE": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(int: self.FACTDOUBLE(n.rounded()))
            },
            "FLOOR": { args in
                guard args.count >= 1 else { return CellValue.nil }
                let tmp = args.map { $0.number }
                guard let arguments = tmp as? [BigNumber] else { return CellValue.nil }
                let n = arguments[0]
                guard args.count >= 2 else {
                    return CellValue(number: self.FLOOR(n))
                }
                let s = arguments[1]
                guard args.count >= 3 else {
                    return CellValue(number: self.FLOOR(n, significance: s))
                }
                guard let m = arguments[2].rounded().asInt() else {
                    return CellValue(number: self.FLOOR(n, significance: s))
                }
                return CellValue(number: self.FLOOR(n, significance: s, mode: m))
            },
            "GCD": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                let array = a.map { $0.rounded() }
                return try CellValue(int: self.GCD(array: array))
            },
            "INT": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(int: self.INT(n))
            },
            "LCM": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                let array = a.map { $0.rounded() }
                return try CellValue(int: self.LCM(array: array))
            },
            "LN": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: self.LN(n))
            },
            "LOG": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                guard a.count >= 1 else { return CellValue.nil }
                guard a.count > 1 else {
                    return CellValue(number: self.LOG(a[0]))
                }
                guard let base = a[1].rounded().asInt() else {
                    return CellValue(number: self.LOG(a[0]))
                }
                return CellValue(number: self.LOG(a[0], base: base))
            },
            "LOG10": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: self.LOG10(n))
            },
            // MARK: TODO: Matrix
            "MROUND": { args in
                guard args.count == 2 else { return CellValue.nil }
                guard let f = args.first else { return CellValue.nil }
                let s = args[1]
                guard let n1 = f.number else { return CellValue.nil }
                guard let n2 = s.number else { return CellValue.nil }
                return try CellValue(number: self.MROUND(n1, n2))
            },
            "MOD": { args in
                guard args.count == 2 else { return CellValue.nil }
                guard let f = args.first else { return CellValue.nil }
                let s = args[1]
                guard let n1 = f.number else { return CellValue.nil }
                guard let n2 = s.number else { return CellValue.nil }
                return CellValue(number: self.MOD(n1, n2))
            },
            "MULTINOMIAL": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                let array = a.map { $0.rounded() }
                return CellValue(number: self.MULTINOMIAL(array: array))
            },
            "ODD": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(int: self.ODD(n))
            },
            "PI": { _ in
                return CellValue(number: pi)
            },
            "POWER": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(number: self.POWER(a[0], a[1]))
            },
            "PRODUCT": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                return CellValue(number: self.PRODUCT(a))
            },
            "QUOTIENT": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(int: self.QUOTIENT(a[0], a[1]))
            },
            "RADIANS": { args in
                guard args.count == 1 else { return CellValue.nil }
                guard let n = args[0].number else { return CellValue.nil }
                return CellValue(number: self.RADIANS(n))
            },
            "RAND": { _ in
                return CellValue(number: self.RAND())
            },
            "RANDBETWEEN": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(number: self.RANDBETWEEN(a[0], a[1]))
            },
            "ROUND": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(number: self.ROUND(a[0], digits: a[1].rounded()))
            },
            "ROUNDDOWN": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(number: self.ROUNDDOWN(a[0], digits: a[1].rounded()))
            },
            "ROUNDUP": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(number: self.ROUNDUP(a[0], digits: a[1].rounded()))
            },
            "SEC": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: try self.SEC(n))
            },
            "SECH": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: self.SECH(n))
            },
            "SERIESSUM": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                guard a.count >= 4 else { return CellValue.nil }
                return CellValue(number: try self.SERIESSUM(a[0], a[1], a[2], a.dropLast(3)))
            },
            "SIGN": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(int: self.SIGN(n))
            },
            "SIN": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: try self.SIN(n))
            },
            "SINH": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: self.SINH(n))
            },
            "SQRT": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                guard let sqrt = try? self.SQRT(n) else { return CellValue.nil }
                return CellValue(number: sqrt)
            },
            "SQRTPI": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                guard let sqrt = try? self.SQRTPI(n) else { return CellValue.nil }
                return CellValue(number: sqrt)
            },
            "ADD": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(number: self.ADD(a[0], a[1]))
            },
            "MINUS": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(number: self.MINUS(a[0], a[1]))
            },
            "DIVIDE": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(number: try self.DIVIDE(a[0], a[1]))
            },
            "MULTIPLY": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(number: self.MULTIPLY(a[0], a[1]))
            },
            "GTE": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(boolean: self.GTE(a[0], a[1]))
            },
            "LT": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(boolean: self.LT(a[0], a[1]))
            },
            "LTE": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(boolean: self.LTE(a[0], a[1]))
            },
            "EQ": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(boolean: self.EQ(a[0], a[1]))
            },
            "NE": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(boolean: self.NE(a[0], a[1]))
            },
            "POW": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(number: self.POW(a[0], a[1]))
            },
            "SUM": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                return CellValue(number: self.SUM(a))
            },
            "SUMPRODUCT": { args in
                #if os(macOS)
                return CellValue.nil // TODO: CellValue doesn't support arrays
                #else
                return CellValue.nil
                #endif
            },
            "SUMSQ": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                return CellValue(number: self.SUMSQ(a))
            },
            "TAN": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: try self.TAN(n))
            },
            "TANH": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: try self.TANH(n))
            },
            "TRUNC": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                guard let i = a[1].rounded().asInt() else { return CellValue.nil }
                return CellValue(number: self.TRUNC(a[0], i))
            },
            // MARK: Logical
            "AND": { args in
                let tmp = args.map { $0.boolean }
                guard let a = tmp as? [Bool] else { return CellValue.nil }
                return CellValue(boolean: self.AND(a))
            },
            "OR": { args in
                let tmp = args.map { $0.boolean }
                guard let a = tmp as? [Bool] else { return CellValue.nil }
                return CellValue(boolean: self.OR(a))
            },
            "XOR": { args in
                let tmp = args.map { $0.boolean }
                guard let a = tmp as? [Bool] else { return CellValue.nil }
                return CellValue(boolean: self.XOR(a))
            },
            // MARK: Engineering
            "BIN2DEC": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: try self.BIN2DEC(n))
            },
            "BIN2HEX": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(string: try self.BIN2HEX(n))
            },
            "BIN2OCT": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: try self.BIN2OCT(n))
            },
            "BITAND": { args in
                let tmp = args.map { $0.number?.rounded() }
                guard let a = tmp as? [BigInt] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(number: BigNumber(self.BITAND(a[0], a[1])))
            },
            "BITOR": { args in
                let tmp = args.map { $0.number?.rounded() }
                guard let a = tmp as? [BigInt] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(number: BigNumber(self.BITOR(a[0], a[1])))
            },
            "BITXOR": { args in
                let tmp = args.map { $0.number?.rounded() }
                guard let a = tmp as? [BigInt] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(number: BigNumber(self.BITXOR(a[0], a[1])))
            },
            "BITLSHIFT": { args in
                let tmp = args.map { $0.number?.rounded() }
                guard let a = tmp as? [BigInt] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(number: BigNumber(self.BITLSHIFT(a[0], a[1])))
            },
            "BITRSHIFT": { args in
                let tmp = args.map { $0.number?.rounded() }
                guard let a = tmp as? [BigInt] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(number: BigNumber(self.BITRSHIFT(a[0], a[1])))
            },
            "CONVERT": { args in
                guard args.count == 3 else { return CellValue.nil }
                guard let n = args[0].number else { return CellValue.nil }
                guard let from = args[1].string else { return CellValue.nil }
                guard let to = args[2].string else { return CellValue.nil }
                return CellValue(number: try self.CONVERT(n, from_unit: from, to_unit: to))
            },
            "DEC2BIN": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: self.DEC2BIN(n))
            },
            "DEC2HEX": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(string: self.DEC2HEX(n))
            },
            "DEC2OCT": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: self.DEC2OCT(n))
            },
            "DELTA": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigNumber] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                return CellValue(number: BigNumber(self.DELTA(a[0], a[1])))
            },
            "HEX2BIN": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.string else { return CellValue.nil }
                return CellValue(number: BigNumber(try self.HEX2BIN(n)))
            },
            "HEX2DEC": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.string else { return CellValue.nil }
                return CellValue(number: BigNumber(try self.HEX2DEC(n)))
            },
            "HEX2OCT": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.string else { return CellValue.nil }
                return CellValue(number: BigNumber(try self.HEX2OCT(n)))
            },
            // MARK: DateTime
            "DATE": { args in
                let tmp = args.map { $0.number?.rounded().asInt() }
                guard let a = tmp as? [Int] else { return CellValue.nil }
                guard a.count == 3 else { return CellValue.nil }
                return CellValue(number: try self.DATE(a[0], a[1], a[2]))
            },
            "DATEVALUE": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let str = f.string else { return CellValue.nil }
                return CellValue(number: try self.DATEVALUE(str))
            },
            "YEARFRAC": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigDouble] else { return CellValue.nil }
                guard a.count >= 2 else { return CellValue.nil }
                if a.count == 2 {
                    return CellValue(number: try self.YEARFRAC(start: a[0], end: a[1]))
                } else {
                    return CellValue(number: try self.YEARFRAC(start: a[0], end: a[1], basis: a[2].rounded().asInt()!))
                }
            },
        ]
    }
}
