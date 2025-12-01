//
//  ExerciseQuery.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 01/12/2025.
//

import Vapor
import Fluent
import VaporToOpenAPI

@OpenAPIDescriptable
struct ExerciseQuery: Content {
    // Filter exercises from the last N days (1 = today only, 30 = last 30 days)
    var days: Int?
    
    // Filter by exercise type ID
    var exerciseType: UUID?
    
    // Filter exercises with at least this many minutes
    var lengthMin: Int?
    
    // Filter exercises with at most this many minutes
    var lengthMax: Int?
    
    // Sort type: accepts date, length, or activityType
    var sortBy: String?
    
    // Sort order: accepts ascending or descending (ascending by default)
    var sortOrder: String?
}
