//
//  MealTypeController.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 25/11/2025.
//

import Vapor
import Fluent
import JWT

struct MealTypeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let mealTypes = routes.grouped("mealTypes")
        
        let protected = mealTypes.grouped(JWTMiddleware()).groupedOpenAPI(auth: .bearer())

        protected.get(use: self.index)
            .openAPI(
                summary: "Get meal types",
                description: "Get a list of all meal types available",
                response: .type([MealTypeDTO].self)
            )
        protected.post(use: self.create)
            .openAPI(
                summary: "Create meal type",
                description: "Create a new meal type (admins only)",
                body: .type(MealTypeDTO.self),
                response: .type(MealTypeDTO.self)
                )
        protected.group(":mealTypeID") { mealType in
            mealType.delete(use: self.delete)
                .openAPI(
                    summary: "Delete meal type",
                    description: "Delete a meal type by ID (admins only)",
                    response: .type(HTTPStatus.self)
                )
        }
    }
    
    @Sendable
    func index(req: Request) async throws -> [MealTypeDTO] {
        return try await MealType.query(on: req.db).all().map { $0.toDTO() }
    }
    
    @Sendable
    func create(req: Request) async throws -> MealTypeDTO {
        // Check if user is admin
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        guard user.isAdmin == true else {
            throw Abort(.forbidden)
        }
        
        let newType = try req.content.decode(MealTypeDTO.self).toModel()
        try await newType.save(on: req.db)
        return newType.toDTO()
    }
    
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        // Check if user is admin
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        guard user.isAdmin == true else {
            throw Abort(.forbidden)
        }

        guard let type = try await MealType.find(req.parameters.get("mealTypeID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await type.delete(on: req.db)
        return .noContent
    }
}
