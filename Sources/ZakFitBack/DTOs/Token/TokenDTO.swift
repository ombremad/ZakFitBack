//
//  TokenDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Vapor
import Fluent

struct TokenDTO: Content {
    let token: String

    init(_ token: String) {
        self.token = token
    }
}
