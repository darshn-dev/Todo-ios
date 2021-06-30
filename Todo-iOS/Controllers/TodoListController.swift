//
//  ViewController.swift
//  Todo-iOS
//
//  Created by Darshan on 30/06/21.
//

import UIKit

class TodoListController: UITableViewController {
    
    var itemArray = [Item]()
    
    
    let dafaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print(dataFilePath)
        
        var newItem  = Item()
        newItem.title = "Go to market"
        self.itemArray.append(newItem)
        
        newItem  = Item()
        newItem.title = "Buy book"
        self.itemArray.append(newItem)
        
        newItem  = Item()
        newItem.title = "Read book"
        self.itemArray.append(newItem)
        
        newItem  = Item()
        newItem.title = "sleep"
        self.itemArray.append(newItem)
        
        if let items = self.dafaults.array(forKey: "TodoListArray") as? [Item]{
            self.itemArray = items
        }
        
        
        loadItems()
        // Do any additional setup after loading the view.
    }

    func loadItems()  {
        if  let data = try? Data(contentsOf: self.dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("error while decoding data")
            }
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
        self.saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Adding new item
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        var alertText = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                //Do something allclick
            let item = Item()
            item.title = alertText.text!
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
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to:dataFilePath!)
        }catch{
            
        }
        
    }
    
}

