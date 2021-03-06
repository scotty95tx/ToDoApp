//
//  ToDoApi.swift
//  ToDoAppUIKit
//
//  Created by Scott Lowe on 4/1/22.
//

import Foundation

final class ToDoListAPI {
    
    static let shared = ToDoListAPI()
    
    func fetchToDoList(onCompletion: @escaping ([ToDo]) -> ()) {
        let urlString = "https://jsonplaceholder.typicode.com/todos"
        // don't force unwrap, instead use a guard and throw an error. If this were to fail, the app would crash.
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, resp, error) in
            
            guard let data = data else {
                print("data was nil for some reason")
                return
            }
            
            guard let toDoList = try? JSONDecoder().decode([ToDo].self, from: data) else {
                print("coudn't decode JSON")
                return
            }
            
            onCompletion(toDoList)
        }
        
        task.resume()
    }
}

// put this in a separate file
struct ToDo: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}



