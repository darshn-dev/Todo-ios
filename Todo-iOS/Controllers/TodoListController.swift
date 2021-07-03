//
//  ViewController.swift
//  Todo-iOS
//
//  Created by Darshan on 30/06/21.
//
//Available Data storage option in iOS
//UserDefaults
//Codable
//KeyChain
//SQLite - alot of data
//CoreData - already using SQLite, use it as wrapper
//Realm -- easy to implement

import UIKit
import CoreData

class TodoListController: UITableViewController {
    
    var itemArray = [Item]()
    //store value in key value pair, UserDefaults
    let dafaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as!  AppDelegate).persistentContainer.viewContext
    
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    //store data in the file as list, Codable
    //flash freeze custom object
    //Not good, becoz it loads while plist even if i want to use single value.
    //dont use if data is huge
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        // Do any additional setup after loading the view.
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil)  {
        
        let catPredicate = NSPredicate(format: "parentCategory.name MATCHES %@",  selectedCategory!.name!)
      
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catPredicate, additionalPredicate])
        }else{
            request.predicate = catPredicate
        }
        
     
       
        do{
            itemArray =  try self.context.fetch(request)
        }catch{
            print("error while getting ")
        }
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text=itemArray[indexPath.row].title
        let singleItem = itemArray[indexPath.row]
        
        cell.accessoryType = singleItem.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done =  !itemArray[indexPath.row].done
        
        
        //self.context.delete(itemArray[indexPath.row])
        self.saveItems()
        //itemArray.remove(at: indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Adding new item
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertText = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //Do something allclick
            
            let item = Item(context: self.context)
            item.title = alertText.text!
            item.done = false
            item.parentCategory = self.selectedCategory
            self.itemArray.append(item)
            
            self.saveItems()
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new item"
            alertText = alertTextField
            
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveItems(){
        //  let encoder = PropertyListEncoder()
        do{
            // let data = try encoder.encode(itemArray)
            // try data.write(to:dataFilePath!)
            try  self.context.save()
        }catch{
            print("Error while saving message\(error)")
        }
        
    }
    
}

//MARK: - search bar methods
extension TodoListController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
       
        //Querying
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
       // request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
      loadItems(with: request, predicate: predicate)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
          
        }
        
      
    }
}


/**
 Entity - table
 Persistant Container - SQLite
 
 User Context to communicate with SQLite
 
 Context is used to do alot of operation on the data
 And once changes are finalized, we commit the changes by called context.save()
 
 */

