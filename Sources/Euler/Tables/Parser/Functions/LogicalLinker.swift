//
//  LogicalLinker.swift
//  Euler
//
//  Created by Arthur Guiot on 2020-06-10.
//

import Foundation

public extension Tables {
    /// Logical Formulas Functions (for parser)
    var logicalFormulas: [String:(([CellValue]) throws -> CellValue)] {
        return [
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
            }
        ]
    }
}
