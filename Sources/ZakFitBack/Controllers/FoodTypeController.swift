//
//  FoodTypeController.swift
//  ZakFitBack
//
//  Created by Anne Ferret on 27/11/2025.
//

import Vapor
import Fluent
import JWT
import VaporToOpenAPI

struct FoodTypeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let foodTypes = routes.grouped("foodTypes")
        
        let protected = foodTypes.grouped(JWTMiddleware()).groupedOpenAPI(auth: .bearer())
        protected.get(use: self.index)
            .openAPI(
                summary: "Get food types",
                description: "Get a list of all food types available, with filter options",
                query: .type(FoodTypeQuery.self),
                response: .type([FoodTypeResponseDTO].self)
            )
        protected.post(use: self.create)
            .openAPI(
                summary: "Create food types",
                description: "Create new food types, as bulk in an array (admins only)",
                body: .type([FoodTypeCreateDTO].self),
                response: .type([FoodTypeResponseDTO].self)
            )
        
        protected.group(":foodTypeID") { foodType in
            foodType.get(use: self.get)
                .openAPI(
                    summary: "Get a food type",
                    description: "Get all details on a single food type",
                    response: .type(FoodTypeResponseDTO.self)
                )
            foodType.delete(use: self.delete)
                .openAPI(
                    summary: "Delete food type",
                    description: "Delete a food type by ID (admins only)",
                    response: .type(HTTPStatus.self)
                )
        }
    }
    
    @Sendable
    func index(req: Request) async throws -> [FoodTypeResponseDTO] {
        let queryParams = try req.query.decode(FoodTypeQuery.self)
        
        let mealTypeFilters = (queryParams.mealTypes ?? [])
            .map { $0.removingPercentEncoding ?? $0 }
        let restrictionTypeFilters = (queryParams.restrictionTypes ?? [])
            .map { $0.removingPercentEncoding ?? $0 }

        var query = FoodType.query(on: req.db)
        
        // Filter: include any of the meal types
        if !mealTypeFilters.isEmpty {
            let foodsWithMealTypes = try await FoodType.query(on: req.db)
                .join(FoodMealTypePivot.self, on: \FoodType.$id == \FoodMealTypePivot.$foodType.$id)
                .join(MealType.self, on: \FoodMealTypePivot.$mealType.$id == \MealType.$id)
                .filter(MealType.self, \.$name ~~ mealTypeFilters)
                .unique()
                .all()
            
            let mealTypeFoodIds = foodsWithMealTypes.compactMap { $0.id }
            
            if mealTypeFoodIds.isEmpty {
                return []
            }
            
            query = query.filter(\.$id ~~ mealTypeFoodIds)
        }
        
        // Filter: exclude all food with one of the restriction types
        if !restrictionTypeFilters.isEmpty {
            let foodsWithRestrictions = try await FoodType.query(on: req.db)
                .join(FoodRestrictionPivot.self, on: \FoodType.$id == \FoodRestrictionPivot.$foodType.$id)
                .join(RestrictionType.self, on: \FoodRestrictionPivot.$restrictionType.$id == \RestrictionType.$id)
                .filter(RestrictionType.self, \.$name ~~ restrictionTypeFilters)
                .unique()
                .all()
            
            let restrictedFoodTypeIds = foodsWithRestrictions.compactMap { $0.id }
            
            if !restrictedFoodTypeIds.isEmpty {
                query = query.filter(\.$id !~ restrictedFoodTypeIds)
            }
        }
        
        let foodTypes = try await query.sort(\.$name).all()
        return foodTypes.map { $0.toDTO() }
    }
        
    @Sendable
    func create(req: Request) async throws -> [FoodTypeResponseDTO] {
        // Check if user is admin
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        guard user.isAdmin == true else {
            throw Abort(.forbidden)
        }
        
        let dtos = try req.content.decode([FoodTypeCreateDTO].self)
        
        var foodTypes: [FoodTypeResponseDTO] = []
        for dto in dtos {
            let foodType = try await dto.toModel(on: req.db)
            
            try await foodType.$mealTypes.load(on: req.db)
            try await foodType.$restrictionTypes.load(on: req.db)
            
            foodTypes.append(FoodTypeResponseDTO(
                from: foodType,
                mealTypes: foodType.mealTypes,
                restrictionTypes: foodType.restrictionTypes
            ))
        }
        
        return foodTypes
    }
    
    @Sendable
    func get(req: Request) async throws -> FoodTypeResponseDTO {
        guard let foodType = try await FoodType.find(req.parameters.get("foodTypeID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await foodType.$mealTypes.load(on: req.db)
        try await foodType.$restrictionTypes.load(on: req.db)
        return foodType.toDTO(with: foodType.mealTypes, restrictionTypes: foodType.restrictionTypes)
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

        guard let foodType = try await FoodType.find(req.parameters.get("foodTypeID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await foodType.delete(on: req.db)
        return .noContent
    }
}
