//
//  FoodTypeQuery.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 28/11/2025.
//

import Vapor
import Fluent
import VaporToOpenAPI

@OpenAPIDescriptable
struct FoodTypeQuery: Content {
    // Meal type names.
    var mealTypes: [String]?
    
    // Restriction type names. Reverse-filter: results only include food that do not match any restriction.
    var restrictionTypes: [String]?
}
