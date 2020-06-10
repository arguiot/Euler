//
//  EngineeringLinker.swift
//  Euler
//
//  Created by Arthur Guiot on 2020-06-10.
//

import Foundation

internal extension Tables {
    var engineeringFormulas: [String:(([CellValue]) throws -> CellValue)] {
        return [
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
            }
        ]
    }
}
