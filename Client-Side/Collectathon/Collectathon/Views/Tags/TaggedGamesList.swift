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
    
    var body: some View {
        ZStack {
            Color.blue
                .opacity(0.25)
                .ignoresSafeArea()
            
            VStack {
                List {
                    ForEach(viewModel.games) { game in
                        NavigationLink(destination: Game(viewModel: GameViewModel(game.id)))
                        {
                            HStack {
                                AsyncImage(url: URL(string: game.cover.url)!, content: { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 100, maxHeight: 130)
                                }, placeholder: {
                                    Rectangle().fill(.gray)
                                        .frame(width: 100, height: 130)
                                })
                                Text(game.name)
                            } // End HStack
                        } // End Navigation Link
                    } // end For Each
                } // end List
                .listStyle(.plain)
//                    .searchable(text: $searchText)
                .onChange(of: searchText) { value in
                    Task {
                        if !value.isEmpty &&  value.count > 3 {
                            try await viewModel.search(name: value.trimmingCharacters(in: .whitespacesAndNewlines))
                        } else {
                            viewModel.games.removeAll()
                        }
                    }
                } // end on change
            } // End VStack
            .navigationTitle(viewModel.tag.tagName)
        } // End ZStack
    } // End body
} // End Tagged Games List

struct TaggedGamesList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TaggedGamesList(viewModel: TaggedGamesListViewModel(currentTag: Tag(id: "319AF6AD-D84A-4BEE-981B-4E392B878D2A", userID: "E4D4CBE6-B620-4822-A6C2-D9F79C6A3BDC", tagName: "Collection")))
        }
    }
}
