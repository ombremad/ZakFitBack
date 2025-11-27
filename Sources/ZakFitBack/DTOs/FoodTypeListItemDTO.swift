//
//  FoodTypeListItemDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 27/11/2025.
//

import Vapor
import Fluent

struct FoodTypeListItemDTO: Content {
    let id: UUID
    let name: String
    
    init(from foodType: FoodType) {
        self.id = foodType.id!
        self.name = foodType.name
    }
}
