//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-03-09.
//

import Foundation
/// A structure for storing and interacting with the value contained by a `Tables` cell
public struct CellValue {
    /// The number value of the cell
    public var number: BigNumber?
    /// The string value of the cell
    public var string: String?
    /// The boolean value of the cell
    public var boolean: Bool?
    /// The type of the structure
    public var type: Type
    
    static public var `nil`: CellValue {
        var v = CellValue(boolean: false)
        v.type = .error
        return v
    }
    
    /// Initialize the structure for a number
    public init(number: BigNumber) {
        self.type = .number
        self.number = number
    }
    /// Initialize the structure for an integer
    public init(int: BigInt) {
        self.init(number: BigDouble(int))
    }
    /// Initialize the structure for a string
    public init(string: String) {
        self.type = .string
        self.string = string
    }
    /// Initialize the structure for a boolean
    public init(boolean: Bool) {
        self.type = .bool
        self.boolean = boolean
    }
    /// The type of the value contained by the cell
    public enum `Type` {
        case number
        case string
        case bool
        case error
    }
    /// Gives the string representation of the `CellValue`
    public var description: String? {
        switch self.type {
        case .number:
            return self.number?.description
        case .string:
            return self.string
        case .bool:
            return self.boolean?.description
        default:
            return nil
        }
    }
}

extension CellValue: Hashable {
    /// Equatable implementation
    public static func == (lhs: CellValue, rhs: CellValue) -> Bool {
        return  lhs.type == rhs.type &&
                lhs.number == rhs.number &&
                lhs.string == rhs.string &&
                lhs.boolean == rhs.boolean
    }
    
//    public init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        number = try values.decode(BigDouble.self, forKey: .number)
//        string = try values.decode(String.self, forKey: .string)
//        boolean = try values.decode(Bool.self, forKey: .boolean)
//
//        type = try values.decode(CellValue.Type.self, forKey: .type)
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case type
//
//        case number
//        case string
//        case boolean
//    }
    /// Hashable implementation
    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(number)
        hasher.combine(string)
        hasher.combine(boolean)
    }
}
