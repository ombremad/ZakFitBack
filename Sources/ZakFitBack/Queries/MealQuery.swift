//
//  MealQuert.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 01/12/2025.
//

import Vapor
import Fluent
import VaporToOpenAPI

@OpenAPIDescriptable
struct MealQuery: Content {
    // Filter meals from the last N days (1 = today only, 30 = last 30 days)
    var days: Int?
}
