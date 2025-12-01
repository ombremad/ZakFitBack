//
//  ExerciseTypeListItemDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 01/12/2025.
//

import Vapor
import Fluent

struct ExerciseTypeListItemDTO: Content {
    let name: String
    let icon: String
    
    init(name: String, icon: String) {
        self.name = name
        self.icon = icon
    }
}
