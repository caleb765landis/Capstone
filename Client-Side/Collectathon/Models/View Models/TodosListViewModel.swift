//
//  GamesListViewModel.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/19/23.
//

import Foundation
import SwiftUI

public struct Todo: Identifiable, Codable {
    public var id: String
    public let title: String

    public init(
        id: String,
        title: String
    ) {
        self.id = id
        self.title = title
    }
}

/// Models the data used in the `ContentView` view.
class TodosListViewModel: ObservableObject {
    @Published var todos = [Todo]()
    
    func fetchTodos() async throws {
        let todos = try await HTTP.get(url: URL(string: HTTP.baseURL + "/todos/")!, dataType: [Todo].self)
        
        // we do this on the main queue so that when the value is updated the view will automatically be refreshed.
        DispatchQueue.main.async {
            self.todos = todos
        }
    }
}
    

