//
//  ViewController.swift
//  Todo-iOS
//
//  Created by Darshan on 30/06/21.
//

import UIKit

class TodoListController: UITableViewController {
    
    var itemArray = ["Do this", "Do that", "Do this"]
    
    
    let dafaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = self.dafaults.array(forKey: "TodoListArray") as? [String]{
            self.itemArray = items
        }
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text=itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Adding new item
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        var alertText = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                //Do something allclick
            self.itemArray.append(alertText.text!)
            self.dafaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new item"
            alertText = alertTextField
           
        }
        present(alert, animated: true, completion: nil)
    }
    
    
}

