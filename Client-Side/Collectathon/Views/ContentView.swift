//
//  ContentView.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/19/23.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TodosListViewModel()

    @State private var busy = false
    @State private var errorMessage: String?
    
    var body: some View {
        
        VStack {
            TabView() {
                Explore()
                    .tabItem {
                        Label("Explore", systemImage: "square.split.2x2.fill")
                    }
                
                TagsList()
                    .tabItem {
                        Label("Lists", systemImage: "list.bullet.rectangle")
                    }
                
                Profile()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle.fill")
                    }
            } // end TabView
        } // end VStack
        .background(
            .blue
            .opacity(0.25)
        ) // end background
        
    } // end body
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
