//
//  GameTags.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/27/23.
//

import SwiftUI

struct GameTags: View {
    @State private var vibrateOnRing = false
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
            Toggle("Vibrate on Ring", isOn: $vibrateOnRing)
        } // end VStack
        .padding()
    } // end body
} // end GameTags

struct GameTags_Previews: PreviewProvider {
    static var previews: some View {
        GameTags()
    }
}
