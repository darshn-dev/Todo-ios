//
//  CategoryViewController.swift
//  Todo-iOS
//
//  Created by Darshan on 03/07/21.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryList = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
    
    func loadCategory(with request:NSFetchRequest<Category> = Category.fetchRequest()) {
        do{
        try categoryList = context.fetch(request)
        }catch{
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryList[indexPath.row].name
        return cell
    }
    
    func saveCategory()  {
        do{
            try self.context.save()
            tableView.reloadData()
        }catch{
            print("")
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryList.append(newCategory)
            self.saveCategory()
            
        }
        
        alert.addAction(action)
        alert.addTextField { (UITextField) in
            textField = UITextField
            textField.placeholder = "Add new category"
        }
       present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListController
        if  let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryList[indexPath.row]
        }
    }
    
}
