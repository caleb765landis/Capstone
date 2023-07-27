//
//  GameViewModel.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/20/23.
//

import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    let gameID: Int
    
    @Published var game: Game_LongInfo?

    init(_ currentGameID: Int) {
        self.gameID = currentGameID
    }
    
    func fetchGame() async throws {
        // Get first resut of game with this id
        let game = try await HTTP.get(url: URL(string: "http://127.0.0.1:8080/IGDBGames/longInfo/\(self.gameID)")!, dataType: [Game_LongInfo].self)[0]
        
        DispatchQueue.main.async {
            self.game = game
        }
    } // end fetchGame

}
