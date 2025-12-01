//
//  FoodTypeCreateDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 27/11/2025.
//

import Vapor
import Fluent

struct FoodTypeCreateDTO: Content {
    var id: UUID?
    let name: String
    let calsRatio: Int
    let carbsRatio: Int
    let fatsRatio: Int
    let protsRatio: Int
    let weightPerServing: Int?
    let mealTypes: [String]
    let restrictionTypes: [String]
    
    func toModel(on db: any Database) async throws -> FoodType {
        var mealTypeModels: [MealType] = []
        for mealTypeName in mealTypes {
            guard let mealType = try await MealType.query(on: db)
                .filter(\.$name == mealTypeName)
                .first() else {
                throw Abort(.badRequest, reason: "MealType '\(mealTypeName)' not found")
            }
            mealTypeModels.append(mealType)
        }
        
        var restrictionTypeModels: [RestrictionType] = []
        for restrictionTypeName in restrictionTypes {
            guard let restrictionType = try await RestrictionType.query(on: db)
                .filter(\.$name == restrictionTypeName)
                .first() else {
                throw Abort(.badRequest, reason: "RestrictionType '\(restrictionTypeName)' not found")
            }
            restrictionTypeModels.append(restrictionType)
        }

        let model = FoodType()
        model.id = id ?? UUID()
        model.name = name
        model.calsRatio = calsRatio
        model.carbsRatio = carbsRatio
        model.fatsRatio = fatsRatio
        model.protsRatio = protsRatio
        model.weightPerServing = weightPerServing
        
        try await model.save(on: db)
        
        if !mealTypeModels.isEmpty {
            try await model.$mealTypes.attach(mealTypeModels, on: db)
        }
        
        if !restrictionTypeModels.isEmpty {
            try await model.$restrictionTypes.attach(restrictionTypeModels, on: db)
        }
        
        return model
    }
}
