//
//  TagsListViewModel.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/19/23.
//

import Foundation
import SwiftUI

/// Models the data used in the `TagsList` view.
class TagsListViewModel: ObservableObject {
    @Published var tags = [Tag]()
    
    func fetchTags() async throws {
        let tags = try await HTTP.get(url: URL(string: "http://127.0.0.1:8080/tags/")!, dataType: [Tag].self)
        
        DispatchQueue.main.async {
            self.tags = tags
        }
    }
}
