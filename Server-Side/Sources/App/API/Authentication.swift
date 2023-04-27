//
//  File.swift
//  
//
//  Created by Caleb Landis on 2/22/23.
//

import Foundation
import Fluent
import Vapor

struct AuthenticationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("authentications")
        auth.get(use:getAuthentication)
        /*
        auth.get(use: index)
        auth.post(use: create)
        auth.group(":todoID") { auth in
            auth.delete(use: delete)
        }
        */
    }
    
    func getAuthentication(req: Request) async throws -> String {
        // clientID = zunzi2nz8k5rg18pa75yobhbybxjmd
        // secret = knvy5qz9886vfj22x7meit59twhkmx
        //https://id.twitch.tv/oauth2/token?client_id=zunzi2nz8k5rg18pa75yobhbybxjmd&client_secret=knvy5qz9886vfj22x7meit59twhkmx&grant_type=client_credentials
        return "Authenticated"
    }

    /*
    func index(req: Request) async throws -> [Authentication] {
        try await Authentication.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Todo {
        let todo = try req.content.decode(Todo.self)
        try await todo.save(on: req.db)
        return todo
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let todo = try await Todo.find(req.parameters.get("todoID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await todo.delete(on: req.db)
        return .noContent
    }
     */
}
