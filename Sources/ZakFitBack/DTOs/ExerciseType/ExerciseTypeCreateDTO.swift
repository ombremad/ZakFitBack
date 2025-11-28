//
//  ExerciseTypeCreateDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 28/11/2025.
//

import Vapor
import Fluent

struct ExerciseTypeCreateDTO: Content {
    var id: UUID?
    let name: String
    let icon: String
    let calsPerMinute: Int
    let level: Int
    
    func toModel(on db: any Database) async throws -> ExerciseType {
        let model = ExerciseType()
        model.id = id ?? UUID()
        model.name = name
        model.icon = icon
        model.calsPerMinute = calsPerMinute
        model.level = level
        
        try await model.save(on: db)
        return model
    }
}
