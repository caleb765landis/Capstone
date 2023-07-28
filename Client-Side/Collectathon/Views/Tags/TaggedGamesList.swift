//
//  TaggedGamesList.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/20/23.
//

import Foundation
import SwiftUI

struct TaggedGamesList: View {
    @StateObject var viewModel: TaggedGamesListViewModel
    
    // Need to make lists searchable
    @State private var searchText: String = ""
    @State private var busy = false
    @State private var errorMessage: String?
    
    var body: some View {
        
        // Don't need Navigation View because this ZStack is already inside TagsList's Navigation View
        ZStack {
            Color.blue
                .opacity(0.25)
                .ignoresSafeArea()
            
            VStack {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                List {
                    ForEach(viewModel.games) { game in
                        NavigationLink(destination: Game(viewModel: GameViewModel(game.gameID)))
                        {
                            HStack {
                                // Cover Image
                                AsyncImage(url: URL(string: "https:" + game.coverURL)!, content: { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 100, maxHeight: 130)
                                }, placeholder: {
                                    Rectangle().fill(.gray)
                                        .frame(width: 100, height: 130)
                                }) // end AsyncImage
                                
                                // Game Title
                                Text(game.gameName)
                            } // End HStack
                        } // End Navigation Link
                    } // end For Each
                } // end List
                .listStyle(.sidebar)
                .scrollContentBackground(.hidden)
                .refreshable {
                    fetchGames()
                }
                
                // TODO: Make List Searchable
                /*
                .searchable(text: $searchText)
                .onChange(of: searchText) { value in
                    Task {
                        if !value.isEmpty {
                            try await viewModel.search(name: value.trimmingCharacters(in: .whitespacesAndNewlines))
                        } else {
                            viewModel.games.removeAll()
                        }
                    }
                } // end on change
                */
                
                if busy {
                    ProgressView()
                }
                
            } // End VStack
            .navigationTitle(viewModel.tag.tagName)
            .onAppear {
                fetchGames()
            }
        } // End ZStack
    } // End body
    
    private func fetchGames() {
        self.busy = true
        self.errorMessage = nil
        Task {
            do {
                try await viewModel.fetchGames()
                busy = false
            } catch {
                busy = false
                errorMessage = "Failed to fetch explore games: \(error.localizedDescription)"
            }
        } // end task
    } // end fetch games
    
} // End Tagged Games List

// Preview for 'Collection' tag for default user
struct TaggedGamesList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TaggedGamesList(viewModel: TaggedGamesListViewModel(currentTag: Tag(id: "319AF6AD-D84A-4BEE-981B-4E392B878D2A", userID: "E4D4CBE6-B620-4822-A6C2-D9F79C6A3BDC", tagName: "Collection")))
        }
    }
}
