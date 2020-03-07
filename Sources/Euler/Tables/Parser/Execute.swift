//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-03-03.
//

import Foundation

public extension Tables {
    
    func execute() throws -> BigDouble {
        guard self.expression != nil else { throw TablesError.NULL }
        let p = Parser(self.expression!, type: .tables) // new parser for Tables
        let expression = try p.parse() // Trying to parse the expression
        
        return try expression.evaluate([:], linker)
    }
    
    var linker: [String:(([Any]) throws -> BigDouble?)] {
        return [
            "ABS": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return self.ABS(n)
            },
            "ACOS": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return try self.ACOS(n)
            },
            "ACOSH": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return try self.ACOSH(n)
            },
            "ACOT": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return try self.ACOT(n)
            },
            "ACOTH": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return try self.ACOTH(n)
            },
            "ASIN": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return try self.ASINH(n)
            },
            "ATAN": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return try self.ATAN(n)
            },
            "ATAN2": { args in
                guard args.count == 2 else { return nil }
                guard let f = args.first else { return nil }
                let s = args[1]
                guard let n1 = f as? BigNumber else { return nil }
                guard let n2 = s as? BigNumber else { return nil }
                return try self.ATAN2(n1, n2)
            },
            "ATANH": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return try self.ATANH(n)
            },
//            "BASE": { args in
//                guard args.count == 2 else { return nil }
//                guard let arguments = args as? [BigNumber] else { return nil }
//                let ns = arguments.map { $0.rounded() }
//                return try self.BASE(ns[0], ns[1])
//            }
            "CEILING": { args in
                guard args.count >= 1 else { return nil }
                guard let arguments = args as? [BigNumber] else { return nil }
                let n = arguments[0]
                guard args.count >= 2 else {
                    return self.CEILING(n)
                }
                let s = arguments[1]
                guard args.count >= 3 else {
                    return self.CEILING(n, significance: s)
                }
                guard let m = arguments[2].rounded().asInt() else {
                    return self.CEILING(n, significance: s)
                }
                return self.CEILING(n, significance: s, mode: m)
            },
            "COMBIN": { args in
                guard args.count == 2 else { return nil }
                guard let f = args.first else { return nil }
                let s = args[1]
                guard let n1 = f as? BigNumber else { return nil }
                guard let n2 = s as? BigNumber else { return nil }
                return try BigDouble(self.COMBIN(n1.rounded(), k: n2.rounded()))
            },
            "COMBINA": { args in
                guard args.count == 2 else { return nil }
                guard let f = args.first else { return nil }
                let s = args[1]
                guard let n1 = f as? BigNumber else { return nil }
                guard let n2 = s as? BigNumber else { return nil }
                return try BigDouble(self.COMBINA(n1.rounded(), k: n2.rounded()))
            },
            "COS": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return try self.COS(n)
            },
            "COSH": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return try self.COSH(n)
            },
            "COT": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return try self.COT(n)
            },
            "COTH": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return self.COTH(n)
            },
            "CSC": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return try self.CSC(n)
            },
            "CSCH": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return self.CSCH(n)
            },
            "DECIMAL": { args in
                guard args.count == 2 else { return nil }
                guard let f = args.first else { return nil }
                let s = args[1]
                guard let n1 = f as? String else { return nil }
                guard let n2 = s as? BigNumber else { return nil }
                guard let radix = n2.rounded().asInt() else { return nil }
                return self.DECIMAL(n1, radix)
            },
            "DEGREES": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return self.DEGREES(n)
            },
            "EVEN": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return BigDouble(self.EVEN(n))
            },
            "EXP": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return self.EXP(n)
            },
            "FACT": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return BigDouble(self.FACT(n.rounded()))
            },
            "FACTDOUBLE": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return BigDouble(self.FACTDOUBLE(n.rounded()))
            },
            "FLOOR": { args in
                guard args.count >= 1 else { return nil }
                guard let arguments = args as? [BigNumber] else { return nil }
                let n = arguments[0]
                guard args.count >= 2 else {
                    return self.FLOOR(n)
                }
                let s = arguments[1]
                guard args.count >= 3 else {
                    return self.FLOOR(n, significance: s)
                }
                guard let m = arguments[2].rounded().asInt() else {
                    return self.FLOOR(n, significance: s)
                }
                return self.FLOOR(n, significance: s, mode: m)
            },
            "GCD": { args in
                guard let a = args as? [BigDouble] else { return nil }
                let array = a.map { $0.rounded() }
                return try BigDouble(self.GCD(array: array))
            },
            "INT": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return BigDouble(self.INT(n))
            },
            "LCM": { args in
                guard let a = args as? [BigDouble] else { return nil }
                let array = a.map { $0.rounded() }
                return try BigDouble(self.LCM(array: array))
            },
            "LN": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return self.LN(n)
            },
            "LOG": { args in
                guard let a = args as? [BigDouble] else { return nil }
                guard a.count >= 1 else { return nil }
                guard a.count > 1 else {
                    return self.LOG(a[0])
                }
                guard let base = a[1].rounded().asInt() else { return self.LOG(a[0]) }
                return self.LOG(a[0], base: base)
            },
            "LOG10": { args in
                guard let f = args.first else { return nil }
                guard let n = f as? BigNumber else { return nil }
                return self.LOG10(n)
            },
            // MARK: TODO: Matrix
            "MROUND": { args in
                guard args.count == 2 else { return nil }
                guard let f = args.first else { return nil }
                let s = args[1]
                guard let n1 = f as? BigNumber else { return nil }
                guard let n2 = s as? BigNumber else { return nil }
                return try self.MROUND(n1, n2)
            },
            "MOD": { args in
                guard args.count == 2 else { return nil }
                guard let f = args.first else { return nil }
                let s = args[1]
                guard let n1 = f as? BigNumber else { return nil }
                guard let n2 = s as? BigNumber else { return nil }
                return try self.MOD(n1, n2)
            },
            "MULTINOMIAL": { args in
                guard let a = args as? [BigDouble] else { return nil }
                let array = a.map { $0.rounded() }
                return try self.MULTINOMIAL(array: array)
            }
        ]
    }
}
