//
//  ProfileViewModel.swift
//  Collectathon
//
//  Created by Caleb Landis on 7/27/23.
//

import Foundation
import SwiftUI

/// Models the data used in the `TagsList` view.
class ProfileViewModel: ObservableObject {
    @Published var tags = [TagWithCount]()
    
    func fetchTags() async throws {
        let tags = try await HTTP.get(url: URL(string: "http://127.0.0.1:8080/tags/")!, dataType: [Tag].self)
        
        var tagsWithCount = [TagWithCount]()
        
        for tag in tags {
            let count = try await getCounts(tag)
            
//            let tempTagWithCount = TagWithCount()
//            tag.tagName = tag
            
            tagsWithCount.append(TagWithCount(id: tag.id, tagName: tag.tagName, count: count))
        }
        
        // we do this on the main queue so that when the value is updated the view will automatically be refreshed.
        DispatchQueue.main.async {
            self.tags = tagsWithCount
        }
    }
    
    func getCounts(_ tag: Tag) async throws -> Int {
        let count = try await HTTP.get(url: URL(string: "http://127.0.0.1:8080/tags/\(tag.id)/count/")!, dataType: Int.self)
        let _ = print(count)
        
        return count
    }
}
