//
//  FoodMealTypePivot.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Vapor
import Fluent

final class FoodMealTypePivot: Model, @unchecked Sendable {
    static let schema = "food_meal_type"
    
    @ID(custom: "id", generatedBy: .user) var id: UUID?
    @Parent(key: "id_food_type") var foodType: FoodType
    @Parent(key: "id_meal_type") var mealType: MealType
    
    init() {}
    
    init(id: UUID? = nil, foodTypeID: FoodType.IDValue, mealTypeID: MealType.IDValue) {
        self.id = id
        self.$foodType.id = foodTypeID
        self.$mealType.id = mealTypeID
    }
}
