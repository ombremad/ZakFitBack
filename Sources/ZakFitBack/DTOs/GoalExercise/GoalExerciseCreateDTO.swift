//
//  GoalExerciseCreateDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 28/11/2025.
//

import Vapor
import Fluent

struct GoalExerciseCreateDTO: Content {
    var id: UUID?
    let frequency: Int
    let length: Int?
    let cals: Int?
    let exerciseTypeId: UUID
    
    func toModel(on db: any Database) async throws -> GoalExercise {
        let model = GoalExercise()
        model.id = id ?? UUID()
        model.frequency = frequency
        model.length = length
        model.cals = cals
        model.$exerciseType.id = exerciseTypeId
        
        return model
    }
}
