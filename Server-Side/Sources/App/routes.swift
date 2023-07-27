import Fluent
import Vapor

// registers API routes
// used in configure.swift
func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }

    app.get("hello", ":name") { req async -> String in
        let name = req.parameters.get("name")!
        return "Hello, \(name)!"
    }
    
//    try app.register(collection: TodoController()) // Used for testing and learning
    try app.register(collection: UserController())
    try app.register(collection: TagController())
    try app.register(collection: TaggedGameController())
    try app.register(collection: IGDBGamesController())
}

