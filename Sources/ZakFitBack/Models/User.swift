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
    @Field(key: "weight") var weight: Int
    @Field(key: "sex") var sex: Bool
    @Field(key: "bmr") var bmr: Int
    @Field(key: "goal_cals") var goalCals: Int
    @Field(key: "goal_carbs") var goalCarbs: Int
    @Field(key: "goal_fats") var goalFats: Int
    @Field(key: "goal_prots") var goalProts: Int
    
    @Siblings(through: UserRestrictionPivot.self, from: \.$user, to: \.$restrictionType) var restrictionTypes: [RestrictionType]
    @Children(for: \.$user) var exercises: [Exercise]
    @Children(for: \.$user) var goalExercises: [GoalExercise]
    @Children(for: \.$user) var meals: [Meal]
    
    init() {}

    init(
        id: UUID? = UUID(),
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        isAdmin: Bool,
        birthday: Date,
        height: Int,
        weight: Int,
        sex: Bool,
        bmr: Int,
        goalCals: Int,
        goalCarbs: Int,
        goalFats: Int,
        goalProts: Int
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.isAdmin = isAdmin
        self.birthday = birthday
        self.height = height
        self.weight = weight
        self.sex = sex
        self.bmr = bmr
        self.goalCals = goalCals
        self.goalFats = goalFats
        self.goalProts = goalProts
        self.goalCarbs = goalCarbs
    }
        
    func toDTO() -> UserPublicDTO {
        .init(
            id: self.id,
            firstName: self.firstName,
            lastName: self.lastName,
            email: self.email,
            birthday: self.birthday,
            height: self.height,
            weight: self.weight,
            sex: self.sex,
            bmr: self.bmr,
            goalCals: self.goalCals,
            goalCarbs: self.goalCarbs,
            goalFats: self.goalFats,
            goalProts: self.goalProts,
            restrictionTypes: self.restrictionTypes.map { $0.toDTO() }
        )
    }
}
