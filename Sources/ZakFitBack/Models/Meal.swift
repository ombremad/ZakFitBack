//
//  Meal.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Vapor
import Fluent

final class Meal: Model, @unchecked Sendable {
    static let schema = "meal"
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: "date") var date: Date
    @Field(key: "cals") var cals: Int
    @Field(key: "carbs") var carbs: Int
    @Field(key: "fats") var fats: Int
    @Field(key: "prots") var prots: Int
    
    @Parent(key: "id_user") var user: User
    @Parent(key: "id_meal_type") var mealType: MealType
    @Children(for: \.$meal) var foods: [Food]
    
    init() {}
    
    func toDTO() -> MealResponseDTO {
        .init(
            id: self.id!,
            date: self.date,
            cals: self.cals,
            carbs: self.carbs,
            fats: self.fats,
            prots: self.prots,
            mealType: self.mealType.toDTO(),
            foods: self.foods.map { $0.toDTO() }
        )
    }
    
    func toListItemDTO() -> MealListItemDTO {
        .init(
            id: self.id!,
            date: self.date,
            cals: self.cals,
            carbs: self.carbs,
            fats: self.fats,
            prots: self.prots,
            mealTypeName: self.mealType.name
        )
    }
}
