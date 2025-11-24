//
//  UserDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Vapor
import Fluent

struct UserPublicDTO: Content {
    var id: UUID?
    var firstName: String
    var lastName: String
    var email: String
}
