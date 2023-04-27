//
//  Models.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/26/23.
//

import Foundation
import SwiftUI

struct Cover: Identifiable, Codable {
    let id: Int
    let url: String
}

struct Game_ShortInfo: Identifiable, Codable {
    let id: Int
    let name: String
    let cover: Cover
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


public struct TagWithBool: Identifiable, Codable {
    public var id: String
    public var userID: String
    public var tagName: String
    public var isTagged: Bool

    public init(
        id: String,
        userID: String,
        tagName: String
    ) {
        self.id = id
        self.userID = userID
        self.tagName = tagName
        self.isTagged = false
    }
}

//public struct TaggedGame: Identifiable, Codable {
//    public var id: String
//    public var userID: String
//    public var tagName: String
//
//    public init(
//        id: String,
//        userID: String,
//        tagName: String
//    ) {
//        self.id = id
//        self.userID = userID
//        self.tagName = tagName
//    }
//}
