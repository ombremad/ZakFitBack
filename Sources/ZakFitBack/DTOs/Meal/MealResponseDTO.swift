//
//  MealResponseDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 28/11/2025.
//

import Vapor
import Fluent

struct MealResponseDTO: Content {
    let id: UUID
    let date: Date
    let cals: Int
    let mealType: MealTypeDTO
    let foods: [FoodResponseDTO]
}
