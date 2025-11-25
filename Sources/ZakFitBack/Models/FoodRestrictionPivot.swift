//
//  FoodRestrictionPivot.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Vapor
import Fluent

final class FoodRestrictionPivot: Model, @unchecked Sendable {
    static let schema = "food_restriction"
    
    @ID(key: .id) var id: UUID?
    @Parent(key: "id_food_type") var foodType: FoodType
    @Parent(key: "id_restriction_type") var restrictionType: RestrictionType
    
    init() {}
    
    init(id: UUID? = nil, foodTypeID: FoodType.IDValue, restrictionTypeID: RestrictionType.IDValue) {
        self.id = id
        self.$foodType.id = foodTypeID
        self.$restrictionType.id = restrictionTypeID
    }
}
