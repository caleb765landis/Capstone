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
//        self.tagID = currentTagID
//        self.gameName = gameName
//        self.coverURL = coverURL
    }
    
    func fetchTags() async throws {
        // get Tags
        let tags = try await HTTP.get(url: URL(string: "http://127.0.0.1:8080/tags/")!, dataType: [Tag].self)
        
        
        
        // get list of tagged games with this id
        let taggedGames = try await HTTP.get(url: URL(string: "http://127.0.0.1:8080/taggedGames/\(gameID)")!, dataType: [TaggedGame].self)
        
        let tagsWithBools = try await getTagsWithBools(tags: tags, taggedGames: taggedGames)
        
        // we do this on the main queue so that when the value is updated the view will automatically be refreshed.
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

