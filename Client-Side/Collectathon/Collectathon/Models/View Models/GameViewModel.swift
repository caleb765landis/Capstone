//
//  GameViewModel.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/20/23.
//

import Foundation
import SwiftUI

struct Genre: Identifiable, Codable {
    let id: Int
    let name: String
}

struct Platform: Identifiable, Codable {
    let id: Int
    let name: String
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
}

class GameViewModel: ObservableObject {
    let gameID: Int
    
    @Published var game: Game_LongInfo?

    init(_ currentGameID: Int) {
        self.gameID = currentGameID
    }
    
    func fetchGame() async throws {
        // Get first resut of game with this id
        let game = try await HTTP.get(url: URL(string: "http://127.0.0.1:8080/IGDBGames/longInfo/\(self.gameID)")!, dataType: [Game_LongInfo].self)[0]
        self.game = game
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
//
///// Models the data used in the `TaggedGamesList` view.
//class TaggedGamesListViewModel: ObservableObject {
//    /// The kitten's favorite food. This is mutable as the form allows the user to update this value.
////    @Published var favoriteFood: CatFood
//    /// The initial kitten this view is created with.
//    let taggedGame: TaggedGame
//
//    init(currentTaggedGame: TaggedGame) {
//        self.taggedGame = currentTaggedGame
//        
////        self.kitten = currentKitten
////        self.favoriteFood = currentKitten.favoriteFood
//    }
//
//    /// Sends a request to update this kitten to the backend.
////    func updateKitten() async throws {
////        // if the selected food didn't change we don't need to do anything.
////        guard self.favoriteFood != self.kitten.favoriteFood else {
////            return
////        }
////        let kittenUpdate = KittenUpdate(newFavoriteFood: favoriteFood)
////        try await HTTP.patch(url: self.kitten.resourceURL, body: kittenUpdate)
////    }
////
////    /// Sends a request to delete this kitten to the backend.
////    func deleteKitten() async throws {
////        try await HTTP.delete(url: self.kitten.resourceURL)
////    }
//}
