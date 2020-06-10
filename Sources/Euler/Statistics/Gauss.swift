//
//  Gauss.swift
//  Euler
//
//  Created by Arthur Guiot on 2020-06-10.
//

import Foundation

public extension Statistics {
    // MARK: Gauss
    
    /// In mathematics, the error function (also called the Gauss error function), often denoted by erf, is a complex function of a complex variable defined as: `$$\operatorname{erf} z = \frac{2}{\sqrt\pi}\int_0^z e^{-t^2}\,dt$$`
    /// - Parameter x: Any number
    /// - Returns: `$\operatorname{erf}(x)$`
    static func ERF(at x: BigDouble) -> BigDouble {
        if x > 10 {
            return 1
        } else if x < -10 {
            return -1
        }
        
        guard let n = x.asDouble() else { return .zero }
        return BigDouble(erf(n))
    }
    
    /// Integral of the Gauss function
    ///
    /// Computed using: `$$ \int_{0}^{x}\frac{1}{\sqrt{2\pi}}*e^{-\frac{x^{2}}{2}}dx = \frac{1}{2}\cdot \operatorname{erf}\left( \frac{x}{\sqrt{2}} \right) $$`
    /// - Parameter x: Any number
    static func gauss(at x: BigDouble) -> BigDouble {
        let input = x / sqrt(2)
        let erf = ERF(at: input)
        return erf / 2
    }
}
