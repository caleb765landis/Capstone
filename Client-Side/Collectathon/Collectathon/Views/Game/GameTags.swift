//
//  GameTags.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/27/23.
//

import SwiftUI

struct GameTags: View {
    @State private var inCollection = false
    
    var body: some View {
        VStack (alignment: .center){
            
            HStack (alignment: .center) {
                Spacer()
                Text("Tags")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            Spacer(minLength: 10)
            
            HStack(alignment: .center) {
                Toggle(isOn: $inCollection) {
                    Text("Collection")
                    //                    .padding()
                }
                .padding(.horizontal, 80)
            } // End HStack
        } // end VStack
//        .padding()
    } // end body
} // end GameTags

struct GameTags_Previews: PreviewProvider {
    static var previews: some View {
        GameTags()
    }
}
