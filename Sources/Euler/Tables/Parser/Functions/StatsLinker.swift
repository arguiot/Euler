//
//  StatsLinker.swift
//  Euler
//
//  Created by Arthur Guiot on 2020-06-10.
//

import Foundation

internal extension Tables {
    var statsFormulas: [String:(([CellValue]) throws -> CellValue)] {
        return [
            "AVEDEV": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigDouble] else { return CellValue.nil }
                return CellValue(number: self.AVEDEV(a))
            },
            "AVERAGE": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigDouble] else { return CellValue.nil }
                return CellValue(number: self.AVERAGE(a))
            },
            "COUNT": { args in
                return CellValue(int: BigInt(args.count))
            },
            "COUNTUNIQUE": { args in
                return CellValue(int: BigInt(self.COUNTUNIQUE(args)))
            },
            "DEVSQ": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigDouble] else { return CellValue.nil }
                return CellValue(number: self.DEVSQ(a))
            },
            "FISHER": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: self.FISHER(n))
            },
            "FISHERINV": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: self.FISHERINV(n))
            },
            "GAMMA": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: self.GAMMA(n))
            },
            "GAMMALN": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: self.GAMMALN(n))
            },
            "GAUSS": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: self.GAUSS(n))
            },
            "GEOMEAN": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigDouble] else { return CellValue.nil }
                return CellValue(number: self.GEOMEAN(a))
            },
            "HARMEAN": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigDouble] else { return CellValue.nil }
                return CellValue(number: self.HARMEAN(a))
            },
            "KURT": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigDouble] else { return CellValue.nil }
                return CellValue(number: self.KURT(a))
            },
            "MAX": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigDouble] else { return CellValue.nil }
                guard let m = self.MAX(a) else { return CellValue.nil }
                return CellValue(number: m)
            },
            "MEDIAN": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigDouble] else { return CellValue.nil }
                return CellValue(number: self.MEDIAN(a))
            },
            "MIN": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigDouble] else { return CellValue.nil }
                guard let m = self.MIN(a) else { return CellValue.nil }
                return CellValue(number: m)
            },
            "PERMUT": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigDouble] else { return CellValue.nil }
                guard a.count == 2 else { return CellValue.nil }
                let ints = a.map { $0.rounded().asInt() }
                guard let integers = ints as? [Int] else { return CellValue.nil }
                return CellValue(int: self.PERMUT(integers[0], integers[1]))
            },
            "PHI": { args in
                guard let f = args.first else { return CellValue.nil }
                guard let n = f.number else { return CellValue.nil }
                return CellValue(number: self.PHI(n))
            },
        ]
    }
}
