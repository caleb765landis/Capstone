//
//  GameTagsViewModel.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/27/23.
//

import Foundation
import SwiftUI

/// Models the data used in the `GameTags` view.
class GameTagsViewModel: ObservableObject {
    @Published var tags = [TagWithBool]()
    
    let gameID: Int
    
    init(_ currentGameID: Int) {
        self.gameID = currentGameID
    }
    
    func fetchTags() async throws {
        // get Tags
        let tags = try await HTTP.get(url: URL(string: HTTP.baseURL + "/tags/")!, dataType: [Tag].self)
        
        // get list of tagged games with this id
        let taggedGames = try await HTTP.get(url: URL(string: HTTP.baseURL + "/taggedGames/\(gameID)")!, dataType: [TaggedGame].self)
        
        // get each tagged game's boolean values
        let tagsWithBools = try await getTagsWithBools(tags: tags, taggedGames: taggedGames)
        
        DispatchQueue.main.async {
            self.tags = tagsWithBools
        } // end dispatch
    } // end fetch tags
    
    func getTagsWithBools(tags: [Tag], taggedGames: [TaggedGame]) async throws -> [TagWithBool] {
        var tagsWithBools = [TagWithBool]()
        
        var index = 0
        
        // go through every tag
        for tag in tags {
            var gameIsTagged = false
            
            // check to see if that tag is turned on for this game. If it is, it will be in taggedGames
            for taggedGame in taggedGames {
                // if taggedGame.tagID = tag.id, gameIsTagged = true
                if tag.id == taggedGame.tagID {
                    gameIsTagged = true
                }
            } // end for tagged game
            
            let temp = TagWithBool(id: index, tagID: tag.id, tagName: tag.tagName, isTagged: gameIsTagged)
            tagsWithBools.append(temp)
            
            index += 1
            
        } // end for tag
        
        return tagsWithBools
    } // end getTagsWithBools
} // end GameTagsViewModel

