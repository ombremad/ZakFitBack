//
//  RestrictionTypeDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 25/11/2025.
//

import Vapor
import Fluent

struct RestrictionTypeDTO: Content {
    var id: UUID?
    var name: String
    
    func toModel() -> RestrictionType {
        let model = RestrictionType()
        model.id = id ?? UUID()
        model.name = name
        return model
    }
}
