//
//  Profile.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/27/23.
//

import SwiftUI

struct Profile: View {
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
                    Text("Completed: 0")
                    Text("Collection: 0")
                    Text("Wish List: 0")
                    Text("Back Log: 0")
                }
//                Spacer()
            }
        } // end VStack
        
    } // end body
} // end profile

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
