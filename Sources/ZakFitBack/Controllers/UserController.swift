//
//  UserController.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 24/11/2025.
//

import Fluent
import Vapor
import JWT

struct UserController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")

        users.post("signup", use: self.signup)
            .openAPI(
                summary: "Create User",
                description: "Create a new user (returns a single token)",
                body: .type(UserCreateDTO.self)
            )
            .openAPINoAuth()

        users.post("login", use: self.login)
            .openAPI(
                summary: "Login User",
                description: "Logs an existing user in (returns a single token)",
                body: .type(LoginRequest.self)
            )
            .openAPINoAuth()
        
        let protected = users.grouped(JWTMiddleware()).groupedOpenAPI(auth: .bearer())
        protected.get(use: self.get)
            .openAPI(
                summary: "Get current User",
                description: "Returns a complete representation of the current user",
                body: .none,
                response: .type(UserPublicDTO.self)
            )
        protected.patch(use: self.patch)
            .openAPI(
                summary: "Patch current User",
                description: "Allows change of one or several values for the current user",
                body: .type(UserPatchDTO.self),
                response: .type(UserPublicDTO.self)
            )
    }

    @Sendable
    func signup(req: Request) async throws -> [String: String] {
        var user = try req.content.decode(UserCreateDTO.self)
        
        // Hash password
        user.password = try Bcrypt.hash(user.password)
        
        // Get new user with generated UUID and save in database
        let newUser = user.toModel()
        try await newUser.save(on: req.db)
        
        // Mandatory check if user id exists
        guard let userID = newUser.id else {
            throw Abort(.internalServerError, reason: "User ID missing after creation.")
        }
        
        // Create JWT and return token
        let payload = UserPayload(id: userID)
        let signer = JWTSigner.hs256(key: Config.shared.jwtSecret)
        let token = try signer.sign(payload)
        return ["token": token]
    }
    
    @Sendable
    func login(req: Request) async throws -> [String: String] {
        let userData = try req.content.decode(LoginRequest.self)
        
        // Search user by email
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == userData.email)
            .first() else {
            throw Abort(.unauthorized, reason: "This user does not exist.")
        }
        
        // Check password
        guard try Bcrypt.verify(userData.password, created: user.password) else {
            throw Abort(.unauthorized, reason: "Incorrect password.")
        }
        
        // Create JWT and return token
        let payload = UserPayload(id: user.id!)
        let signer = JWTSigner.hs256(key: Config.shared.jwtSecret)
        let token = try signer.sign(payload)
        return ["token": token]
    }
    
    @Sendable
    func get(req: Request) async throws -> UserPublicDTO {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        return user.toDTO()
    }
    
    @Sendable
    func patch(req: Request) async throws -> UserPublicDTO {
        let payload = try req.auth.require(UserPayload.self)
        var patch = try req.content.decode(UserPatchDTO.self)
        
        if patch.isEmpty {
            throw Abort(.badRequest, reason: "The request is empty.")
        }

        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        if let password = patch.password {
            patch.password = try Bcrypt.hash(password)
        }
        
        patch.apply(to: user)
        try await user.save(on: req.db)
        return user.toDTO()
    }
}
