//
//  RestrictionType.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Vapor
import Fluent

final class RestrictionType: Model, @unchecked Sendable {
    static let schema = "restriction_type"
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: "name") var name: String
        
    @Siblings(through: UserRestrictionPivot.self, from: \.$restrictionType, to: \.$user) var users: [User]
    @Siblings(through: FoodRestrictionPivot.self, from: \.$restrictionType, to: \.$foodType) var foodTypes: [FoodType]
    
    init() {}
}
