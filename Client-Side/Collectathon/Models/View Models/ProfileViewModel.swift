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
        // lists of tags
        let tags = try await HTTP.get(url: URL(string: HTTP.baseURL + "/tags/")!, dataType: [Tag].self)
        
        // temporary array
        var tagsWithCount = [TagWithCount]()
        
        // get count for each tag
        for tag in tags {
            let count = try await getCounts(tag)
            tagsWithCount.append(TagWithCount(id: tag.id, tagName: tag.tagName, count: count))
        }
        
        DispatchQueue.main.async {
            self.tags = tagsWithCount
        }
    } // end fetchTags
    
    func getCounts(_ tag: Tag) async throws -> Int {
        let count = try await HTTP.get(url: URL(string: HTTP.baseURL + "/tags/\(tag.id)/count/")!, dataType: Int.self)
        let _ = print(count)
        
        return count
    }
}
