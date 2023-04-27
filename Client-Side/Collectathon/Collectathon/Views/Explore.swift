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
    
    var body: some View {
        NavigationView {
            ZStack {
                gradient
                    .opacity(0.25)
                    .ignoresSafeArea()
                
                VStack {
                    List {
                        NavigationLink(
                            destination: Game(viewModel: GameViewModel(740))
                        ) {
                            Text("Halo")
                                .font(.title3)
                        }
                        
                        ForEach(viewModel.games) { game in
                            NavigationLink(destination: Game(viewModel: GameViewModel(game.id))) {
                                HStack {
                                    AsyncImage(url: URL(string: game.cover.url)!, content: { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: 100)
                                    }, placeholder: {
                                        ProgressView()
                                    })
                                    Text(game.name)
                                } // End HStack
                            } // End NavigationLink
                        } // End For Each
                        
                        
                    } // End List
                    .scrollContentBackground(.hidden)
                    .listStyle(.sidebar)
                    .searchable(text: $searchText)
                    
                } // end VStack
                .navigationBarTitle("Explore")
                
            } // End ZStack
        } // End Navigation View
    } // End Body
} // End Explore View

struct Explore_Previews: PreviewProvider {
    static var previews: some View {
        Explore()
    }
}
