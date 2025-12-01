//
//  ExerciseResponseDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 01/12/2025.
//

import Vapor
import Fluent

struct ExerciseResponseDTO: Content {
    let id: UUID
    let date: Date
    let length: Int
    let cals: Int
    let exerciseType: ExerciseTypeListItemDTO
    
    init(id: UUID, date: Date, length: Int, cals: Int, exerciseType: ExerciseTypeListItemDTO) {
        self.id = id
        self.date = date
        self.length = length
        self.cals = cals
        self.exerciseType = exerciseType
    }
}
