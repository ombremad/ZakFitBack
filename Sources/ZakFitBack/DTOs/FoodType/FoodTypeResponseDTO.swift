//
//  FoodTypeResponseDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 27/11/2025.
//

import Vapor
import Fluent

struct FoodTypeResponseDTO: Content {
    let id: UUID
    let name: String
    let calsRatio: Int
    let carbsRatio: Int
    let fatsRatio: Int
    let protsRatio: Int
    let weightPerServing: Int?
    let mealTypes: [String]
    let restrictionTypes: [String]
    
    init(from foodType: FoodType, mealTypes: [MealType], restrictionTypes: [RestrictionType]) {
        self.id = foodType.id!
        self.name = foodType.name
        self.calsRatio = foodType.calsRatio
        self.carbsRatio = foodType.carbsRatio
        self.fatsRatio = foodType.fatsRatio
        self.protsRatio = foodType.protsRatio
        self.weightPerServing = foodType.weightPerServing
        self.mealTypes = mealTypes.map { $0.name }
        self.restrictionTypes = restrictionTypes.map { $0.name }
    }
}
