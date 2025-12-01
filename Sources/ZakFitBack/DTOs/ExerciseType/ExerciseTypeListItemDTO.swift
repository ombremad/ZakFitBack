//
//  ExerciseTypeListItemDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 01/12/2025.
//

import Vapor
import Fluent

struct ExerciseTypeListItemDTO: Content {
    let id: UUID
    let name: String
    let icon: String
    
    init(id: UUID, name: String, icon: String) {
        self.id = id
        self.name = name
        self.icon = icon
    }
}
