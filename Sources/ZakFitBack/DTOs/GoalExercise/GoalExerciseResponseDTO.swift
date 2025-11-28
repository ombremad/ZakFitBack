//
//  GoalExerciseResponseDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 28/11/2025.
//

import Vapor
import Fluent

struct GoalExerciseResponseDTO: Content {
    let id: UUID
    let frequency: Int
    let length: Int?
    let cals: Int?
    let exerciseType: ExerciseTypeResponseDTO
    
    init(from goalExercise: GoalExercise, exerciseType: ExerciseType) {
        self.id = goalExercise.id!
        self.frequency = goalExercise.frequency
        self.length = goalExercise.length
        self.cals = goalExercise.cals
        self.exerciseType = exerciseType.toDTO()
    }
}
