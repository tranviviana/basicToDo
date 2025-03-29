//
//  ContentView.swift
//  basicToDo
//
//  Created by Viviana Tran on 3/29/25.
//

import SwiftUI
import SwiftData

struct ToDoModel: Identifiable , Codable{
    let id : Int?
    var createdAt: Date = Date()
    var title: String
    var isComplete: Bool
    var userId: UUID
    enum CodingKeys: String, CodingKey {
        case id, title
        case isComplete = "is_complete"
        case createdAt = "created_at"
        case userId = "user_id"
    }
}

struct ContentView: View {
    @State var todos = [ToDoModel(id: nil, createdAt: .now, title:"Homework", isComplete: false, userId: UUID(uuidString: "67e56a46-6818-4748-aadc-6acfb34339ec")!)]
    @State var showAddToDo: Bool = false
    @State var newToDoTitle: String = ""
    
    init () {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ThirdColor") ?? UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ThirdColor") ?? UIColor.black]
        UINavigationBar.appearance().standardAppearance = appearance
       // UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(todos.indices, id: \.self) { idx in
                        Button {
                            withAnimation {
                                todos[idx].isComplete.toggle()
                                updateTodo(todos[idx])
                            }
                        } label: {
                            HStack{
                                Image(systemName:  todos[idx].isComplete ? "checkmark.circle.fill" : "circle")
                                Text( todos[idx].title)
                                    .strikethrough(todos[idx].isComplete, color: Color.gray)
                                
                                
                            }
                            .foregroundColor(Color.main)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .ignoresSafeArea()
                            .scrollIndicators(.hidden)
                            .padding()
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color(.second))
                            )
                        }
                        .contextMenu {
                            Button {
                                deleteItem(todo: todos[idx])
                            } label: {
                                Image(systemName: "trash.fill")
                                Text("Delete")
                            }
                        }
                       
                    }
                    
                }
            }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .background(Color(.background))
                .navigationTitle("To Do List")
                .toolbar {Button {
                    showAddToDo = true
                    
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(Color.third)
                        .font(.title2)
                }
                }
                // adding new items to to do leist
                .alert("Add Item", isPresented: $showAddToDo) {
                    
                    VStack {
                        TextField("Enter Item", text: $newToDoTitle)
                        HStack {
                            Button(role: .cancel) {
                                showAddToDo = false
                                newToDoTitle = ""
                            } label: {
                                Text("Cancel")
                                    .foregroundStyle(.red)
                                
                            }
                            Button {
                               
                                    didAddItem()
                                
                            } label: {
                                Text("Done")
                                    .foregroundStyle(.red)
                                
                            }
                        }
                    }
                }
            }
        }
    func didAddItem() {
        if newToDoTitle.count > 2 {
            let todo = ToDoModel(id: nil, createdAt: .now, title: newToDoTitle, isComplete: false, userId: UUID(uuidString: "67e56a46-6818-4748-aadc-6acfb34339ec")!)
            Task {
                do  {
                    let returnedItem = try await SupabaseService.shared.postTodoItem(todo)
                    todos.append(returnedItem)
                    newToDoTitle = ""
                } catch {
                    print(error.localizedDescription)
                }
            }
           
        }
    }
    func updateTodo(_ todo: ToDoModel) {
        Task {
            do {
                try await SupabaseService.shared.updateTodoItem(todo)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    func deleteItem(_ todo: ToDoModel) {
        Task {
            do {
                
                guard let id = todo.id
                else { return }
                print(id)
                try await SupabaseService.shared.deleteTodo(id: id)
                todos.removeAll { $0.id == todo.id }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
   
}


#Preview {
    ContentView()
        
}
