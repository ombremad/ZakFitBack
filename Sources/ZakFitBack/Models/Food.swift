//
//  Food.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Vapor
import Fluent

final class Food: Model, @unchecked Sendable {
    static let schema = "food"
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: "weight") var weight: Int
    @OptionalField(key: "quantity") var quantity: Int?
    
    @Parent(key: "id_food_type") var foodType: FoodType
    @Parent(key: "id_meal") var meal: Meal
    
    init() {}
}
