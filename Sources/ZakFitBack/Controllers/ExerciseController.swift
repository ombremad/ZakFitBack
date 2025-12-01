//
//  ExerciseController.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 01/12/2025.
//

import Vapor
import Fluent
import JWT
import VaporToOpenAPI

struct ExerciseController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let exercises = routes.grouped("exercises")
        
        let protected = exercises.grouped(JWTMiddleware()).groupedOpenAPI(auth: .bearer())
        
        protected.get(use: self.index)
            .openAPI(
                summary: "Get exercises",
                description: "Get a list of exercises for user, with filter and sorting options",
                query: .type(ExerciseQuery.self),
                response: .type([ExerciseResponseDTO].self)
            )
        protected.post(use: self.create)
            .openAPI(
                summary: "Create exercise",
                description: "Create a new exercise for user",
                body: .type(ExerciseCreateDTO.self),
                response: .type(ExerciseResponseDTO.self)
            )
        protected.group(":exerciseID") { exerciseType in
            exerciseType.delete(use: self.delete)
                .openAPI(
                    summary: "Delete exercise",
                    description: "Delete an exercise by ID",
                    response: .type(HTTPStatus.self)
                )
        }
    }
    
    @Sendable
    func index(req: Request) async throws -> [ExerciseResponseDTO] {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        let queryParams = try req.query.decode(ExerciseQuery.self)

        var query = Exercise.query(on: req.db)
            .filter(\.$user.$id == user.id!)
        
        // Filter by days
        if let days = queryParams.days {
            let calendar = Calendar.current
            let startDate = calendar.startOfDay(for: Date())
            let cutoffDate = calendar.date(byAdding: .day, value: -days + 1, to: startDate)!
            query = query.filter(\.$date >= cutoffDate)
        }
        
        // Filter by exercise type
        if let exerciseTypeId = queryParams.exerciseType {
            query = query.filter(\.$exerciseType.$id == exerciseTypeId)
        }
        
        // Filter by length
        if let minLength = queryParams.minLength {
            query = query.filter(\.$length >= minLength)
        }
        if let maxLength = queryParams.maxLength {
            query = query.filter(\.$length <= maxLength)
        }
        
        // Apply sorting
        if let sortBy = queryParams.sortBy {
            let sortOrder: DatabaseQuery.Sort.Direction =
                (queryParams.sortOrder == "descending") ? .descending : .ascending
            
            switch sortBy {
            case "date":
                query = query.sort(\.$date, sortOrder)
            case "length":
                query = query
                    .sort(\.$length, sortOrder)
                    .sort(\.$date, .descending)
            case "activityType":
                query = query
                    .join(ExerciseType.self, on: \Exercise.$exerciseType.$id == \ExerciseType.$id)
                    .sort(ExerciseType.self, \.$name, sortOrder)
                    .sort(\.$date, .descending)
            default:
                query = query.sort(\.$date, .descending)
            }
        } else {
            query = query.sort(\.$date, .descending)
        }
        
        query = query.with(\.$exerciseType)
        
        let exercises = try await query.all()
        return exercises.map { $0.toDTO() }
    }
    
    @Sendable
    func create(req: Request) async throws -> ExerciseResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        let dto = try req.content.decode(ExerciseCreateDTO.self)
        let exercise = try await dto.toModel(on: req.db)
        exercise.$user.id = user.id!
        
        try await exercise.save(on: req.db)
        try await exercise.$exerciseType.load(on: req.db)
        
        return exercise.toDTO()
    }
    
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let exercise = try await Exercise.find(req.parameters.get("exerciseID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await exercise.delete(on: req.db)
        return .noContent
    }

}
