//
//  User.swift
//  
//
//  Created by Caleb Landis on 4/20/23.
//

import Foundation
import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "firstName")
    var firstName: String
    
    @Field(key: "lastName")
    var lastName: String
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "joinDate")
    var joinDate: Date

    init() { }

    init(id: UUID? = nil,
         firstName: String,
         lastName: String,
         username: String,
         password: String,
         email: String)
    {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.password = password
        self.email = email
        self.joinDate = Date()
        
    }
}
