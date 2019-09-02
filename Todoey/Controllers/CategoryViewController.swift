//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Himanshu Chaurasiya on 31/08/19.
//  Copyright © 2019 HPC. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategoryData()

    }
    
    //MARK: - tableView DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryViewCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "Empty"
        
        
        return cell
    }
    
    
    //MARK: - tableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        performSegue(withIdentifier: "itemIdentifier", sender: self)
    }
   
    
    //MARK: - AddNewItem
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        var inputField : UITextField?
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = inputField!.text{
                let newCat = Category()
                newCat.name = text
                self.save(category: newCat)
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Category"
            inputField = textField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func save(category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
            tableView.reloadData()
        } catch {
            print("Error in saving category data: \(error)")
        }
    }
    
    func loadCategoryData(){
        categoryArray = realm.objects(Category.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemIdentifier"{
            let destinationVC = segue.destination as! TodoListViewController
            if let x = tableView.indexPathForSelectedRow{
                destinationVC.currentCategory = categoryArray?[x.row]
            }
        }
    }

}
