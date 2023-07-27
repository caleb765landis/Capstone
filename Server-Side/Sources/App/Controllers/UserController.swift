//
//  UserController.swift
//  
//
//  Created by Caleb Landis on 4/20/23.
//
//  Built for future scalability. Currently using only one defalut user,
//  but API has the capability to register more users in the future.
//

import Foundation
import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let user = routes.grouped("users")
        user.get(use: index)
        user.post(use: create)
        user.group(":userID") { user in
            user.get(use: show)
            user.put(use: put)
            user.delete(use: delete)
        }
    }
    
    func index(req: Request) async throws -> [User] {
        try await User.query(on: req.db).all()
    }
    
    func show(req: Request) async throws -> User {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user
    }

    func create(req: Request) async throws -> User {
        let user = try req.content.decode(User.self)
        user.joinDate = Date()
        print(user.joinDate)
        try await user.save(on: req.db)
        return user
    }
    
    func put(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let updatedUser = try req.content.decode(User.self)
        
        user.firstName = updatedUser.firstName
        user.lastName = updatedUser.lastName
        user.username = updatedUser.username
        user.password = updatedUser.password
        user.email = updatedUser.email
        
        try await user.save(on: req.db)
        
        return .noContent
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        return .noContent
    }
}
