//
//  UserPayload.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Foundation
import Vapor
import JWT

struct UserPayload: JWTPayload, Authenticatable {
    var id: UUID
    var expiration: Date

    func verify(using signer: JWTSigner) throws {
        if self.expiration < Date() {
            throw JWTError.invalidJWK // Throw an error if the token has expired
        }
    }

    init(id: UUID) {
        self.id = id
        self.expiration = Date().addingTimeInterval(3600 * 24 * 30) // Expire in 30 days
    }
}
