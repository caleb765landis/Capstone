//
//  Profile.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/27/23.
//

import SwiftUI

struct Profile: View {
    @StateObject private var viewModel = ProfileViewModel()

    @State private var showingAddModal = false
    @State private var busy = false
    @State private var errorMessage: String?
    
    var body: some View {
        
        ZStack {
            Color.blue
                .opacity(0.25)
                .ignoresSafeArea()
            
            VStack () {
//                Spacer()
                
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
                    
                        ForEach(viewModel.tags) { tag in
//                            let count = await fetchCount(tagId: tag.id)
                            
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
//                Spacer()
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
//                errorMessage = "Failed to fetch list of tags: \(error.localizedDescription)"
                errorMessage = "Failed to fetch list of tags"
            }
        } // end task
    } // end fetch tags
    
    private func fetchCount(tagId: String) async -> Int{
//        let count = try await HTTP.get(url: URL(string: "http://127.0.0.1:8080/tags/")!, dataType: Int)
        
        self.busy = true
        self.errorMessage = nil
        Task {
            do {
                let count = try await HTTP.get(url: URL(string: "http://127.0.0.1:8080/tags/")!, dataType: Int.self)
                busy = false
            } catch {
                busy = false
                errorMessage = "Failed to fetch profile"
            } // end catch
        } // end task
        
        return 0
    } // end fetchCount
    
} // end profile

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
