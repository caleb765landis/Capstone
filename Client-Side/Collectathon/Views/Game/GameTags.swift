//
//  GameTags.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/27/23.
//

import SwiftUI

struct GameTags: View {
    
    var gameName: String
    var coverURL: String
    @StateObject var viewModel: GameTagsViewModel
    
    var body: some View {
        VStack (alignment: .center){
            
            // Tags body title
            HStack (alignment: .center) {
                
                Spacer()
                
                Text("Tags")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
            }
            
            // For each tag, get its state for if it is in each list or not
            ForEach(viewModel.tags.indices, id: \.self) { index in
                HStack(alignment: .center) {
                    Toggle(isOn: $viewModel.tags[index].isTagged) {
                        Text(viewModel.tags[index].tagName)
                            .bold()
                    }
                    
                    // when toggle is tapped, add game to db if toggle is turned on, delete game if turned off
                    .onChange(of: viewModel.tags[index].isTagged) { isTagged in
                        if isTagged {
                            addGame(viewModel.tags[index].tagID)
                        } else {
                            deleteGame(viewModel.tags[index].tagID)
                        }
                    }
                    .padding(.horizontal, 80)
                } // End HStack
            } // end for each
        } // end VStack
        .onAppear {
            fetchTags()
        }
    } // end body
    
    // TODO: Add better error handling for following functions
    
    private func fetchTags() {
        Task {
            do {
                try await viewModel.fetchTags()
            } catch {}
        } // end task
    } // end fetchGame
    
    // add game interface
    // calls async function to actually add game to db
    private func addGame(_ tagID: String) {
        Task {
            do {
                try await addTaggedGame(tagID)
            } catch {}
        }
    }
    
    // delete game interface
    // calls async function to actually add game to db
    private func deleteGame(_ tagID: String) {
        Task {
            do {
                try await deleteTaggedGame(tagID)
            } catch {}
        }
    }
    
    // Creates a temp TaggedGame and posts to my API
    private func addTaggedGame(_ tagID: String) async throws {
        let temp = TaggedGame(tagID: tagID, gameID: viewModel.gameID, coverURL: coverURL, gameName: gameName)
        
        try await HTTP.post(url: URL(string: "http://127.0.0.1:8080/taggedGames")!, body: temp)
    }
    
    // deletes game with this tag's ID and this game's ID using my API
    private func deleteTaggedGame(_ tagID: String) async throws {
        try await HTTP.delete(url: URL(string: "http://127.0.0.1:8080/taggedGames/byTagAndGame/\(tagID)/\(viewModel.gameID)")!)
    }
    
} // end GameTags view

struct GameTags_Previews: PreviewProvider {
    static var previews: some View {
        GameTags(gameName: "Halo: Combat Evolved", coverURL: "//images.igdb.com/igdb/image/upload/t_thumb/co2r2r.jpg", viewModel: GameTagsViewModel(740))
    }
}
