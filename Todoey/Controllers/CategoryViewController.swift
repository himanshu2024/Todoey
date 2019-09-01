//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Himanshu Chaurasiya on 31/08/19.
//  Copyright © 2019 HPC. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    var index = 0
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategoryData()

    }
    
    //MARK: - tableView DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryViewCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        
        return cell
    }
    
    
    //MARK: - tableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        index = indexPath.row
        performSegue(withIdentifier: "itemIdentifier", sender: self)
    }
   
    
    //MARK: - AddNewItem
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        var inputField : UITextField?
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = inputField!.text{
                let newCat = Category(context: self.context)
                newCat.name = text
                self.categoryArray.append(newCat)
                self.saveCategoryData()
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Category"
            inputField = textField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveCategoryData() {
        do {
            try context.save()
            tableView.reloadData()
        } catch {
            print("Error in saving category data: \(error)")
        }
    }
    
    func loadCategoryData(){
        do {
            let request : NSFetchRequest<Category> = Category.fetchRequest()
            categoryArray = try context.fetch(request)
        } catch  {
            print("Error in reading form Cotegory \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemIdentifier"{
            let destinationVC = segue.destination as! TodoListViewController
            if let x = tableView.indexPathForSelectedRow{
                destinationVC.currentCategory = categoryArray[x.row]
            }
        }
    }

}
