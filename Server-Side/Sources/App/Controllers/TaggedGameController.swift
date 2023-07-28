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
        }
        
        
        taggedGame.group("byTag", ":tagID") { taggedGame in
            taggedGame.get(use: showByTag)
        }
        
        taggedGame.group("byTagAndGame", ":tagID", ":gameID") { taggedGame in
            taggedGame.get(use: showByTagAndGame)
            taggedGame.delete(use: delete)
        }
    }
    
    func index(req: Request) async throws -> [TaggedGame] {
        try await TaggedGame.query(on: req.db).all()
    }
    
    func show(req: Request) async throws -> [TaggedGame] {
        try await TaggedGame.query(on: req.db).filter(\.$gameID == req.parameters.get("gameID")!).all()
    }

    
    func showByTag(req: Request) async throws -> [TaggedGame] {
        try await TaggedGame.query(on: req.db).filter(\.$tagID == req.parameters.get("tagID")!).all()
    }
    
    func showByTagAndGame(req: Request) async throws -> [TaggedGame] {
        try await TaggedGame.query(on: req.db).filter(\.$tagID == req.parameters.get("tagID")!).filter(\.$gameID == req.parameters.get("gameID")!).all()
    }
    
    func create(req: Request) async throws -> TaggedGame {
        let taggedGame = try req.content.decode(TaggedGame.self)
        try await taggedGame.save(on: req.db)
        return taggedGame
    }
    

    func delete(req: Request) async throws -> HTTPStatus {
        let games = try await TaggedGame.query(on: req.db).filter(\.$tagID == req.parameters.get("tagID")!).filter(\.$gameID == req.parameters.get("gameID")!).delete()
        
        return .noContent
    }
}
