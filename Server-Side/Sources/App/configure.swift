import Fluent
import FluentMongoDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 8080

    //      app.views.use(.leaf)

    app.leaf.cache.isEnabled = app.environment.isRelease

    app.leaf.configuration.rootDirectory = Bundle.main.bundlePath

    app.routes.defaultMaxBodySize = "50MB"

    try app.databases.use(.mongo(
        connectionString: Environment.get("DATABASE_URL") ?? "mongodb://localhost:27017/vapor_database"
    ), as: .mongo)

    // Migrates models to db when needed
    app.migrations.add(CreateTodo())
    app.migrations.add(CreateUser())
    app.migrations.add(CreateTag())
    app.migrations.add(CreateTaggedGame())
    
    try app.autoMigrate().wait()

    app.views.use(.leaf)

    // Serves files from `Public/` directory
    let fileMiddleware = FileMiddleware(
        publicDirectory: app.directory.publicDirectory
    )
    app.middleware.use(fileMiddleware)

    // register routes
    try routes(app)
}

public func checkDataExists(_ app: Application) async throws {
    if ((try await User.query(on: app.db).count()) == 0) {
        print("Creating default user..")
        
        let tempUser = User(firstName: "Default", lastName: "User", username: "defaultUsername", password: "pass", email: "default@default.com")
        do {
            try await tempUser.save(on: app.db)
            print("User created.")
        } catch {
            print("User could not be created.")
        }
    } else {
        print("Loaded default user.")
    }
    
    let userID = try await User.query(on: app.db).first()?.id
    
    if ((try await Tag.query(on: app.db).filter(\.$tagName == "Collection").count()) == 0) && userID != nil {
        print("Creating 'Collection' tag...")
        
        let collection = Tag(userID: String(userID!), tagName: "Collection")
        do {
            try await collection.save(on: app.db)
            print("'Collection' tag created.")
        } catch  {
            print("'Collection' tag could not be created.")
        }
    } else {
        print("Loaded 'Collection' tag.")
    } // end if collection exists
    
    if ((try await Tag.query(on: app.db).filter(\.$tagName == "Completed").count()) == 0) && userID != nil {
        print("Creating 'Completed' tag...")
        
        let collection = Tag(userID: String(userID!), tagName: "Completed")
        do {
            try await collection.save(on: app.db)
            print("'Completed' tag created.")
        } catch  {
            print("'Completed' tag could not be created.")
        }
    } else {
        print("Loaded 'Completed' tag.")
    } // end if completed exists
    
    if ((try await Tag.query(on: app.db).filter(\.$tagName == "Wish List").count()) == 0) && userID != nil {
        print("Creating 'Wish List' tag...")
        
        let collection = Tag(userID: String(userID!), tagName: "Wish List")
        do {
            try await collection.save(on: app.db)
            print("'Wish List' tag created.")
        } catch  {
            print("'Wish List' tag could not be created.")
        }
    } else {
        print("Loaded 'Wish List' tag.")
    } // end if wish list exists
    
    if ((try await Tag.query(on: app.db).filter(\.$tagName == "Backlog").count()) == 0) && userID != nil {
        print("Creating 'Backlog' tag...")
        
        let collection = Tag(userID: String(userID!), tagName: "Backlog")
        do {
            try await collection.save(on: app.db)
            print("'Backlog' tag created.")
        } catch  {
            print("'Backlog' tag could not be created.")
        }
    } else {
        print("Loaded 'Backlog' tag.")
    } // end if backlog exists
    
}

