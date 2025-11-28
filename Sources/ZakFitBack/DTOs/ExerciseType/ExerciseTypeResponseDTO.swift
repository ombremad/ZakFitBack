//
//  ExerciseTypeResponseDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 28/11/2025.
//

import Vapor
import Fluent

struct ExerciseTypeResponseDTO: Content {
    let id: UUID
    let name: String
    let icon: String
    let calsPerMinute: Int
    let level: Int
    
    init(id: UUID, name: String, icon: String, calsPerMinute: Int, level: Int) {
        self.id = id
        self.name = name
        self.icon = icon
        self.calsPerMinute = calsPerMinute
        self.level = level
    }
}
