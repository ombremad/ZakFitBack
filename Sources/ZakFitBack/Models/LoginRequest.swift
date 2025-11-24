//
//  LoginRequest.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Vapor

struct LoginRequest: Content {
    let email: String
    let password: String
}
