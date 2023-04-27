//
//  File.swift
//  
//
//  Created by Caleb Landis on 2/22/23.
//

import Foundation
import Fluent
import Vapor
import IGDB_SWIFT_API
import SwiftBSON

struct Games: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let games = routes.grouped("games")
        games.get(use:getGames)
        /*
        auth.get(use: index)
        auth.post(use: create)
        auth.group(":todoID") { auth in
            auth.delete(use: delete)
        }
        */
    }
    
    struct Response: Codable {
        var results: [Result]
    }
    
    struct Result: Codable {
        var id: Int
        var name: String
    }
    
    func getGames(req: Request) async throws -> String {
        let dataResponse = try await getDataStr()
        return dataResponse
    }
    
    func getDataStr() async throws -> String {
        var clientID = "zunzi2nz8k5rg18pa75yobhbybxjmd"
        var accessToken = "bearer emduu3j68l4i6kvev9tswyzazrjtb7"

        let wrapper: IGDBWrapper = IGDBWrapper(clientID: clientID, accessToken: accessToken)

        let apicalypse = APICalypse()
            .fields(fields: "*")
            .exclude(fields: "*")
            .limit(value: 10)
            .offset(value: 0)
            .search(searchQuery: "Halo")
            .sort(field: "release_dates.date", order: .ASCENDING)
            .where(query: "platforms = 48")
        
        /*
        wrapper.games(apiCalypse: apicalypse, result: { games in
            print("in wrapper: ")
            print(games)
            print()
        }) { error in
            // Do something..
        }*/

        let url = URL(string: "https://api.igdb.com/v4/games")!
        var requestHeader = URLRequest.init(url: url)
        requestHeader.httpBody = "search \"Halo\"; fields name;".data(using: .utf8, allowLossyConversion: false)
        requestHeader.httpMethod = "POST"
        requestHeader.setValue(clientID, forHTTPHeaderField: "Client-ID")
        requestHeader.setValue(accessToken, forHTTPHeaderField: "Authorization")
        requestHeader.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        
        let (data, _) = try await URLSession.shared.data(for: requestHeader)
        return String(data: data, encoding: .utf8)!
        
        /*
//        session.dataTask(with: requestHeader) { data, response, error in
        let task = session.dataTask(with: requestHeader , completionHandler : { data, response, error in
            // Convert HTTP Response Data to a simple String and print it to make sure it's working
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    if  let object = json as? [Any] {
                        print(object)
                        //logic goes here for looping through the JSON
                    }
                    
                    dataStr = dataString
                    
                } catch {
                    print(error)
                }
            } // end if
            //print("dataStr = \(dataStr)")
        })
        task.resume()
         */
        
        //print("dataStr2 = \(dataStr)")
        
    }
    
    /*
    func getDataStr(completionHandler: @escaping (Data?, Error?) -> Void) {
        var clientID = "zunzi2nz8k5rg18pa75yobhbybxjmd"
        var accessToken = "bearer emduu3j68l4i6kvev9tswyzazrjtb7"

        let wrapper: IGDBWrapper = IGDBWrapper(clientID: clientID, accessToken: accessToken)

        let apicalypse = APICalypse()
            .fields(fields: "*")
            .exclude(fields: "*")
            .limit(value: 10)
            .offset(value: 0)
            .search(searchQuery: "Halo")
            .sort(field: "release_dates.date", order: .ASCENDING)
            .where(query: "platforms = 48")
        
        /*
        wrapper.games(apiCalypse: apicalypse, result: { games in
            print("in wrapper: ")
            print(games)
            print()
        }) { error in
            // Do something..
        }*/

        var dataStr = "Nothing yet"

        let url = URL(string: "https://api.igdb.com/v4/games")!
        var requestHeader = URLRequest.init(url: url)
        requestHeader.httpBody = "search \"Halo\"; fields name;".data(using: .utf8, allowLossyConversion: false)
        requestHeader.httpMethod = "POST"
        requestHeader.setValue(clientID, forHTTPHeaderField: "Client-ID")
        requestHeader.setValue(accessToken, forHTTPHeaderField: "Authorization")
        requestHeader.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: requestHeader , completionHandler : { data, response, error in
            // Convert HTTP Response Data to a simple String and print it to make sure it's working
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    if  let object = json as? [Any] {
                        print(object)
                        //logic goes here for looping through the JSON
                    }
                    
                    dataStr = dataString
                    
                    completionHandler(data, nil)
                } catch {
                    print(error)
                    completionHandler(nil, error)
                }
            } // end if
        })
        task.resume()
    
    }
     
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
