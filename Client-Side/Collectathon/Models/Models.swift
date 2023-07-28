//
//  Models.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/26/23.
//
//  Model structs used by View Models
//

import Foundation
import SwiftUI

struct Cover: Identifiable, Codable {
    let id: Int
    let url: String
}

struct Genre: Identifiable, Codable {
    let id: Int
    let name: String
}

struct Platform: Identifiable, Codable {
    let id: Int
    let name: String
}

struct Game_ShortInfo: Identifiable, Codable {
    let id: Int
    let name: String
    let cover: Cover
}

// Cover already defined
struct Game_LongInfo: Identifiable, Codable {
    let id: Int
    let name: String
    let cover: Cover?
    var genres: [Genre]?
    var platforms: [Platform]?
    let summary: String?
    let first_release_date: Double?
    
    init(id: Int, name: String, cover: Cover?, genres: [Genre]? = nil, platforms: [Platform]? = nil, summary: String?, first_release_date: Double?) {
        self.id = id
        self.name = name
        self.cover = cover
        self.genres = genres
        self.platforms = platforms
        self.summary = summary
        self.first_release_date = first_release_date
    }
}

public struct Tag: Identifiable, Codable {
    public var id: String
    public var userID: String
    public var tagName: String

    public init(
        id: String,
        userID: String,
        tagName: String
    ) {
        self.id = id
        self.userID = userID
        self.tagName = tagName
    }
}

public struct TaggedGame: Codable {
    public var tagID: String
    public var gameID: Int
    public var coverURL: String
    public var gameName: String
}

public struct TaggedGameList: Identifiable, Codable {
    public var id: String
    public var tagID: String
    public var gameID: Int
    public var coverURL: String
    public var gameName: String
}


public struct TagWithBool: Identifiable {
    public var id: Int
    public var tagID: String
    public var tagName: String
    public var isTagged: Bool

    public init(
        id: Int,
        tagID: String,
        tagName: String,
        isTagged: Bool
    ) {
        self.id = id
        self.tagID = tagID
        self.tagName = tagName
        self.isTagged = isTagged
    }
}

public struct TagWithCount: Identifiable {
    public var id: String
    public var tagName: String
    public var count: Int
    
    public init(id: String, tagName: String, count: Int) {
        self.id = id
        self.tagName = tagName
        self.count = count
    }
}
