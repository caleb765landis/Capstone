//
//  GameTagsViewModel.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/27/23.
//

import Foundation
import SwiftUI

/// Models the data used in the `GameTags` view.
class GameTagsViewModel: ObservableObject {
    @Published var tags = [TagWithBool]()
    
    func fetchTags() async throws {
        let tags = try await HTTP.get(url: URL(string: "http://127.0.0.1:8080/tags/")!, dataType: [Tag].self)
        
        let tagsWithBools = [TagWithBool]()
        
        for tag in tags {
            
        }
        
        // we do this on the main queue so that when the value is updated the view will automatically be refreshed.
        DispatchQueue.main.async {
            self.tags = tagsWithBools
        }
    }
}

