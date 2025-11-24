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

        users.get(use: self.index)
        users.post(use: self.create)
        users.post("login", use: self.login)
    }

    @Sendable
    func index(req: Request) async throws -> [UserDTO] {
        try await User.query(on: req.db).all().map { $0.toDTO() }
    }

    @Sendable
    func create(req: Request) async throws -> [String: String] {
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

}
