//
//  SupabaseService.swift
//  basicToDo
//
//  Created by Viviana Tran on 3/29/25.
//

import Supabase
import Foundation
final class SupabaseService {
    let supabase = SupabaseClient(supabaseURL: URL(string:
                                                    "https://dqwzwmbexxeywlgzahaz.supabase.co")!,
                                  supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRxd3p3bWJleHhleXdsZ3phaGF6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDMyODQ0ODIsImV4cCI6MjA1ODg2MDQ4Mn0.XHw9az9TmSDHwh2B0L92J3SCgjBWYGmrzeX6PJPgpgI")
    static let shared = SupabaseService()
    private init() {}
    func postTodoItem(_ todo: ToDoModel) async throws -> ToDoModel {
        let item: ToDoModel = try await supabase
            .from("todos")
            .insert(todo, returning: .representation)
            .single()
            .execute()
            .value
        return item
        
    }
    func updateTodoItem(_ todo: ToDoModel) async throws {
        try await supabase
            .from("todos")
            .update(todo)
            .eq("id", value:todo.id)
            .execute()
        
    }
    func fetchTodos() async throws -> [ToDoModel] {
        return try await supabase
            .from("todos")
            .select()
            .in("user_id", values: [])
            .execute()
            .value
        
    }
    func deleteTodo(id: Int) async throws {
        try await supabase
            .from("todos")
        
            .delete()
            .eq("id", value: id)
            .execute()
        
    }
}
