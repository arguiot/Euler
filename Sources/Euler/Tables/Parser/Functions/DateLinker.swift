//
//  DateLinker.swift
//  Euler
//
//  Created by Arthur Guiot on 2020-06-10.
//

import Foundation

internal extension Tables {
    var dateFormulas: [String:(([CellValue]) throws -> CellValue)] {
        return [
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
            }
        ]
    }
}
