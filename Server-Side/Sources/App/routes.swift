import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }

    app.get("hello", ":name") { req async -> String in
        let name = req.parameters.get("name")!
        return "Hello, \(name)!"
    }
    
    try app.register(collection: TodoController())
    try app.register(collection: UserController())
    try app.register(collection: TagController())
    try app.register(collection: TaggedGameController())
    try app.register(collection: IGDBGamesController())
}

