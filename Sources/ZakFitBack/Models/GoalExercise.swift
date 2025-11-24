//
//  GoalExercise.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Vapor
import Fluent

final class GoalExercise: Model, @unchecked Sendable {
    static let schema = "goal_exercise"
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: "frequency") var frequency: Int
    @Field(key: "length") var length: Int
    @Field(key: "cals") var cals: Int
    
    @Parent(key: "id_user") var user: User
    @Parent(key: "id_exercise_type") var exerciseType: ExerciseType
    
    init() {}
}
