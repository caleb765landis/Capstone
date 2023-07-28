//
//  Profile.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/27/23.
//

import SwiftUI

struct Profile: View {
    @StateObject private var viewModel = ProfileViewModel()

    @State private var busy = false
    @State private var errorMessage: String?
    
    var body: some View {
        
        ZStack {
            Color.blue
                .opacity(0.25)
                .ignoresSafeArea()
            
            VStack () {
                HStack {
                    
                    Spacer()
                    
                    Text("Profile")
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                    
                }
                .padding()
                
                VStack (alignment: .leading) {
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    // List names and number of games tagged for each one
                    ForEach(viewModel.tags) { tag in
                        Text(tag.tagName + ": " + String(tag.count))
                            .font(.title3)
                        
                    }
                    .scrollContentBackground(.hidden)
                    .refreshable {
                        fetchTags()
                    } // end refreshable list
                    
                } // end VStack
                
                if busy {
                    ProgressView()
                } // end if busy
                
            } // end VStack
        } // end ZStack
        .onAppear(perform: fetchTags)
        
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
    
} // end Profile view

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
