//
//  ViewController.swift
//  Todoey
//
//  Created by Himanshu Chaurasiya on 18/08/19.
//  Copyright © 2019 HPC. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Find Milk","Bug Eggos","Destory Demogorgon"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    //MARK - tableView DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell 
    }

    //MARK - tableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else
        {
                    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        

        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - AddNewItem
    @IBAction func addNewItemAction(_ sender: UIBarButtonItem) {
        
        var inputTextField : UITextField?
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Added")
            if let str = inputTextField!.text{
                    self.itemArray.append(str)
                self.tableView.reloadData()
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
}

