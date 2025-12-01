//
//  ExerciseCreateDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 01/12/2025.
//

import Vapor
import Fluent

struct ExerciseCreateDTO: Content {
    var id: UUID?
    let date: Date
    let length: Int
    let cals: Int
    let exerciseTypeId: UUID
    
    func toModel(on db: any Database) async throws -> Exercise {
        let model = Exercise()
        model.id = id ?? UUID()
        model.date = date
        model.length = length
        model.cals = cals
        model.$exerciseType.id = exerciseTypeId
        
        return model
    }
}
