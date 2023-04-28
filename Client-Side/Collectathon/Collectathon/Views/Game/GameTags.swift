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
            
            HStack (alignment: .center) {
                Spacer()
                Text("Tags")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            
            ForEach(viewModel.tags.indices, id: \.self) { index in
//                Text(tag.tagName)
                HStack(alignment: .center) {
                    Toggle(isOn: $viewModel.tags[index].isTagged) {
                        Text(viewModel.tags[index].tagName)
                            .bold()
                    }
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
    
    private func fetchTags() {
//        self.busy = true
//        self.errorMessage = nil
        Task {
            do {
                try await viewModel.fetchTags()
//                busy = false
            } catch {
//                busy = false
//                errorMessage = "Failed to fetch list of tags: \(error.localizedDescription)"
            }
        } // end task
    } // end fetchGame
    
    private func addGame(_ tagID: String) {
        Task {
            do {
                try await addTaggedGame(tagID)
            } catch {
                
            }
        }
    }
    
    private func deleteGame(_ tagID: String) {
        Task {
            do {
                try await deleteTaggedGame(tagID)
            } catch {
                
            }
        }
    }
    
    private func addTaggedGame(_ tagID: String) async throws {
        let temp = TaggedGame(tagID: tagID, gameID: viewModel.gameID, coverURL: coverURL, gameName: gameName)
        
        try await HTTP.post(url: URL(string: "http://127.0.0.1:8080/taggedGames")!, body: temp)
    }
    
    private func deleteTaggedGame(_ tagID: String) async throws {
//        let temp = TaggedGame(tagID: tagID, gameID: viewModel.gameID, coverURL: coverURL, gameName: gameName)
//
//        try await HTTP.post(url: URL(string: "http://127.0.0.1:8080/taggedGames")!, body: temp)
        try await HTTP.delete(url: URL(string: "http://127.0.0.1:8080/taggedGames/byTagandGame?tagID=\(tagID)&gameID=\(viewModel.gameID)")!)
    }
    
    
    
} // end GameTags

struct GameTags_Previews: PreviewProvider {
    static var previews: some View {
        GameTags(gameName: "Halo: Combat Evolved", coverURL: "//images.igdb.com/igdb/image/upload/t_thumb/co2r2r.jpg", viewModel: GameTagsViewModel(740))
    }
}
