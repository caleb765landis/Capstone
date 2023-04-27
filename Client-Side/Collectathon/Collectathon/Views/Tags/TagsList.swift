//
//  TagsList.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/19/23.
//

import Foundation
import SwiftUI

struct TagsList: View {
    @StateObject private var viewModel = TagsListViewModel()

    @State private var showingAddModal = false
    @State private var busy = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                    
                    List {
                        ForEach(viewModel.tags) { tag in
                            
                            // Each element in the list is a link that, if clicked, will open the view/update/delete
                            // view for the corresponding kitten.
                            NavigationLink(
                                destination: TaggedGamesList(
                                    viewModel: TaggedGamesListViewModel(currentTag: tag)
                                )
                            ) {
                                Text(tag.tagName)
                                    .font(.title3)
                            } // end NavigationLink
                            
                        }
                    }
                    .refreshable {
                        fetchTags()
                    }
                    
                    
//                    Image(systemName: "globe")
//                        .imageScale(.large)
//                        .foregroundColor(.accentColor)
//                    Text("Hello, world!")
//                    .padding()
                } // end VStack
                if busy {
                    ProgressView()
                } // end if busy
            } // end ZStack
            // When the view appears, retrieve an updated list of kittens.
            .onAppear(perform: fetchTags)
            .navigationBarTitle("Todos", displayMode: .inline)
        } // end NavigationView
        .navigationViewStyle(.stack)
    } // end body
    
    private func fetchTags() {
        self.busy = true
        self.errorMessage = nil
        Task {
            do {
                try await viewModel.fetchTags()
                busy = false
            } catch {
                busy = false
                errorMessage = "Failed to fetch list of tags: \(error.localizedDescription)"
            }
        } // end task
    } // end fetch tags
}

struct TagsList_Previews: PreviewProvider {
    static var previews: some View {
        TagsList()
    }
}
