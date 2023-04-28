//
//  TaggedGamesListViewModel.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/20/23.
//

import Foundation
import SwiftUI


/// Models the data used in the `TaggedGamesList` view.
class TaggedGamesListViewModel: ObservableObject {
    /// The kitten's favorite food. This is mutable as the form allows the user to update this value.
//    @Published var favoriteFood: CatFood
    /// The initial kitten this view is created with.
    let tag: Tag
    
    @Published var games = [TaggedGameList]()

    init(currentTag: Tag) {
        self.tag = currentTag
    }
    
    func fetchGames() async throws {
        let games = try await HTTP.get(url: URL(string: "http://127.0.0.1:8080/taggedGames/byTag/\(tag.id)")!, dataType: [TaggedGameList].self)
        
        // we do this on the main queue so that when the value is updated the view will automatically be refreshed.
        DispatchQueue.main.async {
            self.games = games
        }
    }
    
//    func search(name: String) async throws {
//        let games = try await HTTP.get(url: URL(string: "http://127.0.0.1:8080/IGDBGames/shortInfo/\(name)")!, dataType: [Game_ShortInfo].self)
//        
//        DispatchQueue.main.async {
//            self.games = games
//        }
//    }

    /// Sends a request to update this kitten to the backend.
//    func updateKitten() async throws {
//        // if the selected food didn't change we don't need to do anything.
//        guard self.favoriteFood != self.kitten.favoriteFood else {
//            return
//        }
//        let kittenUpdate = KittenUpdate(newFavoriteFood: favoriteFood)
//        try await HTTP.patch(url: self.kitten.resourceURL, body: kittenUpdate)
//    }
//
//    /// Sends a request to delete this kitten to the backend.
//    func deleteKitten() async throws {
//        try await HTTP.delete(url: self.kitten.resourceURL)
//    }
}
