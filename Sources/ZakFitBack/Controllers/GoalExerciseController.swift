//
//  GoalExerciseController.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 28/11/2025.
//

import Vapor
import Fluent
import JWT
import VaporToOpenAPI

struct GoalExerciseController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let goalExercises = routes.grouped("goalExercises")
        
        let protected = goalExercises.grouped(JWTMiddleware()).groupedOpenAPI(auth: .bearer())
        protected.get(use: self.index)
            .openAPI(
                summary: "Get exercise goals",
                description: "Get a list of all current exercise goals for user",
                response: .type([GoalExerciseResponseDTO].self)
            )
        protected.post(use: self.create)
            .openAPI(
                summary: "Create exercise goal",
                description: "Create a new weekly exercise goal for the user",
                body: .type(GoalExerciseCreateDTO.self),
                response: .type(GoalExerciseResponseDTO.self)
            )
        
        protected.group(":goalExerciseID") { goalExercise in
            goalExercise.delete(use: self.delete)
                .openAPI(
                    summary: "Delete exercise goal",
                    description: "Delete an exercise goal by ID",
                    response: .type(HTTPStatus.self)
                )
        }
        
    }
    
    @Sendable
    func index(req: Request) async throws -> [GoalExerciseResponseDTO] {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }

        let goalExercises = try await GoalExercise.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .with(\.$exerciseType)
            .all()

        return goalExercises.map { $0.toDTO() }
    }

    @Sendable
    func create(req: Request) async throws -> GoalExerciseResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        let dto = try req.content.decode(GoalExerciseCreateDTO.self)
        let goalExercise = try await dto.toModel(on: req.db)
        goalExercise.$user.id = user.id!
        
        try await goalExercise.save(on: req.db)
        
        try await goalExercise.$exerciseType.load(on: req.db)
        
        return GoalExerciseResponseDTO(
            from: goalExercise,
            exerciseType: goalExercise.exerciseType
        )
    }
    
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }

        guard let goalExercise = try await GoalExercise.find(req.parameters.get("goalExerciseID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        guard goalExercise.$user.id == user.id else {
            throw Abort(.forbidden)
        }
        
        try await goalExercise.delete(on: req.db)
        return .noContent
    }

}
