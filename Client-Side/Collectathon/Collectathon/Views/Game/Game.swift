//
//  Game.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/22/23.
//

import Foundation
import SwiftUI

struct Game: View {
//    let gameID: Int
//    @StateObject var game: Game_LongInfo
    @StateObject var viewModel: GameViewModel
//
//    @State private var showingAddModal = false
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
                
                if viewModel.game != nil {
                    ScrollView {
                    
                        Spacer()
                        
                        // Start game view header
                        HStack {
                            if viewModel.game?.cover != nil {
                               URLImage(urlString: viewModel.game!.cover!.url)
                            } else {
                                Image("")
                                    .resizable()
                    //                .aspectRatio(contentMode: .fill)
                                    .background(Color.gray)
                                    .frame(width: 100, height: 130)
                            } // end if cover exists
                            
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
    //                    .background(.ultraThickMaterial)
                        .edgesIgnoringSafeArea(.all)
                        // End Game Header
                    
                        // Body Game Info
//                        VStack (alignment: .listRowSeparatorLeading) {
                        VStack(alignment: .leading) {
                            
                            Divider()
                            
                            
                            HStack(alignment: .center) {
                                
                                Spacer()
                                
                                Button(action: {currentBodyView = "About"}) {
                                    Text("About")
                                        .foregroundColor(.black)
                                        .bold()
                                }
                                
                                Spacer()
                                
                                Button(action: {currentBodyView = "Tags"}) {
                                    Text("Tags")
                                        .foregroundColor(.black)
                                        .bold()
                                }
                                
                                Spacer()
                            }
                            
                            Divider()
                            Spacer(minLength: 20)
                            
                            if currentBodyView == "About" {
                                About(viewModel: self.viewModel)
                            } else {
                                Text("Tags")
                            }
                            
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
        
        


struct Game_Previews: PreviewProvider {
    static var previews: some View {
        Game(viewModel: GameViewModel(740))
    }
}