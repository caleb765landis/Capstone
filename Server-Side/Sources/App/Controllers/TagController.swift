//
//  TagController.swift
//  
//
//  Created by Caleb Landis on 4/20/23.
//

import Foundation
import Fluent
import Vapor

struct TagController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tag = routes.grouped("tags")
        tag.get(use: index)
        tag.post(use: create)
        tag.group(":tagID") { tag in
            tag.get(use: show)
            tag.put(use: put)
            tag.delete(use: delete)
        }
        
        tag.group(":tagID", "count") { tag in
            tag.get(use: getCount)
        }
        
        let tagForUser = routes.grouped("tags", "forUser")
        tagForUser.group(":userID") { tagForUser in
            tagForUser.get(use:showUserTags)
        }
    }
    
    func index(req: Request) async throws -> [Tag] {
        try await Tag.query(on: req.db).all()
    }
    
    func show(req: Request) async throws -> Tag {
        guard let tag = try await Tag.find(req.parameters.get("tagID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return tag
    }
    
    func showUserTags(req: Request) async throws -> [Tag] {
        try await Tag.query(on: req.db).filter(\.$userID == req.parameters.get("userID")!).all()
    }

    func create(req: Request) async throws -> Tag {
        let tag = try req.content.decode(Tag.self)
        try await tag.save(on: req.db)
        return tag
    }
    
    func put(req: Request) async throws -> HTTPStatus {
        guard let tag = try await Tag.find(req.parameters.get("tagID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let updatedTag = try req.content.decode(Tag.self)
        
        tag.tagName = updatedTag.tagName
        
        try await tag.save(on: req.db)
        
        return .noContent
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let tag = try await Tag.find(req.parameters.get("tagID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await tag.delete(on: req.db)
        return .noContent
    }
    
    func getCount(req: Request) async throws -> Int {
        try await TaggedGame.query(on: req.db).filter(\.$tagID == req.parameters.get("tagID")!).count()
    }
}
