//
//  UserPatchDTO.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Vapor
import Fluent

struct UserPatchDTO: Content {
    let firstName: String?
    let lastName: String?
    let email: String?
    var password: String?
    let birthday: Date?
    let height: Int?
    let weight: Int?
    let sex: Bool?
    let bmr: Int?
    let physicalActivity: Int?
    let goalCals: Int?
    let goalCarbs: Int?
    let goalFats: Int?
    let goalProts: Int?
    
    var isEmpty: Bool {
        return firstName == nil &&
        lastName == nil &&
        email == nil &&
        password == nil &&
        birthday == nil &&
        height == nil &&
        weight == nil &&
        sex == nil &&
        bmr == nil &&
        physicalActivity == nil &&
        goalCals == nil &&
        goalCarbs == nil &&
        goalFats == nil &&
        goalProts == nil
    }
    
    func apply(to user: User) {
        if let val = firstName { user.firstName = val }
        if let val = lastName { user.lastName = val }
        if let val = email { user.email = val }
        if let val = password { user.password = val }
        if let val = birthday { user.birthday = val }
        if let val = height { user.height = val }
        if let val = weight { user.weight = val }
        if let val = sex { user.sex = val }
        if let val = bmr { user.bmr = val }
        if let val = physicalActivity { user.physicalActivity = val }
        if let val = goalCals { user.goalCals = val }
        if let val = goalCarbs { user.goalCarbs = val }
        if let val = goalFats { user.goalFats = val }
        if let val = goalProts { user.goalProts = val }
    }
}
