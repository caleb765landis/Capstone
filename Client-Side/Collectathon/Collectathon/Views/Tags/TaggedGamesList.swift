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
    @State private var searchText: String = ""
    
//    public init(viewModel: TaggedGamesListViewModel) {
//
//    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.games) { game in
                    NavigationLink(destination: Game(viewModel: GameViewModel(game.id))) {
                        //                    NavigationLink(destination: Game()) {
                        HStack {
                            AsyncImage(url: URL(string: game.cover.url)!, content: { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 100)
                            }, placeholder: {
                                ProgressView()
                            })
                            Text(game.name)
                        }
                    }
                }
            }.listStyle(.plain)
            .searchable(text: $searchText)
            .onChange(of: searchText) { value in
                async {
                    if !value.isEmpty &&  value.count > 3 {
                        try await viewModel.search(name: value.trimmingCharacters(in: .whitespacesAndNewlines))
                    } else {
                        viewModel.games.removeAll()
                    }
                }
            }
            .navigationTitle(viewModel.tag.tagName)
        }
    }
}

    
//    @StateObject private var viewModel = TagsListViewModel()
//
//    @State private var showingAddModal = false
//    @State private var busy = false
//    @State private var errorMessage: String?
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                VStack {
//                    if let errorMessage = errorMessage {
//                        Text(errorMessage)
//                            .foregroundColor(.red)
//                    }
//
//                    List {
//                        ForEach(viewModel.tags) { tag in
//
//                            // Each element in the list is a link that, if clicked, will open the view/update/delete
//                            // view for the corresponding kitten.
//                            NavigationLink(
//                                destination: ViewUpdateDeleteKitten(
//                                    viewModel: ViewUpdateDeleteKittenViewModel(currentKitten: kitten)
//                                )
//                            ) {
//                                Text(tag.tagName)
//                                    .font(.title3)
//                            } // end NavigationLink
//
//                        }
//                    }
//                    .refreshable {
//                        fetchTags()
//                    }
//
//
////                    Image(systemName: "globe")
////                        .imageScale(.large)
////                        .foregroundColor(.accentColor)
////                    Text("Hello, world!")
////                    .padding()
//                } // end VStack
//                if busy {
//                    ProgressView()
//                } // end if busy
//            } // end ZStack
//            // When the view appears, retrieve an updated list of kittens.
//            .onAppear(perform: fetchTags)
//            .navigationBarTitle("Todos", displayMode: .inline)
//        } // end NavigationView
//        .navigationViewStyle(StackNavigationViewStyle())
//    } // end body
    
//    private func fetchTags() {
//        self.busy = true
//        self.errorMessage = nil
//        Task {
//            do {
//                try await viewModel.fetchTags()
//                busy = false
//            } catch {
//                busy = false
//                errorMessage = "Failed to fetch list of tags: \(error.localizedDescription)"
//            }
//        } // end task
//    } // end fetch tags

struct TaggedGamesList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TaggedGamesList(viewModel: TaggedGamesListViewModel(currentTag: Tag(id: "0", userID: "1", tagName: "Collection")))
        }
    }
}
