//
//  Game.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/22/23.
//

import Foundation
import SwiftUI

struct Game: View {
    @StateObject var viewModel: GameViewModel

    @State private var busy = false
    @State private var errorMessage: String?
    @State private var currentBodyView = "About"
    
    let gradient = LinearGradient(colors: [.blue, .white],
                                      startPoint: .topLeading,
                                      endPoint: .bottomTrailing)
    
    var body: some View {
        ZStack {
            gradient
                .opacity(0.25)
                .ignoresSafeArea()
            
            VStack {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } // end error
                
                // Lots of possibilites for nil values from IGDB API
                if viewModel.game != nil {
                    ScrollView {
                    
                        Spacer()
                        
                        // Start game view header
                        HStack {
                            // Game Cover Image
                            AsyncImage(url: URL(string: "https:" + (viewModel.game?.cover?.url)!), content: { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 100, maxHeight:130)
                            }
                            , placeholder: {
                                Rectangle().fill(.gray)
                                    .frame(width: 100, height: 130)
                            })
                            
                            // Game title and release date
                            VStack (alignment: .listRowSeparatorLeading) {
                                Text(viewModel.game!.name)
                                    .fontWeight(.heavy)
                                    .font(.title2)

                                if viewModel.game!.first_release_date != nil {
                                    Text(Date(timeIntervalSince1970: viewModel.game!.first_release_date!), style: .date)
                                        .fontWeight(.light)
                                } // end if release date exists
                            } // end VStack
                            .padding()
                            
                        } // End HStack
                        .padding()
                        .edgesIgnoringSafeArea(.all)
                        // End Game Header
                    
                        // Body Game Info
                        VStack(alignment: .leading) {
                            
                            Divider()
                            
                            HStack(alignment: .center) {
                                
                                Spacer()
                                
                                // About body view button
                                Button(action: {currentBodyView = "About"}) {
                                    Text("About")
                                        .foregroundColor(.black)
                                        .bold()
                                }
                                
                                Spacer()
                                
                                // Tags body view button
                                Button(action: {currentBodyView = "Tags"}) {
                                    Text("Tags")
                                        .foregroundColor(.black)
                                        .bold()
                                }
                                
                                Spacer()
                            }
                            
                            Divider()
                            Spacer(minLength: 20)
                            
                            // Defaults to About view
                            if currentBodyView == "About" {
                                About(viewModel: self.viewModel)
                                
                            // Otherwise gets all tags and each boolean value for this game
                            // Boolean determines whether game is tagged to be in a list or not
                            } else {
                                GameTags(gameName: self.viewModel.game!.name, coverURL: self.viewModel.game!.cover!.url, viewModel: GameTagsViewModel(self.viewModel.gameID))
                            } // end if
                            
                        } // end VStack
                        .padding()
                        // End body for game info
                    } // end Scroll View
                } // end if game exists
                
                if busy {
                    ProgressView()
                } // end if busy
                
            } // end VStack
            .padding()
            .onAppear(perform: fetchGame)
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                fetchGame()
            }
        } // end ZStack
        
    } // end body
    
    private func fetchGame() {
        self.busy = true
        self.errorMessage = nil
        Task {
            do {
                try await viewModel.fetchGame()
                busy = false
            } catch {
                busy = false
                errorMessage = "Failed to fetch list of tags: \(error.localizedDescription)"
            }
        } // end task
    } // end fetchGame
    
} // end Game View

// Preview for Halo: Combat Evolved
// IGDB ID: 740
struct Game_Previews: PreviewProvider {
    static var previews: some View {
        Game(viewModel: GameViewModel(740))
    }
}
