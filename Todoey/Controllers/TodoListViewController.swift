//
//  ViewController.swift
//  Todoey
//
//  Created by Himanshu Chaurasiya on 18/08/19.
//  Copyright © 2019 HPC. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var currentCategory : Category?{
        didSet{
            loadItemData()
        }
    }
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadItemData()
    }

    //MARK: - tableView DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ?  .checkmark : .none
        
        return cell 
    }

    
    //MARK: - tableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItemData()
        tableView.deselectRow(at: indexPath, animated: true)
        //tableView.reloadData()
    }
    
    //MARK: - AddNewItem
    @IBAction func addNewItemAction(_ sender: UIBarButtonItem) {
        
        var inputTextField : UITextField?
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Added")
            if let str = inputTextField!.text{
                let newItem = Item(context: self.context)
                newItem.title = str
                newItem.done = false
                newItem.parentCategory = self.currentCategory
                self.itemArray.append(newItem)
                self.saveItemData()
            }
            else{
                print("Null value")
            }
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            inputTextField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItemData() {
        do{
            try context.save()
            tableView.reloadData()
        }
        catch{
            print("Error in array ,\(error)")
        }
    }
    
    func loadItemData(with request : NSFetchRequest<Item> = Item.fetchRequest(), searchPredicate : NSPredicate? = nil) {
        
        var categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", currentCategory!.name!)
        
        if let pradicate = searchPredicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,pradicate])
        }
        else{
            request.predicate = categoryPredicate
        }
        
            do{
                itemArray = try context.fetch(request)
            }
            catch{
                print("Error fetching data from contex \(error)")
            }
        tableView.reloadData()
        }
}

//MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let p = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItemData(with: request, searchPredicate: p)
        
        print(searchBar.text!)
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

