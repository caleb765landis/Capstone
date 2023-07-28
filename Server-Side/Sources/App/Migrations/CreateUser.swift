//
//  CreateUser.swift
//  
//
//  Created by Caleb Landis on 4/20/23.
//

import Foundation
import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("users")
            .id()
            .field("firstName", .string)
            .field("lastName", .string)
            .field("username", .string)
            .field("password", .string)
            .field("email", .string)
            .field("joinDate", .date)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("users").delete()
    }
}
