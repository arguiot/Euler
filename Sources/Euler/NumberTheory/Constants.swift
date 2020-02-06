//
//  Constants.swift
//  
//
//  Created by Arthur Guiot on 2020-01-11.
//

import Foundation

/// The mathematical constant
///
/// Originally defined as the ratio of a circle's circumference to its diameter, it now has various equivalent definitions and appears in many formulas in all areas of mathematics and physics. It is approximately equal to 3.14159. It has been represented by the Greek letter "π" since the mid-18th century, though it is also sometimes spelled out as "pi". It is also called Archimedes' constant.
///
public var pi: BigNumber {
    return BigNumber("3.141592653589793238")!
}

/// The mathematical constant
///
/// The number e is a mathematical constant that is the base of the natural logarithm: the unique number whose natural logarithm is equal to one. It is approximately equal to 2.71828, and is the limit of (1 + 1/n)n as n approaches infinity, an expression that arises in the study of compound interest. It can also be calculated as the sum of the infinite series
///
public var e: BigNumber {
    return BigNumber("2.718281828459045235")!
}
public func exp(_ r: BigNumber) -> BigNumber {
    if let d = r.asDouble() {
        return BigDouble(exp(d))
    }
    let a = BigNumber(constant: .e)
    return a ** r
}
/// A list of important mathematical and physical constants
public enum Constant: String {
    /// The mass in `kg` of alpha particles
    case alphaParticleMass = "6.64465675e-27"
    /// The mass in `kg` of an atom (see Wikipedia for more info)
    case atomicMass = "1.660538921e-27"
    /// Avogadro constant in `mol^(-1)`
    case Avogadro = "6.02214129e23"
    /// Boltzmann constant in `J/K`
    case Boltzmann = "1.3806488e-23"
    /// Quantized unit of electrical conductance in `S`
    case conductanceQuantum = "7.7480917346e-5"
    /// The mathematical constant
    case e = "2.7182818284590"
    /// Earth to moon distance in `km`
    case earth_moon = "384401"
    /// Earth to sun distance in `km`
    case earth_sun = "1.496e8"
    /// Earth mass in `kg`
    case earthMass = "5.974e+24"
    /// Earth radius in `km`
    case earthRadius = "6371"
    /// Vacuum permittivity in `F/m`
    case electric = "8.854187e-12"
    /// Electron mass in `kg`
    case electronMass = "9.10938291e-31"
    /// Elementary charge in `C`
    case elementaryCharge = "1.602176565e-19"
    /// Euler–Mascheroni Gamma constant
    case EulerGamma = "0.57721566490153286"
    /// Faraday constant in `C/mol`
    case Faraday = "96485.3365"
    /// Fine structure constant
    case fineStructure = "7.2973525698e-3"
    /// Golden ratio
    case goldenRatio = "1.61803398874989484820"
    /// Standard acceleration due to gravity constant in `m/s^2`
    case gravity = "9.80665"
    /// Invverse of fine structure constant
    case inverseFineStructure = "137.035999074"
    /// Vacuum permeability in `H/m`
    case magnetic = "1.25663706212e-6"
    /// Magnetic flux quantum constant in `Wb`
    case magneticFluxQuantum = "2.067833758e-15"
    /// Gas constant in `J/K/mol`
    case molarGas = "8.3144621"
    /// Mass of the moon in `kg`
    case moonMass = "7.348e22"
    /// Moon radius in `km`
    case moonRadius = "1738"
    /// Mass of neutron in `kg`
    case neutronMass = "1.674927351e-27"
    /// Newton's gravitational constant in `m3⋅kg−1⋅s−2`
    case NewtonGravitation = "6.67384e-11"
    /// The mathematical constant
    case pi = "3.14159265358979323846"
    /// Planck constant in `J s`
    case Planck = "6.62606957e-34"
    /// Proton mass divided by electron mass
    case proton_electronMassRatio = "1836.15267245"
    /// Proton mass divided by neutron mass
    case proton_neutronMassRatio = "0.99862347826"
    /// Proton mass in `kg`
    case protonMass = "1.672621777e-27"
    /// Rydberg constant in `m^(-1)`
    case Rydberg = "10973731.568539"
    /// Speed of light in `m/s`
    case speedOfLight = "299792458"
    /// Speed of sound in `m/s`
    case speedOfSound = "340.27"
    /// The square root of 2
    case sqrt2 = "1.41421356237309504880"
    /// Stefan-Boltzmann constant in `W m^(-2) K^(-4)`
    case Stefan_Boltzmann = "5.670373e-8"
    /// Mass of the sun in `kg`
    case sunMass = "1.989e30"
    /// Sun's radius in `km`
    case sunRadius = "695500"
    /// Dwayne Johnson's mass. Can't mathematician have the sense of humour?
    case TheRockMass = "124.73790175"
    /// Thomson Cross Section constant in `m^2`
    case ThomsonCrossSection = "0.6652458734e-28"
    /// The Answer to the Ultimate Question of Life, the Universe, and Everything.
    case UltimateAnswer = "42"
    /// The coldest temperature in the universe in `C`
    case zeroKelvin = "-273.15"
}
