//
//  Meal.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Vapor
import Fluent

final class Meal: Model, @unchecked Sendable {
    static let schema = "meal"
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: "date") var date: Date
    @Field(key: "carbs") var carbs: Int
    
    @Parent(key: "id_user") var user: User
    @Parent(key: "id_meal_type") var mealType: MealType
    @Children(for: \.$meal) var foods: [Food]
    
    init() {}
}
