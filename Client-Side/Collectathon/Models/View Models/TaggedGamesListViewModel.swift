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
}
