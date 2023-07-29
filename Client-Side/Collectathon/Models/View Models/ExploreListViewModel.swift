//
//  ExploreListViewModel.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/26/23.
//

import Foundation
import SwiftUI

/// Models the data used in the `Explore` view.
class ExploreListViewModel: ObservableObject {
    @Published var games = [Game_ShortInfo]()
    
    func fetchGames() async throws {
        let games = try await HTTP.get(url: URL(string: HTTP.baseURL + "/IGDBGames/ratingHighLow/")!, dataType: [Game_ShortInfo].self)
        
        DispatchQueue.main.async {
            self.games = games
        }
    }
    
    func search(name: String) async throws {
        let games = try await HTTP.get(url: URL(string: HTTP.baseURL + "/IGDBGames/shortInfo/\(name)")!, dataType: [Game_ShortInfo].self)
        
        DispatchQueue.main.async {
            self.games = games
        }
    }
}
