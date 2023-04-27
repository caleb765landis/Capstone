//
//  TodoController.swift
//  
//
//  Created by Caleb Landis on 2/22/23.
//

import Foundation
import Fluent
import Vapor

struct TodoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todo = routes.grouped("todos")
        todo.get(use: index)
        todo.post(use: create)
        todo.group(":todoID") { todo in
            todo.get(use: show)
            todo.put(use: put)
            todo.delete(use: delete)
        }
    }
    
    func index(req: Request) async throws -> [Todo] {
        try await Todo.query(on: req.db).all()
    }
    
    func show(req: Request) async throws -> Todo {
        guard let todo = try await Todo.find(req.parameters.get("todoID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return todo
    }

    func create(req: Request) async throws -> Todo {
        let todo = try req.content.decode(Todo.self)
        try await todo.save(on: req.db)
        return todo
    }
    
    func put(req: Request) async throws -> HTTPStatus {
        guard let todo = try await Todo.find(req.parameters.get("todoID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let updatedTodo = try req.content.decode(Todo.self)
        
        todo.title = updatedTodo.title
        
        try await todo.save(on: req.db)
        
        return .noContent
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let todo = try await Todo.find(req.parameters.get("todoID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await todo.delete(on: req.db)
        return .noContent
    }
}
