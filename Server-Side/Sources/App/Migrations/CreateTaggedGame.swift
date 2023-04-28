//
//  CreateTaggedGame.swift
//  
//
//  Created by Caleb Landis on 4/28/23.
//

import Foundation
import Fluent

struct CreateTaggedGame: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("taggedGames")
            .id()
            .field("tagID", .string)
            .field("gameID", .string)
            .field("coverURL", .string)
            .field("gameName", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("taggedGames").delete()
    }
}
