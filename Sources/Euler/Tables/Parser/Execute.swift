//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-03-03.
//

import Foundation

public extension Tables {
    
    func execute() throws -> CellValue {
        guard self.expression != nil else { throw TablesError.NULL }
        let p = Parser(self.expression!, type: .tables) // new parser for Tables
        let expression = try p.parse() // Trying to parse the expression
        
        return try expression.evaluate([:], linker)
    }
    
    var linker: [String:(([CellValue]) throws -> CellValue)] {
        return [
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
            }
        ]
    }
}
