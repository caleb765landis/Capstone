//
//  CreateTag.swift
//  
//
//  Created by Caleb Landis on 4/20/23.
//

import Foundation
import Fluent

struct CreateTag: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("tags")
            .id()
            .field("userID", .string)
            .field("tagName", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("tags").delete()
    }
}
