//
//  FoodType.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Vapor
import Fluent

final class FoodType: Model, @unchecked Sendable {
    static let schema = "food_type"
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: "name") var name: String
    @Field(key: "cals_ratio") var calsRatio: Int
    @Field(key: "carbs_ratio") var carbsRatio: Int
    @Field(key: "fats_ratio") var fatsRatio: Int
    @Field(key: "prots_ratio") var protsRatio: Int
    @OptionalField(key: "weight_per_serving") var weightPerServing: Int?
    
    @Siblings(through: FoodMealTypePivot.self, from: \.$foodType, to: \.$mealType) var mealTypes: [MealType]
    @Siblings(through: FoodRestrictionPivot.self, from: \.$foodType, to: \.$restrictionType) var restrictionTypes: [RestrictionType]
    @Children(for: \.$foodType) var foods: [Food]
    
    init() {}
}
