//
//  UserCreateDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Vapor
import Fluent

struct UserCreateDTO: Content {
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    var birthday: Date
    var height: Int
    var weight: Int
    var sex: Bool
    var bmr: Int
    var goalCals: Int
    var goalCarbs: Int
    var goalFats: Int
    var goalProts: Int
    
    func toModel() -> User {
        let model = User()
        
        model.id = UUID()
        model.firstName = firstName
        model.lastName = lastName
        model.email = email
        model.password = password
        model.isAdmin = false
        model.birthday = birthday
        model.height = height
        model.weight = weight
        model.sex = sex
        model.bmr = bmr
        model.goalCals = goalCals
        model.goalCarbs = goalCarbs
        model.goalFats = goalFats
        model.goalProts = goalProts
        
        return model
    }
    
}
