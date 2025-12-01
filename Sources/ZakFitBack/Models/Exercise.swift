//
//  Exercise.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Vapor
import Fluent

final class Exercise: Model, @unchecked Sendable {
    static let schema = "exercise"
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: "date") var date: Date
    @Field(key: "length") var length: Int
    @Field(key: "cals") var cals: Int
    
    @Parent(key: "id_user") var user: User
    @Parent(key: "id_exercise_type") var exerciseType: ExerciseType
    
    init() {}
    
    func toDTO() -> ExerciseResponseDTO {
        .init(
            id: self.id!,
            date: self.date,
            length: self.length,
            cals: self.cals,
            exerciseType: self.exerciseType.toListItemDTO()
        )
    }

}
