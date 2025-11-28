//
//  FoodResponseDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 28/11/2025.
//

import Vapor
import Fluent

struct FoodResponseDTO: Content {
    let id: UUID
    let weight: Int
    let quantity: Int?
}
