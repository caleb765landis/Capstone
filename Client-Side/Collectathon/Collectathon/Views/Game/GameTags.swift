//
//  GameTags.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/27/23.
//

import SwiftUI

struct GameTags: View {
    
    @StateObject var viewModel: GameTagsViewModel
    
    var body: some View {
        VStack (alignment: .center){
            
            HStack (alignment: .center) {
                Spacer()
                Text("Tags")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            
            ForEach(viewModel.tags.indices, id: \.self) { index in
//                Text(tag.tagName)
                HStack(alignment: .center) {
                    Toggle(isOn: $viewModel.tags[index].isTagged) {
                        Text(viewModel.tags[index].tagName)
                            .bold()
                    }
                    .onChange(of: viewModel.tags[index].isTagged) { isTagged in
                        if isTagged {
                            
                        } else {
                            
                        }
                    }
                    .padding(.horizontal, 80)
                } // End HStack
            } // end for each
        } // end VStack
        .onAppear {
            fetchTags()
        }
    } // end body
    
    private func fetchTags() {
//        self.busy = true
//        self.errorMessage = nil
        Task {
            do {
                try await viewModel.fetchTags()
//                busy = false
            } catch {
//                busy = false
//                errorMessage = "Failed to fetch list of tags: \(error.localizedDescription)"
            }
        } // end task
    } // end fetchGame
    
} // end GameTags

struct GameTags_Previews: PreviewProvider {
    static var previews: some View {
        GameTags(viewModel: GameTagsViewModel(740))
    }
}
