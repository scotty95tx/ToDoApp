//
//  ViewController.swift
//  ToDoAppUIKit
//
//  Created by Scott Lowe on 4/1/22.
//

import UIKit

class ToDoListVC: UIViewController {
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    var toDoList = [ToDo]()

    override func viewDidLoad() {
        // using .systemBackground makes it compatible with light / dark mode immediately
        view.backgroundColor = .systemBackground
        safeArea = view.layoutMarginsGuide
        setUpTableView()
        
        let anonymousFunction = { (fetchedToDoList: [ToDo]) in
            DispatchQueue.main.async {
                self.toDoList = fetchedToDoList
                self.tableView.reloadData()
            }
        }
        
        ToDoListAPI.shared.fetchToDoList(onCompletion: anonymousFunction)
    }
    
    // MARK: - Setup View
    
    func setUpTableView() {
        // Always add the UIView first before setting constraints
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
//        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // I prefer to do constrants in this way, because you don't have to remember to type `isActive = true`. Follow this pattern for my projects.
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }


}

// MARK: - UITableViewDataSource

extension ToDoListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // In my projects, abstract everything in this `cellForRowAt` into a function. Better yet use a custom UITableViewCell and put the code into that custom cell.
        // This is a simple example, so it's fine here, but for reference
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        
        let toDo = toDoList[indexPath.row]
        cell.textLabel?.text = toDo.title
        
        // Don't use == true
        // Instead do: if toDo.completed {
        // The == true is inferred because it's a boolean
        if toDo.completed == true {
            cell.imageView?.image = UIImage(systemName: "checkmark")
        } else {
            cell.imageView?.image = UIImage(systemName: "multiply")
        }
        return cell
    }
    
    
}

