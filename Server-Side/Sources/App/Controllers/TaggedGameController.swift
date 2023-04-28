//
//  TaggedGamegedGameController.swift
//  
//
//  Created by Caleb Landis on 4/27/23.
//

import Foundation
import Fluent
import Vapor

struct TaggedGameController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let taggedGame = routes.grouped("taggedGames")
        
        taggedGame.get(use: index)
        taggedGame.post(use: create)
        taggedGame.group(":gameID") { taggedGame in
            taggedGame.get(use: show)
//            taggedGame.put(use: put)
            taggedGame.delete(use: delete)
        }
        
//        let taggedGameForUser = routes.grouped("taggedGames", "forUser")
//        taggedGameForUser.group(":userID") { taggedGameForUser in
//            taggedGameForUser.get(use:showUserTaggedGames)
//        }
    }
    
    func index(req: Request) async throws -> [TaggedGame] {
        try await TaggedGame.query(on: req.db).all()
    }
    
    func show(req: Request) async throws -> [TaggedGame] {
//        guard let taggedGame = try await TaggedGame.find(req.parameters.get("gameID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        return taggedGame
        try await TaggedGame.query(on: req.db).filter(\.$gameID == req.parameters.get("gameID")!).all()
    }
    
//    func showUserTaggedGames(req: Request) async throws -> [TaggedGame] {
//        try await TaggedGame.query(on: req.db).filter(\.$userID == req.parameters.get("userID")!).all()
//    }

    func create(req: Request) async throws -> TaggedGame {
        let taggedGame = try req.content.decode(TaggedGame.self)
        try await taggedGame.save(on: req.db)
        return taggedGame
    }
    
//    func put(req: Request) async throws -> HTTPStatus {
//        guard let taggedGame = try await TaggedGame.find(req.parameters.get("taggedGameID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        let updatedTaggedGame = try req.content.decode(TaggedGame.self)
//
//        taggedGame.gameName = taggedGame.gameName
//
//        try await taggedGame.save(on: req.db)
//
//        return .noContent
//    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let taggedGame = try await TaggedGame.find(req.parameters.get("taggedGameID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await taggedGame.delete(on: req.db)
        return .noContent
    }
}
