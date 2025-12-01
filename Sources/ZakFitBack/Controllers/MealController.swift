//
//  MealController.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 28/11/2025.
//

import Vapor
import Fluent
import JWT
import VaporToOpenAPI

struct MealController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let meals = routes.grouped("meals")
        
        let protected = meals.grouped(JWTMiddleware()).groupedOpenAPI(auth: .bearer())
        protected.get(use: self.index)
            .openAPI(
                summary: "Get meals",
                description: "Get a list of all meals for user",
                response: .type([MealListItemDTO].self)
            )
        protected.post(use: self.create)
            .openAPI(
                summary: "Create meal",
                description: "Create a new meal for user",
                body: .type(MealCreateDTO.self),
                response: .type(MealResponseDTO.self)
            )
        protected.group(":mealID") { meal in
            meal.get(use: self.get)
                .openAPI(
                    summary: "Get a meal type",
                    description: "Get all details on a single meal",
                    response: .type(MealResponseDTO.self)
                )
            meal.delete(use: self.delete)
                .openAPI(
                    summary: "Delete meal",
                    description: "Delete a meal belonging to the user",
                    response: .type(HTTPStatus.self)
                )
        }
    }
    
    @Sendable
    func index(req: Request) async throws -> [MealListItemDTO] {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }

        let meals = try await Meal.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .with(\.$mealType)
            .sort(\.$date, .descending)
            .all()

        return meals.map { $0.toListItemDTO() }
    }
    
    @Sendable
    func get(req: Request) async throws -> MealResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }

        guard let meal = try await Meal.find(req.parameters.get("mealID"), on: req.db) else {
            throw Abort(.notFound)
        }

        guard meal.$user.id == user.id else {
            throw Abort(.forbidden)
        }
        
        try await meal.$mealType.load(on: req.db)
        try await meal.$foods.load(on: req.db)
        
        return meal.toDTO()
    }
    
    @Sendable
    func create(req: Request) async throws -> MealResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        let dto = try req.content.decode(MealCreateDTO.self)
        let meal = try await dto.toModel(on: req.db, userId: user.id!)

        try await meal.$mealType.load(on: req.db)
        try await meal.$foods.load(on: req.db)
        
        for food in meal.foods {
            try await food.$foodType.load(on: req.db)
            try await food.foodType.$mealTypes.load(on: req.db)
            try await food.foodType.$restrictionTypes.load(on: req.db)
        }
        
        return meal.toDTO()
    }
    
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }

        guard let meal = try await Meal.find(req.parameters.get("mealID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        guard meal.$user.id == user.id else {
            throw Abort(.forbidden)
        }
        
        try await meal.delete(on: req.db)
        return .noContent
    }
}
