//
//  UserRestrictionPivot.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Vapor
import Fluent

final class UserRestrictionPivot: Model, @unchecked Sendable {
    static let schema = "user_restriction"
    
    @ID(custom: "id", generatedBy: .user) var id: UUID?
    @Parent(key: "id_user") var user: User
    @Parent(key: "id_restriction_type") var restrictionType: RestrictionType
    
    init() {}
    
    init(id: UUID? = nil, userID: User.IDValue, restrictionTypeID: RestrictionType.IDValue) {
        self.id = id
        self.$user.id = userID
        self.$restrictionType.id = restrictionTypeID
    }
}
