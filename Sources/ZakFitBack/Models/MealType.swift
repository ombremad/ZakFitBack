//
//  MealType.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Vapor
import Fluent

final class MealType: Model, @unchecked Sendable {
    static let schema = "meal_type"
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: "name") var name: String
    
    @Siblings(through: FoodMealTypePivot.self, from: \.$mealType, to: \.$foodType) var foodTypes: [FoodType]
    @Children(for: \.$mealType) var meals: [Meal]
    
    init() {}
}
