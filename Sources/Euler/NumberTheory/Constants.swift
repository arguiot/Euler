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
    return Constant.pi.value
}

/// The mathematical constant
///
/// The number e is a mathematical constant that is the base of the natural logarithm: the unique number whose natural logarithm is equal to one. It is approximately equal to 2.71828, and is the limit of (1 + 1/n)n as n approaches infinity, an expression that arises in the study of compound interest. It can also be calculated as the sum of the infinite series
///
public var e: BigNumber {
    return Constant.e.value
}
/// Exponential function
public func exp(_ r: BigNumber) -> BigNumber {
    if let d = r.asDouble() {
        return BigDouble(exp(d))
    }
    return e ** r
}

/// Mathematical constant object
public struct Constant {
    /// The name of the constant
    public var name: String
    /// Quick description of the constant
    public var description: String
    /// The value of the constant
    public var value: BigNumber
}
/// List of mathematical constants
public extension Constant {
    /// The mass in `kg` of alpha particles
    static let alphaParticleMass = Constant(name: "Alpha Particle Mass", description: "The mass in kg of alpha particles", value: BigNumber("6.64465675e-27")!)
    /// The mass in `kg` of an atom (see Wikipedia for more info)
    static let atomicMass = Constant(name: "Atomic Mass", description: "The mass in kg of an atom (see Wikipedia for more info)", value: BigNumber("1.660538921e-27")!)
    /// Avogadro constant in `mol^(-1)`
    static let Avogadro = Constant(name: "Avogadro", description: "Avogadro constant in mol^(-1)", value: BigNumber("6.02214129e23")!)
    /// Boltzmann constant in `J/K`
    static let Boltzmann = Constant(name: "Boltzmann", description: "Boltzmann constant in J/K", value: BigNumber("1.3806488e-23")!)
    /// Quantized unit of electrical conductance in `S`
    static let conductanceQuantum = Constant(name: "Conductance Quantum", description: "Quantized unit of electrical conductance in S", value: BigNumber("7.7480917346e-5")!)
    /// The mathematical constant
    static let e = Constant(name: "e", description: "The mathematical constant", value: BigNumber("2.718281828459045235")!)
    /// Earth to moon distance in `km`
    static let earth_moon = Constant(name: "Earth to Moon", description: "Earth to moon distance in km", value: BigNumber("384401")!)
    /// Earth to sun distance in `km`
    static let earth_sun = Constant(name: "Earth to Sun", description: "Earth to sun distance in km", value: BigNumber("1.496e8")!)
    /// Earth mass in `kg`
    static let earthMass = Constant(name: "Earth Mass", description: "Earth mass in kg", value: BigNumber("5.974e+24")!)
    /// Earth radius in `km`
    static let earthRadius = Constant(name: "Earth Radius", description: "Earth radius in km", value: BigNumber("6371")!)
    /// Vacuum permittivity in `F/m`
    static let electric = Constant(name: "Electric", description: "Vacuum permittivity in F/m", value: BigNumber("8.854187e-12")!)
    /// Electron mass in `kg`
    static let electronMass = Constant(name: "Electron Mass", description: "Electron mass in kg", value: BigNumber("9.10938291e-31")!)
    /// Elementary charge in `C`
    static let elementaryCharge = Constant(name: "Elementary Charge", description: "Elementary charge in C", value: BigNumber("1.602176565e-19")!)
    /// Euler–Mascheroni Gamma constant
    static let EulerGamma = Constant(name: "Euler Gamma", description: "Euler–Mascheroni Gamma constant", value: BigNumber("0.57721566490153286")!)
    /// Faraday constant in `C/mol`
    static let Faraday = Constant(name: "Faraday", description: "Faraday constant in C/mol", value: BigNumber("96485.3365")!)
    /// Fine structure constant
    static let fineStructure = Constant(name: "Fine Structure", description: "Fine structure constant", value: BigNumber("0.0072973525693")!)
    /// Golden ratio
    static let goldenRatio = Constant(name: "Golden Ratio", description: "Golden ratio", value: BigNumber("1.61803398874989484820")!)
    /// Standard gravity in `m/s^2`
    static let gravity = Constant(name: "Gravity", description: "Standard gravity in m/s^2", value: BigNumber("9.80665")!)
    /// Inverse fine structure constant
    static let inverseFineStructure = Constant(name: "Inverse Fine Structure", description: "Inverse fine structure constant", value: BigNumber("137.035999139")!)
    /// Vacuum permeability in `H/m`
    static let magnetic = Constant(name: "Magnetic", description: "Vacuum permeability in H/m", value: BigNumber("1.2566370614e-6")!)
    /// Magnetic flux quantum in `Wb`
    static let magneticFluxQuantum = Constant(name: "Magnetic Flux Quantum", description: "Magnetic flux quantum in Wb", value: BigNumber("2.067833831e-15")!)
    /// Gas constant in `J/(mol K)`
    static let molarGas = Constant(name: "Molar Gas", description: "Gas constant in J/(mol K)", value: BigNumber("8.3144621")!)
    /// Mass of the moon in `kg`
    static let moonMass = Constant(name: "Moon Mass", description: "Mass of the moon in kg", value: BigNumber("7.348e+22")!)
    /// Moon's radius in `km`
    static let moonRadius = Constant(name: "Moon Radius", description: "Moon's radius in km", value: BigNumber("1737.4")!)
    /// Mass of the neutron in `kg`
    static let neutronMass = Constant(name: "Neutron Mass", description: "Mass of the neutron in kg", value: BigNumber("1.674927211e-27")!)
    /// Newtonian constant of gravitation in `m3⋅kg−1⋅s−2`
    static let NewtonianGravitation = Constant(name: "Newtonian Gravitation", description: "Newtonian constant of gravitation in m3⋅kg-1⋅s-2", value: BigNumber("6.67428e-11")!)
    /// The mathematical constant
    static let pi = Constant(name: "pi", description: "The mathematical constant", value: BigNumber("3.141592653589793238")!)
    /// Planck constant in `J⋅s`
    static let Planck = Constant(name: "Planck", description: "Planck constant in J⋅s", value: BigNumber("6.62606957e-34")!)
    /// Proton mass divided by electron mass
    static let protonElectronMassRatio = Constant(name: "Proton Electron Mass Ratio", description: "Proton mass divided by electron mass", value: BigNumber("1836.15267247")!)
    /// Proton mass divided by neutron mass
    static let protonNeutronMassRatio = Constant(name: "Proton Neutron Mass Ratio", description: "Proton mass divided by neutron mass", value: BigNumber("0.99862347826")!)
    /// Proton mass in `kg`
    static let protonMass = Constant(name: "Proton Mass", description: "Proton mass in kg", value: BigNumber("1.672621777e-27")!)
    /// Rydberg constant in `m^-1`
    static let Rydberg = Constant(name: "Rydberg", description: "Rydberg constant in m^-1", value: BigNumber("10973731.568539")!)
    /// Speed of light in `m/s`
    static let speedOfLight = Constant(name: "Speed of Light", description: "Speed of light in m/s", value: BigNumber("299792458")!)
    /// Speed of sound in `m/s`
    static let speedOfSound = Constant(name: "Speed of Sound", description: "Speed of sound in m/s", value: BigNumber("340.29")!)
    /// The square root of 2
    static let sqrt2 = Constant(name: "sqrt(2)", description: "The square root of 2", value: BigNumber("1.41421356237309504880")!)
    /// Stefan–Boltzmann constant in `W⋅m−2⋅K−4`
    static let StefanBoltzmann = Constant(name: "Stefan Boltzmann", description: "Stefan–Boltzmann constant in W⋅m-2⋅K-4", value: BigNumber("5.670373e-8")!)
    /// Mass of the sun in `kg`
    static let sunMass = Constant(name: "Sun Mass", description: "Mass of the sun in kg", value: BigNumber("1.98892e+30")!)
    /// Sun's radius in `km`
    static let sunRadius = Constant(name: "Sun Radius", description: "Sun's radius in km", value: BigNumber("695700")!)
    /// Dwayne "The Rock" Johnson's mass in `kg`
    static let theRockMass = Constant(name: "The Rock Mass", description: "Dwayne \"The Rock\" Johnson's mass in kg. Can't mathematician have the sense of humour?", value: BigNumber("124.73790175")!)
    /// Thomson cross section in `m2`
    static let Thomson = Constant(name: "Thomson", description: "Thomson cross section in m2", value: BigNumber("0.6652458734e-28")!)
    /// The answer to life, the universe, and everything
    static let UltimateAnswer = Constant(name: "Ultimate Answer", description: "The answer to life, the universe, and everything", value: BigNumber("42")!)
    /// The coldness of the universe in `C`
    static let universeTemperature = Constant(name: "Universe Temperature", description: "The coldness of the universe in C", value: BigNumber("-273.15")!)

    /// The list of all constants
    static let all: [Constant] = [
        .alphaParticleMass,
        .atomicMass,
        .Avogadro,
        .Boltzmann,
        .conductanceQuantum,
        .e,
        .earth_moon,
        .earth_sun,
        .earthMass,
        .earthRadius,
        .electric,
        .electronMass,
        .elementaryCharge,
        .EulerGamma,
        .Faraday,
        .fineStructure,
        .goldenRatio,
        .gravity,
        .inverseFineStructure,
        .magnetic,
        .magneticFluxQuantum,
        .molarGas,
        .moonMass,
        .moonRadius,
        .neutronMass,
        .NewtonianGravitation,
        .pi,
        .Planck,
        .protonElectronMassRatio,
        .protonNeutronMassRatio,
        .protonMass,
        .Rydberg,
        .speedOfLight,
        .speedOfSound,
        .sqrt2,
        .StefanBoltzmann,
        .sunMass,
        .sunRadius,
        .theRockMass,
        .Thomson,
        .UltimateAnswer,
        .universeTemperature
    ]
}
