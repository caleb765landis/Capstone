//
//  Tag.swift
//  
//
//  Created by Caleb Landis on 4/20/23.
//

import Foundation
import Fluent
import Vapor

final class Tag: Model, Content {
    static let schema = "tags"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "userID")
    var userID: String
    
    @Field(key: "tagName")
    var tagName: String

    init() { }

    init(id: UUID? = nil, userID: String, tagName: String) {
        self.id = id
        self.userID = userID
        self.tagName = tagName
    }
}
