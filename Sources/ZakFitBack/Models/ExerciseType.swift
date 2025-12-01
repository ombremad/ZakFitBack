//
//  ExerciseType.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Vapor
import Fluent

final class ExerciseType: Model, @unchecked Sendable {
    static let schema = "exercise_type"
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: "name") var name: String
    @Field(key: "icon") var icon: String
    @Field(key: "cals_per_minute") var calsPerMinute: Int
    @Field(key: "level") var level: Int
    
    @Children(for: \.$exerciseType) var exercises: [Exercise]
    @Children(for: \.$exerciseType) var goalExercises: [GoalExercise]
    
    init() {}
    
    func toDTO() -> ExerciseTypeResponseDTO {
        .init(
            id: self.id!,
            name: self.name,
            icon: self.icon,
            calsPerMinute: self.calsPerMinute,
            level: self.level
        )
    }
    
    func toListItemDTO() -> ExerciseTypeListItemDTO {
        .init(
            name: self.name,
            icon: self.icon
        )
    }
}
