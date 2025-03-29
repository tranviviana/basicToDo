//
//  ContentView.swift
//  basicToDo
//
//  Created by Viviana Tran on 3/29/25.
//

import SwiftUI
import SwiftData

struct ToDoModel: Identifiable {
    let id = UUID()
    var title: String
    var isComplete: Bool
}

struct ContentView: View {
    @State var todos = [ToDoModel(title:"Homework", isComplete: false)]
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
            VStack {
                ForEach(todos.indices, id: \.self) { idx in
                    Button {
                        withAnimation {
                            todos[idx].isComplete.toggle()
                        }
                    } label: {
                        HStack{
                            Image(systemName:  todos[idx].isComplete ? "checkmark.circle.fill" : "circle")
                            Text( todos[idx].title)
                                .strikethrough(todos[idx].isComplete, color: Color.gray)
                            
                            
                        }
                        .foregroundColor(Color.main)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color(.secondary))
                        )
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
                                if newToDoTitle.count > 2 {
                                    todos.append(ToDoModel(title: newToDoTitle, isComplete: false))
                                }
                            } label: {
                                Text("Done")
                                    .foregroundStyle(.red)
                                
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
        
}
