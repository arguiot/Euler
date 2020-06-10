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
        ]
    }
}
