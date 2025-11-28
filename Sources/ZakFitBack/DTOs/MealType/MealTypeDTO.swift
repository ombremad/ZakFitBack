//
//  MealTypeDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 25/11/2025.
//

import Vapor
import Fluent

struct MealTypeDTO: Content {
    var id: UUID?
    var name: String
    
    func toModel() -> MealType {
        let model = MealType()
        model.id = id ?? UUID()
        model.name = name
        return model
    }
}
