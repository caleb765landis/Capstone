//
//  About.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/27/23.
//

import SwiftUI

struct About: View {
    @StateObject var viewModel: GameViewModel
    
    @State private var busy = false
    @State private var errorMessage: String?
    
    var body: some View {
            
        VStack (alignment: .leading) {
            
            // About Title
            HStack (alignment: .center) {
                
                Spacer()
                
                Text("About")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
            }
            Spacer(minLength: 10)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } // end error
            
            // More possible nil values from IGDB
            
            // List of genres
            if viewModel.game!.genres != nil {
                Section {
                    VStack (alignment: .listRowSeparatorLeading) {
                        Text("Genres")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .padding(.bottom, 1.0)
                        ForEach(viewModel.game!.genres!) { genre in
                            Text("      -" + genre.name)
                        } // end ForEach Genre
                    }
                    Spacer(minLength: 20)
                }
            } // End if genres exists
            
            // List of platforms
            if viewModel.game!.platforms != nil {
                Section {
                    VStack (alignment: .listRowSeparatorLeading) {
                        Text("Platforms")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .padding(.bottom, 1.0)
                        ForEach(viewModel.game!.platforms!) { platform in
                            Text("      -" + platform.name)
                        } // end ForEach Platform
                    }
                    Spacer(minLength: 20)
                }
            } // End if platforms exists
            
            // Game Summary
            if viewModel.game!.summary != nil {
                Section {
                    VStack (alignment: .listRowSeparatorLeading) {
                        Text("Summary")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .padding(.bottom, 1.0)
                        Text(viewModel.game!.summary!)
                    }
                    Spacer(minLength: 20)
                }
            } // end if game summary exists
            
        } // End VStack
        .onAppear(perform: fetchGame)
        
    } // End Body
    
    private func fetchGame() {
        self.busy = true
        self.errorMessage = nil
        Task {
            do {
                try await viewModel.fetchGame()
                busy = false
            } catch {
                busy = false
                errorMessage = "Failed to get game's info: \(error.localizedDescription)"
            }
        } // end task
    } // end fetchGame
} // end About View

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About(viewModel: GameViewModel(740))
    }
}
