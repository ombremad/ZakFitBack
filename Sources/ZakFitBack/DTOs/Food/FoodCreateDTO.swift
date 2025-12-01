//
//  FoodDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 28/11/2025.
//

import Vapor
import Fluent

struct FoodCreateDTO: Content {
    var id: UUID?
    let weight: Int
    let quantity: Int?
    let foodTypeId: UUID
    var mealId: UUID?
    
    func toModel(on db: any Database) async throws -> Food {
        guard let _ = try await FoodType.find(foodTypeId, on: db) else {
            throw Abort(.badRequest, reason: "FoodType with id '\(foodTypeId)' does not exist")
        }
        
        let model = Food()
        model.id = id ?? UUID()
        model.weight = weight
        model.quantity = quantity
        model.$foodType.id = foodTypeId
        model.$meal.id = mealId!
        
        try await model.save(on: db)
        return model
    }
}
