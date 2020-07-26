//
//  FinancialLinker.swift
//  Euler
//
//  Created by Arthur Guiot on 2020-06-10.
//

import Foundation

public extension Tables {
    /// Financial Formulas Functions (for parser)
    var financialFormulas: [String:(([CellValue]) throws -> CellValue)] {
        return [
            "ACCRINT": { args in
                let tmp = args.map { $0.number }
                guard let a = tmp as? [BigDouble] else { return CellValue.nil }
                guard a.count >= 4 else { return CellValue.nil }
                
                guard let issue = a[0].rounded().asInt() else { return CellValue.nil }
                guard let first = a[1].rounded().asInt() else { return CellValue.nil }
                guard let settlement = a[2].rounded().asInt() else { return CellValue.nil }
                let rate = a[3]
                if a.count == 4 {
                    return CellValue(number: try self.ACCRINT(issue, first, settlement, rate))
                }
                let par = a[4]
                if a.count == 5 {
                    return CellValue(number: try self.ACCRINT(issue, first, settlement, rate, par))
                }
                guard let frequency = a[5].rounded().asInt() else { return CellValue.nil }
                if a.count == 6 {
                    return CellValue(number: try self.ACCRINT(issue, first, settlement, rate, par, frequency))
                }
                guard let basis = a[6].rounded().asInt() else { return CellValue.nil }
                return CellValue(number: try self.ACCRINT(issue, first, settlement, rate, par, frequency, basis))
            }
        ]
    }
}
