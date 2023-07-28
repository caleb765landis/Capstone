//
//  TaggedGame.swift
//  
//
//  Created by Caleb Landis on 4/27/23.
//

import Foundation
import Fluent
import Vapor

final class TaggedGame: Model, Content {
    static let schema = "taggedGames"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "tagID")
    var tagID: String
    
    @Field(key: "gameID")
    var gameID: Int
    
    @Field(key: "coverURL")
    var coverURL: String
    
    @Field(key: "gameName")
    var gameName: String

    init() { }

    init(id: UUID? = nil, tagID: String, gameID: Int, coverURL: String, gameName: String) {
        self.id = id
        self.tagID = tagID
        self.gameID = gameID
        self.coverURL = coverURL
        self.gameName = gameName
    }
}
