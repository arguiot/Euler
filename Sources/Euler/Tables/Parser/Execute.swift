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
            }
        ]
    }
}
