//
//  Todos.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/26/23.
//

import SwiftUI

struct Todos: View {
    @StateObject private var viewModel = TodosListViewModel()

    @State private var showingAddModal = false
    @State private var busy = false
    @State private var errorMessage: String?
    
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.todos) { todo in
                    Text(todo.title)
                        .font(.title3)
                }
            }
            .refreshable {
                fetchTodos()
            }

        
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        // When the view appears, retrieve an updated list of kittens.
        .onAppear(perform: fetchTodos)
        .navigationBarTitle("Todos", displayMode: .inline)
    } // end body
    
    private func fetchTodos() {
        self.busy = true
        self.errorMessage = nil
        Task {
            do {
                try await viewModel.fetchTodos()
                busy = false
            } catch {
                busy = false
                errorMessage = "Failed to fetch list of todos: \(error.localizedDescription)"
            }
        }
    } // end fetch todos
} // end Todos

struct Todos_Previews: PreviewProvider {
    static var previews: some View {
        Todos()
    }
}
