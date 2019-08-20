//
//  ViewController.swift
//  Todoey
//
//  Created by Himanshu Chaurasiya on 18/08/19.
//  Copyright © 2019 HPC. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()// [Item(name : "Find Milk"),Item(name : "Bug Eggos"),Item(name : "Destory Demogorgon")]
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //print(dataFilePath)
//        if let list = defaults.array(forKey: "TodoListArray"){
//            itemArray = list as! [Item]
//        }
        loadItemData()
    }

    //MARK - tableView DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].name
        
        cell.accessoryType = itemArray[indexPath.row].checked ?  .checkmark : .none
        
        return cell 
    }

    //MARK - tableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        saveItemData()
        tableView.deselectRow(at: indexPath, animated: true)
        //tableView.reloadData()
    }
    
    //MARK - AddNewItem
    @IBAction func addNewItemAction(_ sender: UIBarButtonItem) {
        
        var inputTextField : UITextField?
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Added")
            if let str = inputTextField!.text{
                    self.itemArray.append(Item(name : str))
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
        let encoded = PropertyListEncoder()
        do{
        let data = try encoded.encode(itemArray)
           try data.write(to: dataFilePath!)
            
            tableView.reloadData()
        }
        catch{
            print("Error in array ,\(error)")
        }
    }
    
    func loadItemData() {
        if let data  = try? Data(contentsOf: dataFilePath!){
            let decode = PropertyListDecoder()
            do{
            itemArray = try decode.decode([Item].self, from: data)
            }catch{
                print("Error decoding item Array, \(error)")
            }
        }
    }
}

