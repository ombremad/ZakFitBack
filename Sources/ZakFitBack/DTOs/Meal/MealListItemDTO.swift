//
//  MealListItemDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 28/11/2025.
//

import Vapor
import Fluent

struct MealListItemDTO: Content {
    let id: UUID
    let date: Date
    let cals: Int
    let mealTypeName: String
}
