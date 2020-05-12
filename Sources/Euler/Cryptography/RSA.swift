//
//  File.swift
//  
//
//  Created by Arthur Guiot on 2020-05-12.
//

import Foundation

/// RSA Cryptography system
public class RSA {
    var publicKey: Key
    var privateKey: Key
    public init(pub: Key, pri: Key) {
        self.publicKey = pub
        self.privateKey = pri
    }
    
    /// Experimental function. Very very slow, so you might want to use something else.
    /// - Parameter width: The number of bytes.
    public static func generatePrime(_ width: Int) -> BigInt {
        var p = BigInt.randomBigNumber(bits: width)
        if p.isEven() {
            p -= 1
        }
        while !p.millerRabin(accuracy: 10) {
            p += 2
        }
        return p
    }
    
    public typealias Key = (modulus: BigInt, exponent: BigInt)
    
    
    /// Produce an RSA public/private keypair
    /// - Parameters:
    ///   - p: Prime number
    ///   - q: Prime number
    public static func genKeys(p: BigInt, q: BigInt) -> (pub: Key, pri: Key) {
        let n = p * q
        let e: BigInt = 65537
        let phi = (p - 1) * (q - 1)
        let d = inverse(e, phi)!
        let publicKey: Key = (n, e)
        let privateKey: Key = (n, d)
        
        return (publicKey, privateKey)
    }
}
