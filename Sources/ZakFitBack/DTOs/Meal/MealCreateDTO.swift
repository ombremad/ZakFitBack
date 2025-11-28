//
//  MealCreateDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 28/11/2025.
//

import Vapor
import Fluent

struct MealCreateDTO: Content {
    var id: UUID?
    let date: Date
    let cals: Int
    let mealTypeId: UUID
    let foods: [FoodCreateDTO]
    
    func toModel(on db: any Database, userId: UUID) async throws -> Meal {
        let model = Meal()
        model.id = id ?? UUID()
        model.date = date
        model.cals = cals
        model.$mealType.id = mealTypeId
        model.$user.id = userId
        
        try await model.save(on: db)
        
        // Create all food
        for var foodCreateDTO in foods {
            foodCreateDTO.mealId = model.id!
            _ = try await foodCreateDTO.toModel(on: db)
        }

        return model
    }
}
