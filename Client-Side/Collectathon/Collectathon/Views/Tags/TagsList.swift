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
                        ForEach(viewModel.tags) { tag in
                            NavigationLink(
                                destination: TaggedGamesList(
                                    viewModel: TaggedGamesListViewModel(currentTag: tag)
                                )
                            ) {
                                Text(tag.tagName)
                                    .font(.title3)
                            } // end NavigationLink
                            
                        }
                    } // end list
                    .scrollContentBackground(.hidden)
                    .refreshable {
                        fetchTags()
                    } // end refreshable list
                } // end VStack
                if busy {
                    ProgressView()
                } // end if busy
            } // end ZStack
            .onAppear(perform: fetchTags)
            .navigationBarTitle("Lists")
        } // end NavigationView
//        .navigationViewStyle(.stack)
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
