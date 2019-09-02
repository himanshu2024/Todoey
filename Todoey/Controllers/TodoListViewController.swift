//
//  ViewController.swift
//  Todoey
//
//  Created by Himanshu Chaurasiya on 18/08/19.
//  Copyright © 2019 HPC. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    let realm = try! Realm()
    
    var currentCategory : Category?{
        didSet{
            loadItemData()
        }
    }
    var todoItems: Results<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadItemData()
    }

    //MARK: - tableView DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ?  .checkmark : .none

        }
        else
        {
            cell.textLabel?.text = "Empty"

        }
        
        
        return cell 
    }

    
    //MARK: - tableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }
            catch{
                print("Error in saving done \(error)")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    //MARK: - AddNewItem
    @IBAction func addNewItemAction(_ sender: UIBarButtonItem) {
        
        var inputTextField : UITextField?

        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Added")
            if let cat = self.currentCategory{
                do{
                    try self.realm.write {
                        let item = Item()
                        item.title = inputTextField?.text! ?? "Default"
                        item.dateCreated = Date()
                        cat.items.append(item)
                    }
                }
                catch{
                    print(error)
                }
            }
            else{
                print("Null value")
            }

            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            inputTextField = alertTextField
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
    
    
    
    func loadItemData() {

        todoItems = currentCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
        }
}

//MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)

        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItemData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

