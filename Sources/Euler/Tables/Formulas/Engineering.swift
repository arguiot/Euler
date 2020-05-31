//
//  Engineering.swift
//  Euler
//
//  Created by Arthur Guiot on 2020-05-30.
//

import Foundation

public extension Tables {
    // MARK: Engineering functions
    
    // MARK: Add Bessel functions
    /// Converts a binary number to decimal.
    /// - Parameter number: Input number to be converted (has to be composed of 1s and 0s)
    /// - Throws: If number isn't composed of 1s or 0s, the function will fail
    /// - Returns: The converted number
    func BIN2DEC(_ number: BigDouble) throws -> BigDouble {
        let str = number.decimalDescription
        guard let n = BigDouble(str, radix: 2) else { throw TablesError.Arguments }
        return n
    }
    
    /// Converts a binary number to hexadecimal.
    /// - Parameter number: Input number to be converted (has to be composed of 1s and 0s)
    /// - Throws: If number isn't composed of 1s or 0s, the function will fail
    /// - Returns: The converted number
    func BIN2HEX(_ number: BigDouble) throws -> String {
        let str = number.decimalDescription
        guard let n = BigDouble(str, radix: 2)?.rounded().asString(radix: 16) else { throw TablesError.Arguments }
        return n
    }
    
    /// Converts a binary number to octal.
    /// - Parameter number: Input number to be converted (has to be composed of 1s and 0s)
    /// - Throws: If number isn't composed of 1s or 0s, the function will fail
    /// - Returns: The converted number
    func BIN2OCT(_ number: BigDouble) throws -> BigDouble {
        let str = number.decimalDescription
        guard let n = BigDouble(str, radix: 2)?.rounded().asString(radix: 8) else { throw TablesError.Arguments }
        return BigDouble(n)! // We can force unwrap because it will always succeed
    }
    
    /// Returns a bitwise 'AND' of two numbers.
    func BITAND(_ lhs: BigInt, _ rhs: BigInt) -> BigInt {
        return lhs & rhs
    }
    
    /// Returns a bitwise 'OR' of two numbers.
    func BITOR(_ lhs: BigInt, _ rhs: BigInt) -> BigInt {
        return lhs | rhs
    }
    /// Returns a bitwise 'XOR' of two numbers.
    func BITXOR(_ lhs: BigInt, _ rhs: BigInt) -> BigInt {
        return lhs ^ rhs
    }
    
    /// Returns a number shifted left by the specified number of bits.
    /// - Parameters:
    ///   - n: Number must be an integer greater than or equal to 0.
    ///   - amount: Shift amount
    /// - Returns: Number shifted to the left
    func BITLSHIFT(_ n: BigInt, _ amount: BigInt) -> BigInt {
        return n << amount
    }
    
    /// Returns a number shifted right by the specified number of bits.
    /// - Parameters:
    ///   - n: Number must be an integer greater than or equal to 0.
    ///   - amount: Shift amount
    /// - Returns: Number shifted to the right
    func BITRSHIFT(_ n: BigInt, _ amount: BigInt) -> BigInt {
        return n >> amount
    }
    
    /// Converts a number from one measurement system to another. For example, CONVERT can translate a table of distances in miles to a table of distances in kilometers.
    /// - Parameters:
    ///   - n:  It is the value in `from_unit` units to convert.
    ///   - from_unit: It is the units for number.
    ///   - to_unit: The units for the result.
    func CONVERT(_ n: BigDouble, from_unit: String, to_unit: String) throws -> BigDouble {
        struct Unit {
            var name: String
            var symbol: String
            var alternate: [String]?
            var quantity: String
            var ISU: Bool
            var CONVERT: Bool
            var ratio: BigDouble
            
            init(_ name: String, _ symbol: String, _ alternate: [String]?, _ quantity: String, _ ISU: Bool, _ CONVERT: Bool, _ ratio: BigDouble) {
                self.name = name
                self.symbol = symbol
                self.alternate = alternate
                self.quantity = quantity
                self.ISU = ISU
                self.CONVERT = CONVERT
                self.ratio = ratio
            }
        }
        
        let units: [Unit] = [
            Unit("a.u. of action", "?", nil, "action", false, false, 1.05457168181818e-34),

            Unit("a.u. of charge", "e", nil, "electric_charge", false, false, 1.60217653141414e-19),

            Unit("a.u. of energy", "Eh", nil, "energy", false, false, 4.35974417757576e-18),

            Unit("a.u. of length", "a?", nil, "length", false, false, 5.29177210818182e-11),

            Unit("a.u. of mass", "m?", nil, "mass", false, false, 9.10938261616162e-31),

            Unit("a.u. of time", "?/Eh", nil, "time", false, false, 2.41888432650516e-17),

            Unit("admiralty knot", "admkn", nil, "speed", false, true, 0.514773333),

            Unit("ampere", "A", nil, "electric_current", true, false, 1),

            Unit("ampere per meter", "A/m", nil, "magnetic_field_intensity", true, false, 1),

            Unit("ångström", "Å", ["ang"], "length", false, true, 1e-10),

            Unit("are", "ar", nil, "area", false, true, 100),

            Unit("astronomical unit", "ua", nil, "length", false, false, 1.49597870691667e-11),

            Unit("bar", "bar", nil, "pressure", false, false, 100000),

            Unit("barn", "b", nil, "area", false, false, 1e-28),

            Unit("becquerel", "Bq", nil, "radioactivity", true, false, 1),

            Unit("bit", "bit", ["b"], "information", false, true, 1),

            Unit("btu", "BTU", ["btu"], "energy", false, true, 1055.05585262),

            Unit("byte", "byte", nil, "information", false, true, 8),

            Unit("candela", "cd", nil, "luminous_intensity", true, false, 1),

            Unit("candela per square metre", "cd/m?", nil, "luminance", true, false, 1),

            Unit("coulomb", "C", nil, "electric_charge", true, false, 1),

            Unit("cubic ångström", "ang3", ["ang^3"], "volume", false, true, 1e-30),

            Unit("cubic foot", "ft3", ["ft^3"], "volume", false, true, 0.028316846592),

            Unit("cubic inch", "in3", ["in^3"], "volume", false, true, 0.000016387064),

            Unit("cubic light-year", "ly3", ["ly^3"], "volume", false, true, 8.46786664623715e-47),

            Unit("cubic metre", "m?", nil, "volume", true, true, 1),

            Unit("cubic mile", "mi3", ["mi^3"], "volume", false, true, 4168181825.44058),

            Unit("cubic nautical mile", "Nmi3", ["Nmi^3"], "volume", false, true, 6352182208),

            Unit("cubic Pica", "Pica3", ["Picapt3", "Pica^3", "Picapt^3"], "volume", false, true, 7.58660370370369e-8),

            Unit("cubic yard", "yd3", ["yd^3"], "volume", false, true, 0.764554857984),

            Unit("cup", "cup", nil, "volume", false, true, 0.0002365882365),

            Unit("dalton", "Da", ["u"], "mass", false, false, 1.66053886282828e-27),

            Unit("day", "d", ["day"], "time", false, true, 86400),

            Unit("degree", "°", nil, "angle", false, false, 0.0174532925199433),

            Unit("degrees Rankine", "Rank", nil, "temperature", false, true, 0.555555555555556),

            Unit("dyne", "dyn", ["dy"], "force", false, true, 0.00001),

            Unit("electronvolt", "eV", ["ev"], "energy", false, true, 1.60217656514141),

            Unit("ell", "ell", nil, "length", false, true, 1.143),

            Unit("erg", "erg", ["e"], "energy", false, true, 1e-7),

            Unit("farad", "F", nil, "electric_capacitance", true, false, 1),

            Unit("fluid ounce", "oz", nil, "volume", false, true, 0.0000295735295625),

            Unit("foot", "ft", nil, "length", false, true, 0.3048),

            Unit("foot-pound", "flb", nil, "energy", false, true, 1.3558179483314),

            Unit("gal", "Gal", nil, "acceleration", false, false, 0.01),

            Unit("gallon", "gal", nil, "volume", false, true, 0.003785411784),

            Unit("gauss", "G", ["ga"], "magnetic_flux_density", false, true, 1),

            Unit("grain", "grain", nil, "mass", false, true, 0.0000647989),

            Unit("gram", "g", nil, "mass", false, true, 0.001),

            Unit("gray", "Gy", nil, "absorbed_dose", true, false, 1),

            Unit("gross registered ton", "GRT", ["regton"], "volume", false, true, 2.8316846592),

            Unit("hectare", "ha", nil, "area", false, true, 10000),

            Unit("henry", "H", nil, "inductance", true, false, 1),

            Unit("hertz", "Hz", nil, "frequency", true, false, 1),

            Unit("horsepower", "HP", ["h"], "power", false, true, 745.69987158227),

            Unit("horsepower-hour", "HPh", ["hh", "hph"], "energy", false, true, 2684519.538),

            Unit("hour", "h", ["hr"], "time", false, true, 3600),

            Unit("imperial gallon (U.K.)", "uk_gal", nil, "volume", false, true, 0.00454609),

            Unit("imperial hundredweight", "lcwt", ["uk_cwt", "hweight"], "mass", false, true, 50.802345),

            Unit("imperial quart (U.K)", "uk_qt", nil, "volume", false, true, 0.0011365225),

            Unit("imperial ton", "brton", ["uk_ton", "LTON"], "mass", false, true, 1016.046909),

            Unit("inch", "in", nil, "length", false, true, 0.0254),

            Unit("international acre", "uk_acre", nil, "area", false, true, 4046.8564224),

            Unit("IT calorie", "cal", nil, "energy", false, true, 4.1868),

            Unit("joule", "J", nil, "energy", true, true, 1),

            Unit("katal", "kat", nil, "catalytic_activity", true, false, 1),

            Unit("kelvin", "K", ["kel"], "temperature", true, true, 1),

            Unit("kilogram", "kg", nil, "mass", true, true, 1),

            Unit("knot", "kn", nil, "speed", false, true, 0.514444444444444),

            Unit("light-year", "ly", nil, "length", false, true, 9460730472580800),

            Unit("litre", "L", ["l", "lt"], "volume", false, true, 0.001),

            Unit("lumen", "lm", nil, "luminous_flux", true, false, 1),

            Unit("lux", "lx", nil, "illuminance", true, false, 1),

            Unit("maxwell", "Mx", nil, "magnetic_flux", false, false, 1e-18),

            Unit("measurement ton", "MTON", nil, "volume", false, true, 1.13267386368),

            Unit("meter per hour", "m/h", ["m/hr"], "speed", false, true, 0.00027777777777778),

            Unit("meter per second", "m/s", ["m/sec"], "speed", true, true, 1),

            Unit("meter per second squared", "m?s??", nil, "acceleration", true, false, 1),

            Unit("parsec", "pc", ["parsec"], "length", false, true, 30856775814671900),

            Unit("meter squared per second", "m?/s", nil, "kinematic_viscosity", true, false, 1),

            Unit("metre", "m", nil, "length", true, true, 1),

            Unit("miles per hour", "mph", nil, "speed", false, true, 0.44704),

            Unit("millimetre of mercury", "mmHg", nil, "pressure", false, false, 133.322),

            Unit("minute", "?", nil, "angle", false, false, 0.000290888208665722),

            Unit("minute", "min", ["mn"], "time", false, true, 60),

            Unit("modern teaspoon", "tspm", nil, "volume", false, true, 0.000005),

            Unit("mole", "mol", nil, "amount_of_substance", true, false, 1),

            Unit("morgen", "Morgen", nil, "area", false, true, 2500),

            Unit("n.u. of action", "?", nil, "action", false, false, 1.05457168181818e-34),

            Unit("n.u. of mass", "m?", nil, "mass", false, false, 9.10938261616162e-31),

            Unit("n.u. of speed", "c?", nil, "speed", false, false, 299792458),

            Unit("n.u. of time", "?/(me?c??)", nil, "time", false, false, 1.28808866778687e-21),

            Unit("nautical mile", "M", ["Nmi"], "length", false, true, 1852),

            Unit("newton", "N", nil, "force", true, true, 1),

            Unit("œrsted", "Oe ", nil, "magnetic_field_intensity", false, false, 79.5774715459477),

            Unit("ohm", "Ω", nil, "electric_resistance", true, false, 1),

            Unit("ounce mass", "ozm", nil, "mass", false, true, 0.028349523125),

            Unit("pascal", "Pa", nil, "pressure", true, false, 1),

            Unit("pascal second", "Pa?s", nil, "dynamic_viscosity", true, false, 1),

            Unit("pferdestärke", "PS", nil, "power", false, true, 735.49875),

            Unit("phot", "ph", nil, "illuminance", false, false, 0.0001),

            Unit("pica (1/6 inch)", "pica", nil, "length", false, true, 0.00035277777777778),

            Unit("pica (1/72 inch)", "Pica", ["Picapt"], "length", false, true, 0.00423333333333333),

            Unit("poise", "P", nil, "dynamic_viscosity", false, false, 0.1),

            Unit("pond", "pond", nil, "force", false, true, 0.00980665),

            Unit("pound force", "lbf", nil, "force", false, true, 4.4482216152605),

            Unit("pound mass", "lbm", nil, "mass", false, true, 0.45359237),

            Unit("quart", "qt", nil, "volume", false, true, 0.000946352946),

            Unit("radian", "rad", nil, "angle", true, false, 1),

            Unit("second", "?", nil, "angle", false, false, 0.00000484813681109536),

            Unit("second", "s", ["sec"], "time", true, true, 1),

            Unit("short hundredweight", "cwt", ["shweight"], "mass", false, true, 45.359237),

            Unit("siemens", "S", nil, "electrical_conductance", true, false, 1),

            Unit("sievert", "Sv", nil, "equivalent_dose", true, false, 1),

            Unit("slug", "sg", nil, "mass", false, true, 14.59390294),

            Unit("square ångström", "ang2", ["ang^2"], "area", false, true, 1e-20),

            Unit("square foot", "ft2", ["ft^2"], "area", false, true, 0.09290304),

            Unit("square inch", "in2", ["in^2"], "area", false, true, 0.00064516),

            Unit("square light-year", "ly2", ["ly^2"], "area", false, true, 8.95054210748189e+31),

            Unit("square meter", "m?", nil, "area", true, true, 1),

            Unit("square mile", "mi2", ["mi^2"], "area", false, true, 2589988.110336),

            Unit("square nautical mile", "Nmi2", ["Nmi^2"], "area", false, true, 3429904),

            Unit("square Pica", "Pica2", ["Picapt2", "Pica^2", "Picapt^2"], "area", false, true, 0.00001792111111111),

            Unit("square yard", "yd2", ["yd^2"], "area", false, true, 0.83612736),

            Unit("statute mile", "mi", nil, "length", false, true, 1609.344),

            Unit("steradian", "sr", nil, "solid_angle", true, false, 1),

            Unit("stilb", "sb", nil, "luminance", false, false, 0.0001),

            Unit("stokes", "St", nil, "kinematic_viscosity", false, false, 0.0001),

            Unit("stone", "stone", nil, "mass", false, true, 6.35029318),

            Unit("tablespoon", "tbs", nil, "volume", false, true, 0.0000147868),

            Unit("teaspoon", "tsp", nil, "volume", false, true, 0.00000492892),

            Unit("tesla", "T", nil, "magnetic_flux_density", true, true, 1),

            Unit("thermodynamic calorie", "c", nil, "energy", false, true, 4.184),

            Unit("ton", "ton", nil, "mass", false, true, 907.18474),

            Unit("tonne", "t", nil, "mass", false, false, 1000),

            Unit("U.K. pint", "uk_pt", nil, "volume", false, true, 0.00056826125),

            Unit("U.S. bushel", "bushel", nil, "volume", false, true, 0.03523907),

            Unit("U.S. oil barrel", "barrel", nil, "volume", false, true, 0.158987295),

            Unit("U.S. pint", "pt", ["us_pt"], "volume", false, true, 0.000473176473),

            Unit("U.S. survey mile", "survey_mi", nil, "length", false, true, 1609.347219),

            Unit("U.S. survey/statute acre", "us_acre", nil, "area", false, true, 4046.87261),

            Unit("volt", "V", nil, "voltage", true, false, 1),

            Unit("watt", "W", nil, "power", true, true, 1),

            Unit("watt-hour", "Wh", ["wh"], "energy", false, true, 3600),

            Unit("weber", "Wb", nil, "magnetic_flux", true, false, 1),

            Unit("yard", "yd", nil, "length", false, true, 0.9144),

            Unit("year", "yr", nil, "time", false, true, 31557600)

        ]
        
        struct BinaryPrefix {
            var name: String
            var power: Int
            var value: BN
            var abbreviation: String
            var derived: String
            init(_ name: String, _ power: Int, _ value: BN, _ abbreviation: String, _ derived: String) {
                self.name = name
                self.power = power
                self.value = value
                self.abbreviation = abbreviation
                self.derived = derived
            }
        }
        
        let binary_prefixes: [String: BinaryPrefix] = [
            "Yi": BinaryPrefix("yobi", 80, BN("1208925819614629174706176")!, "Yi", "yotta"),
            "Zi": BinaryPrefix("zebi", 70, BN("1180591620717411303424")!, "Zi", "zetta"),
            "Ei": BinaryPrefix("exbi", 60, 1152921504606846976, "Ei", "exa"),
            "Pi": BinaryPrefix("pebi", 50, 1125899906842624, "Pi", "peta"),
            "Ti": BinaryPrefix("tebi", 40, 1099511627776, "Ti", "tera"),
            "Gi": BinaryPrefix("gibi", 30, 1073741824, "Gi", "giga"),
            "Mi": BinaryPrefix("mebi", 20, 1048576, "Mi", "mega"),
            "ki": BinaryPrefix("kibi", 10, 1024, "ki", "kilo")
        ]
        
        struct UnitPrefix {
            var name: String
            var multiplier: BigDouble
            var abbreviation: String
            init(_ name: String, _ multiplier: Double,_ abbreviation: String) {
                self.name = name
                self.multiplier = BigNumber(multiplier)
                self.abbreviation = abbreviation
            }
        }
        
        let unit_prefixes: [String: UnitPrefix] = [
            "Y": UnitPrefix("yotta", 1e+24, "Y"),
            "Z": UnitPrefix("zetta", 1e+21, "Z"),
            "E": UnitPrefix("exa", 1e+18, "E"),
            "P": UnitPrefix("peta", 1e+15, "P"),
            "T": UnitPrefix("tera", 1e+12, "T"),
            "G": UnitPrefix("giga", 1e+09, "G"),
            "M": UnitPrefix("mega", 1e+06, "M"),
            "k": UnitPrefix("kilo", 1e+03, "k"),
            "h": UnitPrefix("hecto", 1e+02, "h"),
            "e": UnitPrefix("dekao", 1e+01, "e"),
            "d": UnitPrefix("deci", 1e-01, "d"),
            "c": UnitPrefix("centi", 1e-02, "c"),
            "m": UnitPrefix("milli", 1e-03, "m"),
            "u": UnitPrefix("micro", 1e-06, "u"),
            "n": UnitPrefix("nano", 1e-09, "n"),
            "p": UnitPrefix("pico", 1e-12, "p"),
            "f": UnitPrefix("femto", 1e-15, "f"),
            "a": UnitPrefix("atto", 1e-18, "a"),
            "z": UnitPrefix("zepto", 1e-21, "z"),
            "y": UnitPrefix("yocto", 1e-24, "y")
        ]
        
        var from: Unit? = nil
        var to: Unit? = nil
        var base_from_unit = from_unit
        var base_to_unit = to_unit
        var from_multiplier: BN = 1
        var to_multiplier: BN = 1
        var alt: [String]
        
        for unit in units {
            alt = unit.alternate ?? [String]()
            if unit.symbol == base_from_unit || alt.contains(base_from_unit) {
                from = unit
            }
            if unit.symbol == base_to_unit || alt.contains(base_to_unit) {
                to = unit
            }
        }
        
        if from == nil {
            let from_binary_prefix = binary_prefixes[from_unit.substring(with: 0..<2)];
            var from_unit_prefix = unit_prefixes[from_unit.substring(with: 0..<1)];

            // Handle dekao unit prefix (only unit prefix with two characters)
            if (from_unit.prefix(2) == "da") {
              from_unit_prefix = UnitPrefix("dekao", 1e+01, "da")
            }

            // Handle binary prefixes first (so that 'Yi' is processed before 'Y')
            if ((from_binary_prefix) != nil) {
                from_multiplier = from_binary_prefix?.value ?? 1;
                base_from_unit = from_unit.substring(from: 2);
            } else if ((from_unit_prefix) != nil) {
                from_multiplier = from_unit_prefix?.multiplier ?? 1;
                base_from_unit = from_unit.substring(from: from_unit_prefix?.abbreviation.count ?? 0);
            }

            // Lookup from unit
            for unit in units {
                alt = unit.alternate ?? [String]()
                if unit.symbol == base_from_unit || alt.contains(base_from_unit) {
                    from = unit
                }
            }
        }
        
        if to == nil {
            let to_binary_prefix = binary_prefixes[to_unit.substring(with: 0..<2)];
            var to_unit_prefix = unit_prefixes[to_unit.substring(with: 0..<1)];

            // Handle dekao unit prefix (only unit prefix with two characters)
            if (to_unit.prefix(2) == "da") {
              to_unit_prefix = UnitPrefix("dekao", 1e+01, "da")
            }

            // Handle binary prefixes first (so that 'Yi' is processed before 'Y')
            if ((to_binary_prefix) != nil) {
                to_multiplier = to_binary_prefix?.value ?? 1;
                base_to_unit = to_unit.substring(from: 2);
            } else if ((to_unit_prefix) != nil) {
                to_multiplier = to_unit_prefix?.multiplier ?? 1;
                base_to_unit = to_unit.substring(from: to_unit_prefix?.abbreviation.count ?? 0);
            }

            // Lookup from unit
            for unit in units {
                alt = unit.alternate ?? [String]()
                if unit.symbol == base_to_unit || alt.contains(base_to_unit) {
                    from = unit
                }
            }
        }
        
        guard from != nil && to != nil else { throw TablesError.Arguments }
        guard from?.quantity == to?.quantity else { throw TablesError.NULL }
        
        return n * from!.ratio * from_multiplier / (to!.ratio * to_multiplier)
    }
}
