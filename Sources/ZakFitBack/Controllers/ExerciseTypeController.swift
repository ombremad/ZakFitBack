//
//  ExerciseTypeController.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 28/11/2025.
//

import Vapor
import Fluent
import JWT
import VaporToOpenAPI

struct ExerciseTypeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let exerciseTypes = routes.grouped("exerciseTypes")
        
        let protected = exerciseTypes.grouped(JWTMiddleware()).groupedOpenAPI(auth: .bearer())
        
        protected.get(use: self.index)
            .openAPI(
                summary: "Get exercise types",
                description: "Get a list of all exercise types available",
                response: .type([ExerciseTypeResponseDTO].self)
            )
        protected.post(use: self.create)
            .openAPI(
                summary: "Create exercise types",
                description: "Create new exercise types, as bulk in an array (admins only)",
                body: .type([ExerciseTypeCreateDTO].self),
                response: .type([ExerciseTypeResponseDTO].self)
            )
        
        protected.group(":exerciseTypeID") { exerciseType in
            exerciseType.delete(use: self.delete)
                .openAPI(
                    summary: "Delete exercise type",
                    description: "Delete an exercise type by ID (admins only)",
                    response: .type(HTTPStatus.self)
                )
        }

    }
    
    @Sendable
    func index(req: Request) async throws -> [ExerciseTypeResponseDTO] {
        return try await ExerciseType.query(on: req.db)
            .sort(\.$name)
            .sort(\.$level)
            .all()
            .map { $0.toDTO() }
    }
    
    @Sendable
    func create(req: Request) async throws -> [ExerciseTypeResponseDTO] {
        // Check if user is admin
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        guard user.isAdmin == true else {
            throw Abort(.forbidden)
        }
        
        let dtos = try req.content.decode([ExerciseTypeCreateDTO].self)
        
        var exerciseTypes: [ExerciseTypeResponseDTO] = []
        for dto in dtos {
            let exerciseType = try await dto.toModel(on: req.db)
            exerciseTypes.append(exerciseType.toDTO())
        }
        
        return exerciseTypes
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

        guard let exerciseType = try await ExerciseType.find(req.parameters.get("exerciseTypeID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await exerciseType.delete(on: req.db)
        return .noContent
    }

}
