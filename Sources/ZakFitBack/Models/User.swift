//
//  User.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Vapor
import Fluent

final class User: Model, @unchecked Sendable {
    static let schema = "user"
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: "first_name") var firstName: String
    @Field(key: "last_name") var lastName: String
    @Field(key: "email") var email: String
    @Field(key: "password") var password: String
    @Field(key: "is_admin") var isAdmin: Bool
    @Field(key: "birthday") var birthday: Date
    @Field(key: "height") var height: Int
    @Field(key: "weight") var width: Int
    @Field(key: "sex") var sex: Bool
    @Field(key: "bmr") var bmr: Int
    @Field(key: "goal_cals") var goal_cals: Int
    @Field(key: "goal_carbs") var goal_carbs: Int
    @Field(key: "goal_fats") var goal_fats: Int
    @Field(key: "goal_prots") var goal_prots: Int
    
    @Siblings(through: UserRestrictionPivot.self, from: \.$user, to: \.$restrictionType) var restrictionTypes: [RestrictionType]
    @Children(for: \.$user) var exercises: [Exercise]
    @Children(for: \.$user) var goalExercises: [GoalExercise]
    @Children(for: \.$user) var meals: [Meal]
    
    init() {}
}
