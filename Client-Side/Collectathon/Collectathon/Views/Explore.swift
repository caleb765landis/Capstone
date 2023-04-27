//
//  Explore.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/26/23.
//

import SwiftUI

struct Explore: View {
    let gradient = LinearGradient(colors: [.blue, .white],
                                      startPoint: .topLeading,
                                      endPoint: .bottomTrailing)
    
    @StateObject private var viewModel = ExploreListViewModel()
    @State private var searchText: String = ""
    
    @State private var showingAddModal = false
    @State private var busy = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.blue
                    .opacity(0.25)
                    .ignoresSafeArea()
                
                VStack {
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    List {
                        ForEach(viewModel.games) { game in
                            NavigationLink(destination: Game(viewModel: GameViewModel(game.id))) {
                                HStack {
                                    AsyncImage(url: URL(string: game.cover.url)!, content: { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: 100, maxHeight:130)
                                    }, placeholder: {
//                                        ProgressView()
                                        Rectangle().fill(.gray)
                                            .frame(width: 100, height: 130)
                                    })
                                    Text(game.name)
                                } // End HStack
                            } // End NavigationLink
                        } // End For Each
                        
                        
                    } // End List
                    .scrollContentBackground(.hidden)
                    .listStyle(.sidebar)
                    .searchable(text: $searchText)
                    .refreshable {
                        fetchGames()
                    }
                    .onChange(of: searchText) { value in
                        Task {
                            if !value.isEmpty &&  value.count > 3 {
                                try await viewModel.search(name: value.trimmingCharacters(in: .whitespacesAndNewlines))
                            } else {
                                viewModel.games.removeAll()
                                fetchGames()
                            }
                        }
                    } // end on change
                    
                } // end VStack
                .navigationBarTitle("Explore")
                .onAppear(perform: fetchGames)
            
                if busy {
                    ProgressView()
                } // end if busy
                
            } // End ZStack
        } // End Navigation View
    } // End Body
    
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
    
    
    
} // End Explore View

struct Explore_Previews: PreviewProvider {
    static var previews: some View {
        Explore()
    }
}
