//
//  RestrictionTypeController.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 25/11/2025.
//

import Vapor
import Fluent
import JWT

struct RestrictionTypeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let restrictionTypes = routes.grouped("restrictionTypes")
        
        restrictionTypes.get(use: self.index)
            .openAPI(
                summary: "Get restriction types",
                description: "Get a list of all dietary restriction types available in the app",
                response: .type([RestrictionTypeDTO].self)
            )
            .openAPINoAuth()
        
        let protected = restrictionTypes.grouped(JWTMiddleware()).groupedOpenAPI(auth: .bearer())
        protected.post(use: self.create)
            .openAPI(
                summary: "Create restriction type",
                description: "Create a new dietary restriction type (admins only)",
                body: .type(RestrictionTypeDTO.self),
                response: .type(RestrictionTypeDTO.self)
                )
        protected.group(":restrictionTypeID") { restrictionType in
            restrictionType.delete(use: self.delete)
                .openAPI(
                    summary: "Delete restriction type",
                    description: "Delete a dietary restriction type by ID (admins only)",
                    response: .type(HTTPStatus.self)
                )
        }
    }
    
    @Sendable
    func index(req: Request) async throws -> [RestrictionTypeDTO] {
        try await RestrictionType.query(on: req.db).all().map { $0.toDTO() }
    }
    
    @Sendable
    func create(req: Request) async throws -> RestrictionTypeDTO {
        // Check if user is admin
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        guard user.isAdmin == true else {
            throw Abort(.forbidden)
        }
        
        let newType = try req.content.decode(RestrictionTypeDTO.self).toModel()
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

        guard let type = try await RestrictionType.find(req.parameters.get("restrictionTypeID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await type.delete(on: req.db)
        return .noContent
    }
}
