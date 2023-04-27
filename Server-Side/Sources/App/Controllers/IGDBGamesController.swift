//
//  AuthenticationController.swift
//  
//
//  Created by Caleb Landis on 4/20/23.
//

import Foundation
import Fluent
import Vapor
import IGDB_SWIFT_API
import SwiftBSON


struct IGDBGamesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let games = routes.grouped("IGDBGames")
        games.get(use:getGames)
        
        let gamesShortInfo = routes.grouped("IGDBGames", "shortInfo")
        gamesShortInfo.group(":gameName") { gamesShortInfo in
            gamesShortInfo.get(use: getGamesShortInfo)
        }
        
        let gamesLongInfo = routes.grouped("IGDBGames", "longInfo")
        gamesLongInfo.group(":gameID") { gamesLongInfo in
            gamesLongInfo.get(use: getGamesLongInfo)
        }
        
        let ratingHighLow = routes.grouped("IGDBGames", "ratingHighLow")
        ratingHighLow.get(use: getGamesRatingHighLow)
        
        /*
        auth.get(use: index)
        auth.post(use: create)
        auth.group(":todoID") { auth in
            auth.delete(use: delete)
        }
        */
    }
    
    struct Cover: Codable {
        let id: Int
        let url: String
    }
    
    struct Genre: Codable {
        let id: Int
        let name: String
    }
    
    struct Platform: Codable {
        let id: Int
        let name: String
    }
    
    struct Game_ShortInfo: Codable {
        let id: Int
        let name: String
        let cover: Cover?
    }
    
    struct Game_LongInfo: Codable {
        let id: Int
        let name: String
        let cover: Cover?
        var genres: [Genre]?
        var platforms: [Platform]?
        let summary: String?
        let first_release_date: Double?
    }
    
    struct Auth: Codable {
        let access_token: String
        let expires_in: Int
        let token_type: String
    }
    
    // for testing to make sure IGDB api is still connectable
    func getGames(req: Request) async throws -> String {
        let dataResponse = try await getDataStr()
        return dataResponse
    }
    
    func getGamesShortInfo(req: Request) async throws -> String {
        let name = req.parameters.get("gameName")!
        let dataResponse = try await getGamesShortInfoData(name)
        return dataResponse
    }
    
    func getGamesLongInfo(req: Request) async throws -> String {
        let id = req.parameters.get("gameID")!
        let dataResponse = try await getGamesLongInfoData(id)
        return dataResponse
    }
    
    func getGamesRatingHighLow(req: Request) async throws -> String {
        let dataResponse = try await getGamesRatingHighLowData()
        return dataResponse
    }
    
    
    func getAuth() async throws -> Data {
        // clientID = zunzi2nz8k5rg18pa75yobhbybxjmd
        // secret = knvy5qz9886vfj22x7meit59twhkmx
        //https://id.twitch.tv/oauth2/token?client_id=zunzi2nz8k5rg18pa75yobhbybxjmd&client_secret=knvy5qz9886vfj22x7meit59twhkmx&grant_type=client_credentials
        
        let url = URL(string: "https://id.twitch.tv/oauth2/token?client_id=zunzi2nz8k5rg18pa75yobhbybxjmd&client_secret=knvy5qz9886vfj22x7meit59twhkmx&grant_type=client_credentials")!
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let (data, _) = try await session.data(for: request)
//        print (String(data: data, encoding: .utf8)!)
        return data
//        return String(data: data, encoding: .utf8)!
    }
    
    func getDataStr() async throws -> String {
        // Get accessToken
        let authData = try await getAuth()
        let auth = try JSONDecoder().decode(Auth.self, from: authData)
        
        let accessToken = "bearer " + auth.access_token
        let clientID = "zunzi2nz8k5rg18pa75yobhbybxjmd"

        let url = URL(string: "https://api.igdb.com/v4/games")!
        var requestHeader = URLRequest.init(url: url)
        requestHeader.httpBody = "search \"Halo\"; fields name;"
                     .data(using: .utf8, allowLossyConversion: false)
        requestHeader.httpMethod = "POST"
        requestHeader.setValue(clientID, forHTTPHeaderField: "Client-ID")
        requestHeader.setValue(accessToken, forHTTPHeaderField: "Authorization")
        requestHeader.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        
        let (data, _) = try await session.data(for: requestHeader)
        return String(data: data, encoding: .utf8)!
    }
    
    func getGamesShortInfoData(_ name: String) async throws -> String {
        let authData = try await getAuth()
        let auth = try JSONDecoder().decode(Auth.self, from: authData)
        
        let accessToken = "bearer " + auth.access_token
        let clientID = "zunzi2nz8k5rg18pa75yobhbybxjmd"
        
        let url = URL(string: "https://api.igdb.com/v4/games")!
        var requestHeader = URLRequest.init(url: url)
        requestHeader.httpBody = "fields name, cover.url; search \"\(name)\";"
                     .data(using: .utf8, allowLossyConversion: false)
        requestHeader.httpMethod = "POST"
        requestHeader.setValue(clientID, forHTTPHeaderField: "Client-ID")
        requestHeader.setValue(accessToken, forHTTPHeaderField: "Authorization")
        requestHeader.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        
        let (data, _) = try await session.data(for: requestHeader)
        
//        let short = try JSONDecoder().decode([Game_ShortInfo].self, from: data)
//        print(short)
        
        return String(data: data, encoding: .utf8)!
    }
    
    func getGamesLongInfoData(_ id: String) async throws -> String {
        let authData = try await getAuth()
        let auth = try JSONDecoder().decode(Auth.self, from: authData)
        
        let accessToken = "bearer " + auth.access_token
        let clientID = "zunzi2nz8k5rg18pa75yobhbybxjmd"
        
        let url = URL(string: "https://api.igdb.com/v4/games")!
        var requestHeader = URLRequest.init(url: url)
        // involved_companies.company.name; where involved_companies.developer = true;
        requestHeader.httpBody = "fields name, cover.url, genres.name, platforms.name, summary, first_release_date; where id = \(id);"
                     .data(using: .utf8, allowLossyConversion: false)
        requestHeader.httpMethod = "POST"
        requestHeader.setValue(clientID, forHTTPHeaderField: "Client-ID")
        requestHeader.setValue(accessToken, forHTTPHeaderField: "Authorization")
        requestHeader.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        
        let (data, _) = try await session.data(for: requestHeader)
        
//        let long = try JSONDecoder().decode([Game_LongInfo].self, from: data)
//        print(long)
        
        return String(data: data, encoding: .utf8)!
    }
    
    func getGamesRatingHighLowData() async throws -> String {
        let authData = try await getAuth()
        let auth = try JSONDecoder().decode(Auth.self, from: authData)
        
        let accessToken = "bearer " + auth.access_token
        let clientID = "zunzi2nz8k5rg18pa75yobhbybxjmd"
        
        let url = URL(string: "https://api.igdb.com/v4/games")!
        var requestHeader = URLRequest.init(url: url)
        // involved_companies.company.name; where involved_companies.developer = true;
        requestHeader.httpBody = "fields name, cover.url; where rating > 75; sort rating desc; limit 50;"
                     .data(using: .utf8, allowLossyConversion: false)
        requestHeader.httpMethod = "POST"
        requestHeader.setValue(clientID, forHTTPHeaderField: "Client-ID")
        requestHeader.setValue(accessToken, forHTTPHeaderField: "Authorization")
        requestHeader.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        
        let (data, _) = try await session.data(for: requestHeader)
        
//        let long = try JSONDecoder().decode([Game_LongInfo].self, from: data)
//        print(long)
        
        return String(data: data, encoding: .utf8)!
    }
    
    /*
     
    func index(req: Request) async throws -> [Todo] {
        try await Todo.query(on: req.db).all()
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
