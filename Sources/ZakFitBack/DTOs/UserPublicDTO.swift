//
//  UserDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Vapor
import Fluent

struct UserPublicDTO: Content {
    let id: UUID?
    let firstName: String
    let lastName: String
    let email: String
    let birthday: Date
    let height: Int
    let weight: Int
    let sex: Bool
    let bmr: Int
    let goalCals: Int
    let goalCarbs: Int
    let goalFats: Int
    let goalProts: Int
}
