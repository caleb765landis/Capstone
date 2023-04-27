//
//  Game.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/22/23.
//

import Foundation
import SwiftUI

struct URLImage: View {
    let urlString: String
    
    @State var data: Data?
    
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
//                .aspectRatio(contentMode: .fill)
                .background(Color.gray)
                .frame(maxWidth: 100, maxHeight: 100)
        } else {
            Image("")
                .resizable()
//                .aspectRatio(contentMode: .fill)
                .background(Color.gray)
                .frame(maxWidth: 100, maxHeight: 130)
                .onAppear {
                    fetchData()
                }
        }
    } // end Body
    
    private func fetchData() {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.data = data
        }
        task.resume()
    }
    
} // end URLImage View

struct Game: View {
//    let gameID: Int
//    @StateObject var game: Game_LongInfo
    @StateObject var viewModel: GameViewModel
//
//    @State private var showingAddModal = false
    @State private var busy = false
    @State private var errorMessage: String?
    
    @State private var selectedTab: Int = 0
        let tabs: [Tab] = [
            .init(title: "About"),
            .init(title: "Tags")
        ]
    
    var body: some View {
        NavigationView {
            
            GeometryReader { geo in
                
                ZStack {
                    
                    
                    VStack {
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                        }
                        
                        if viewModel.game != nil {
                            
                            // Header Game Info
                            HStack {
                                if viewModel.game?.cover != nil {
                                    URLImage(urlString: viewModel.game!.cover!.url)
                                }
                                
                                //                        Spacer()
                                
                                VStack (alignment: .listRowSeparatorLeading) {
                                    Text(viewModel.game!.name)
                                        .fontWeight(.heavy)
                                        .font(.title2)
                                    
                                    if viewModel.game!.first_release_date != nil {
                                        //                                    let dateFormatter = DateFormatter()
                                        //                                    dateFormatter.dateStyle = .medium
                                        //                                    dateFormatter.timeStyle = .none
                                        //                                    dateFormatter.locale = Locale.current
                                        //                                    Text("\(dateFormatter.string(from: Date(timeIntervalSince1970: viewModel.game!.first_release_date!)))")
                                        Text(Date(timeIntervalSince1970: viewModel.game!.first_release_date!), style: .date)
                                            .fontWeight(.light)
                                    }
                                } // end VStack
                                .padding()
                            } // end HStack
                            .padding()
                            .background(.ultraThickMaterial)
                            .edgesIgnoringSafeArea(.all)
                            
                            //                        Menu(/*@START_MENU_TOKEN@*/"Menu"/*@END_MENU_TOKEN@*/) {
                            //                            /*@START_MENU_TOKEN@*/Text("Menu Item 1")/*@END_MENU_TOKEN@*/
                            //                            /*@START_MENU_TOKEN@*/Text("Menu Item 2")/*@END_MENU_TOKEN@*/
                            //                            /*@START_MENU_TOKEN@*/Text("Menu Item 3")/*@END_MENU_TOKEN@*/
                            //                        }
                            
                            Tabs(tabs: tabs, geoWidth: geo.size.width, selectedTab: $selectedTab)
                            
                            TabView (selection: $selectedTab,
                        content: {
                                
                                // Body Game Info
                                VStack (alignment: .listRowSeparatorLeading){
                                    
                                    Divider()
                                    
                                    
                                    
                                    
                                    if viewModel.game!.genres != nil {
                                        
                                        Section {
                                            VStack (alignment: .listRowSeparatorLeading) {
                                                Text("Genres")
                                                    .font(.title2)
                                                    .fontWeight(.heavy)
                                                ForEach(viewModel.game!.genres!) { genre in
                                                    Text("      -" + genre.name)
                                                }
                                            }
                                            .padding()
                                        }
                                    }
                                    
                                    if viewModel.game!.platforms != nil {
                                        Section {
                                            VStack (alignment: .listRowSeparatorLeading) {
                                                Text("Platforms")
                                                    .font(.title2)
                                                    .fontWeight(.heavy)
                                                ForEach(viewModel.game!.platforms!) { platform in
                                                    Text("      -" + platform.name)
                                                }
                                            }
                                            //                                    .padding()
                                        }
                                    }
                                    
                                    if viewModel.game!.summary != nil {
                                        Section {
                                            VStack (alignment: .listRowSeparatorLeading) {
                                                Text("Summary")
                                                    .font(.title2)
                                                    .fontWeight(.heavy)
                                                Text(viewModel.game!.summary!)
                                            }
                                            .padding()
                                        }
                                    }
                                } // end VStack
                                //                        .padding()
                                .background(Color.white)
//                                .tabItem { Label("About", systemImage: "list.dash") }.tag(1)
                                .tag(0)
//                                Text("Tab Content 2").tabItem { Label("Tags", systemImage: "list.dash") }.tag(2)
                                Text("Tab Content 2")
                                .tag(1)
                                
                                
                            }) // end of TabView
//                            .tabViewStyle(.automatic)
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            
                        } // end if
                        
                    } // end VStack
                    .refreshable {
                        fetchGame()
                    }
                } // end refreshable
                .background(.ultraThickMaterial)
                .edgesIgnoringSafeArea(.all)
                .padding()
                
                if busy {
                    ProgressView()
                } // end if busy
                
            }
        } // end NavigationView
        .onAppear(perform: fetchGame)
        .navigationViewStyle(.stack)
        .navigationBarTitleDisplayMode(.inline)
        .background(.ultraThickMaterial)
        
        
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
